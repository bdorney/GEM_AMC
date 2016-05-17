__author__ = 'evka'

import xml.etree.ElementTree as xml
import textwrap as tw

ADDRESS_TABLE_TOP = './address_table/gem_amc_top.xml'
CONSTANTS_FILE = '../common/hdl/pkg/registers.vhd'
BASH_STATUS_SCRIPT_FILE ='./ctp7_bash_scripts/generated/ctp7_status.sh'
BASH_REG_READ_SCRIPT_FILE='./ctp7_bash_scripts/generated/reg_read.sh'

TOP_NODE_NAME = 'GEM_AMC'
VHDL_REG_CONSTANT_PREFIX = 'REG_'

VHDL_REG_SIGNAL_MARKER_START = '------ Register signals begin'
VHDL_REG_SIGNAL_MARKER_END   = '------ Register signals end'

VHDL_REG_SLAVE_MARKER_START = '--==== Registers begin'
VHDL_REG_SLAVE_MARKER_END   = '--==== Registers end'

VHDL_REG_GENERATED_DISCLAIMER = '(this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py -- do not edit)'

AXI_IPB_BASE_ADDRESS = 0x64000000

class Module:
    name = ''
    description = ''
    baseAddress = 0x0
    regAddressMsb = None
    regAddressLsb = None
    file = ''
    userClock = ''
    busClock = ''
    busReset = ''
    masterBus = ''
    slaveBus = ''
    isExternal = False # if this is true it means that firmware doesn't have to be modified, only bash scripts will be generated

    def __init__(self):
        self.regs = []

    def addReg(self, reg):
        self.regs.append(reg)

    def isValid(self):
        if self.isExternal:
            return self.name is not None
        else:
            return self.name is not None and self.file is not None and self.userClock is not None and self.busClock is not None\
                   and self.busReset is not None and self.masterBus is not None and self.slaveBus is not None\
                   and self.regAddressMsb is not None and self.regAddressLsb is not None

    def toString(self):
        return str(self.name) + ' module: ' + str(self.description) + '\n'\
                         + '    Base address = ' + hex(self.baseAddress) + '\n'\
                         + '    Register address MSB = ' + hex(self.regAddressMsb) + '\n'\
                         + '    Register address LSB = ' + hex(self.regAddressLsb) + '\n'\
                         + '    File = ' + str(self.file) + '\n'\
                         + '    User clock = ' + str(self.userClock) + '\n'\
                         + '    Bus clock = ' + str(self.busClock) + '\n'\
                         + '    Bus reset = ' + str(self.busReset) + '\n'\
                         + '    Master_bus = ' + str(self.masterBus) + '\n'\
                         + '    Slave_bus = ' + str(self.slaveBus)

    def getVhdlName(self):
        return self.name.replace(TOP_NODE_NAME + '.', '')

class Register:
    name = ''
    address = 0x0
    description = ''
    permission = ''
    mask = 0x0
    signal = ''
    default = 0x0
    isWritePulse = False
    writePulseLength = 0
    readPulseSignal = None
    readPulseLength = None
    msb = -1
    lsb = -1

    def isValidReg(self, isExternal = False):
        if isExternal:
            return self.name is not None and self.address is not None and self.permission is not None\
                   and self.mask is not None
        else:
            return self.name is not None and self.address is not None and self.permission is not None\
                   and self.mask is not None and self.signal is not None\
                   and (self.default is not None or self.isWritePulse == True or self.permission == 'r')

    def toString(self):
        ret = 'Register ' + str(self.name) + ': ' + str(self.description) + '\n'\
              '    Address = ' + hex(self.address) + '\n'\
              '    Mask = ' + hexPadded32(self.mask) + '\n'\
              '    Permission = ' + str(self.permission) + '\n'\
              '    Signal = ' + str(self.signal) + '\n'\
              '    Default value = ' + hexPadded32(self.default) + '\n'\
              '    Is write pulse = ' + str(self.isWritePulse) + '\n'\

        if self.isWritePulse:
            ret += '\n        Write pulse length = ' + str(self.writePulseLength);

        if self.readPulseSignal is not None:
            ret += '\n    Read pulse signal = ' + str(self.readPulseSignal) + '\n'\
                   '        Read pulse length = ' + str(self.readPulseLength)
        return ret

    def getVhdlName(self):
        return self.name.replace(TOP_NODE_NAME + '.', '').replace('.', '_')

def main():
    print('Hi, parsing this top address table file: ' + ADDRESS_TABLE_TOP)

    tree = xml.parse(ADDRESS_TABLE_TOP)
    root = tree.getroot()[0]

    modules = []
    vars = {}

    findRegisters(root, '', 0x0, modules, None, vars, False)

    print('Modules:')
    for module in modules:
        module.regs.sort(key=lambda reg: reg.address * 100 + reg.msb)
        print('============================================================================')
        print(module.toString())
        print('============================================================================')
        for reg in module.regs:
            print(reg.toString())

    print('Writing constants file to ' + CONSTANTS_FILE)
    writeConstantsFile(modules, CONSTANTS_FILE)

    for module in modules:
        if not module.isExternal:
            updateModuleFile(module)

    writeStatusBashScript(modules, BASH_STATUS_SCRIPT_FILE)
    writeRegReadBashScript(modules, BASH_REG_READ_SCRIPT_FILE)

def findRegisters(node, baseName, baseAddress, modules, currentModule, vars, isGenerated):
    if (isGenerated == None or isGenerated == False) and node.get('generate') is not None and node.get('generate') == 'true':
        generateSize = parseInt(node.get('generate_size'))
        generateAddressStep = parseInt(node.get('generate_address_step'))
        generateIdxVar = node.get('generate_idx_var')
        for i in range(0, generateSize):
            vars[generateIdxVar] = i
            print('generate base_addr = ' + hex(baseAddress + generateAddressStep * i) + ' for node ' + node.get('id'))
            findRegisters(node, baseName, baseAddress + generateAddressStep * i, modules, currentModule, vars, True)
        return

    isModule = node.get('fw_is_module') is not None and node.get('fw_is_module') == 'true'
    name = baseName
    module = currentModule
    if baseName != '':
        name += '.'
    name += node.get('id')
    name = substituteVars(name, vars)
    address = baseAddress

    if isModule:
        module = Module()
        module.name = name
        module.description = substituteVars(node.get('description'), vars)
        module.baseAddress = parseInt(node.get('address'))
        if node.get('fw_is_module_external') is not None and node.get('fw_is_module_external') == 'true':
            module.isExternal = True
        else:
            module.regAddressMsb = parseInt(node.get('fw_reg_addr_msb'))
            module.regAddressLsb = parseInt(node.get('fw_reg_addr_lsb'))
            module.file = node.get('fw_module_file')
            module.userClock = node.get('fw_user_clock_signal')
            module.busClock = node.get('fw_bus_clock_signal')
            module.busReset = node.get('fw_bus_reset_signal')
            module.masterBus = node.get('fw_master_bus_signal')
            module.slaveBus = node.get('fw_slave_bus_signal')
        if not module.isValid():
            error = 'One or more parameters for module ' + module.name + ' is missing... ' + module.toString()
            raise ValueError(error)
        modules.append(module)
    else:
        if node.get('address') is not None:
            address = baseAddress + parseInt(node.get('address'))

        if node.get('address') is not None and node.get('permission') is not None and node.get('mask') is not None:
            reg = Register()
            reg.name = name
            reg.address = address
            reg.description = substituteVars(node.get('description'), vars)
            reg.permission = node.get('permission')
            reg.mask = parseInt(node.get('mask'))
            msb, lsb = getLowHighFromBitmask(reg.mask)
            reg.msb = msb
            reg.lsb = lsb
            reg.signal = substituteVars(node.get('fw_signal'), vars)
            reg.default = parseInt(node.get('fw_default'))
            if node.get('fw_is_write_pulse') is not None:
                reg.isWritePulse = bool(node.get('fw_is_write_pulse') == 'true')
            if node.get('fw_write_pulse_length') is not None:
                reg.writePulseLength = parseInt(node.get('fw_write_pulse_length'))
            if node.get('fw_read_pulse_signal') is not None:
                reg.readPulseSignal = node.get('fw_read_pulse_signal')
            if node.get('fw_read_pulse_length') is not None:
                reg.readPulseLength = parseInt(node.get('fw_read_pulse_length'))

            if module is None:
                error = 'Module is not set, cannot add register ' + reg.name
                raise ValueError(error)
            if not reg.isValidReg(module.isExternal):
                raise ValueError('One or more attributes for register %s are missing.. %s' % (reg.name, reg.toString()))

            module.addReg(reg)

    for child in node:
        findRegisters(child, name, address, modules, module, vars, False)

def writeConstantsFile(modules, filename):
    f = open(filename, 'w')
    f.write('library IEEE;\n'\
            'use IEEE.STD_LOGIC_1164.all;\n\n')
    f.write('-----> !! This package is auto-generated from an address table file using <repo_root>/scripts/generate_registers.py !! <-----\n')
    f.write('package registers is\n')

    for module in modules:
        if module.isExternal:
            continue

        totalRegs32 = getNumRequiredRegs32(module)

        # check if we have enough address bits for the max reg address (recall that the reg list is sorted by address)
        topAddressBinary = "{0:#0b}".format(module.regs[-1].address)
        numAddressBitsNeeded = len(topAddressBinary) - 2
        print('Top address of the registers is ' + hex(module.regs[-1].address) + ' (' + topAddressBinary + '), need ' + str(numAddressBitsNeeded) + ' bits and have ' + str(module.regAddressMsb - module.regAddressLsb + 1) + ' bits available')
        if numAddressBitsNeeded > module.regAddressMsb - module.regAddressLsb + 1:
            raise ValueError('There is not enough bits in the module address space to accomodate all registers (see above for details). Please modify fw_reg_addr_msb and/or fw_reg_addr_lsb attributes in the xml file')


        f.write('\n')
        f.write('    --============================================================================\n')
        f.write('    --       >>> ' + module.getVhdlName() + ' Module <<<    base address: ' + hexPadded32(module.baseAddress) + '\n')
        f.write('    --\n')
        for line in tw.wrap(module.description, 75):
            f.write('    -- ' + line + '\n')
        f.write('    --============================================================================\n\n')

        f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_NUM_REGS : integer := ' + str(totalRegs32) + ';\n')
        f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_ADDRESS_MSB : integer := ' + str(module.regAddressMsb) + ';\n')
        f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_ADDRESS_LSB : integer := ' + str(module.regAddressLsb) + ';\n')
        #f.write('    type T_' + VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_ADDRESS_ARR is array(integer range <>) of std_logic_vector(%s downto %s);\n\n' % (VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_ADDRESS_MSB', VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_ADDRESS_LSB')) # cannot use that because we need to be able to pass it as a generic type to the generic IPBus slave module

        for reg in module.regs:
            print('Writing register constants for ' + reg.name)
            f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_ADDR    : '\
                        'std_logic_vector(' + str(module.regAddressMsb) + ' downto ' + str(module.regAddressLsb) + ') := ' + \
                        vhdlHexPadded(reg.address, module.regAddressMsb - module.regAddressLsb + 1)  + ';\n')
            if reg.msb == reg.lsb:
                f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_BIT    : '\
                            'integer := ' + str(reg.msb) + ';\n')
            else:
                f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_MSB    : '\
                            'integer := ' + str(reg.msb) + ';\n')
                f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_LSB     : '\
                            'integer := ' + str(reg.lsb) + ';\n')
            if reg.default is not None and reg.msb - reg.lsb > 0:
                f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_DEFAULT : '\
                            'std_logic_vector(' + str(reg.msb) + ' downto ' + str(reg.lsb) + ') := ' + \
                            vhdlHexPadded(reg.default, reg.msb - reg.lsb + 1)  + ';\n')
            elif reg.default is not None and reg.msb - reg.lsb == 0:
                f.write('    constant ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_DEFAULT : '\
                            'std_logic := ' + \
                            vhdlHexPadded(reg.default, reg.msb - reg.lsb + 1)  + ';\n')
            f.write('\n')

    f.write('\n')
    f.write('end registers;\n')
    f.close()

def updateModuleFile(module):
    if module.isExternal:
        return

    totalRegs32 = getNumRequiredRegs32(module)
    print('Updating ' + module.name + ' module in file = ' + module.file)
    f = open(module.file, 'r+')
    lines = f.readlines()
    f.close()

    f = open(module.file, 'w')
    signalSectionFound = False
    signalSectionDone = False
    slaveSectionFound = False
    slaveSectionDone = False
    registersLibraryFound = False
    for line in lines:
        if line.startswith('use work.registers.all;'):
            registersLibraryFound = True

        # if we're outside of business of writing the special sections, then just repeat the lines we read from the original file
        if (not signalSectionFound or signalSectionDone) and (not slaveSectionFound or slaveSectionDone):
            f.write(line)
        elif (signalSectionFound and not signalSectionDone and VHDL_REG_SIGNAL_MARKER_END in line):
            signalSectionDone = True
            f.write(line)
        elif (slaveSectionFound and not slaveSectionDone and VHDL_REG_SLAVE_MARKER_END in line):
            slaveSectionDone = True
            f.write(line)

        # signal section
        if VHDL_REG_SIGNAL_MARKER_START in line:
            signalSectionFound = True
            signalDeclaration         = '    signal regs_read_arr        : t_std32_array(<num_regs> - 1 downto 0);\n'\
                                        '    signal regs_write_arr       : t_std32_array(<num_regs> - 1 downto 0);\n'\
                                        '    signal regs_addresses       : t_std32_array(<num_regs> - 1 downto 0);\n'\
                                        "    signal regs_defaults        : t_std32_array(<num_regs> - 1 downto 0) := (others => (others => '0'));\n"\
                                        '    signal regs_read_pulse_arr  : std_logic_vector(<num_regs> - 1 downto 0);\n'\
                                        '    signal regs_write_pulse_arr : std_logic_vector(<num_regs> - 1 downto 0);\n'
            signalDeclaration = signalDeclaration.replace('<num_regs>', VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_NUM_REGS')
            f.write(signalDeclaration)

        # slave section
        if VHDL_REG_SLAVE_MARKER_START in line:
            slaveSectionFound = True
            slaveDeclaration =  '    ipbus_slave_inst : entity work.ipbus_slave\n'\
                                '        generic map(\n'\
                                '           g_NUM_REGS             => %s,\n' % (VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_NUM_REGS') + \
                                '           g_ADDR_HIGH_BIT        => %s,\n' % (VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_ADDRESS_MSB') + \
                                '           g_ADDR_LOW_BIT         => %s,\n' % (VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_ADDRESS_LSB') + \
                                '           g_USE_INDIVIDUAL_ADDRS => "TRUE"\n'\
                                '       )\n'\
                                '       port map(\n'\
                                '           ipb_reset_i            => %s,\n' % (module.busReset) + \
                                '           ipb_clk_i              => %s,\n' % (module.busClock) + \
                                '           ipb_mosi_i             => %s,\n' % (module.masterBus) + \
                                '           ipb_miso_o             => %s,\n' % (module.slaveBus) + \
                                '           usr_clk_i              => %s,\n' % (module.userClock) + \
                                '           regs_read_arr_i        => regs_read_arr,\n'\
                                '           regs_write_arr_o       => regs_write_arr,\n'\
                                '           read_pulse_arr_o       => regs_read_pulse_arr,\n'\
                                '           write_pulse_arr_o      => regs_write_pulse_arr,\n'\
                                '           individual_addrs_arr_i => regs_addresses,\n'\
                                '           regs_defaults_arr_i    => regs_defaults\n'\
                                '      );\n'

            f.write('\n')
            f.write('    -- IPbus slave instanciation\n')
            f.write(slaveDeclaration)
            f.write('\n')

            # assign addresses
            uniqueAddresses = []
            for reg in module.regs:
                if not reg.address in uniqueAddresses:
                    uniqueAddresses.append(reg.address)
            if len(uniqueAddresses) != totalRegs32:
                raise ValueError("Something's worng.. Got a list of unique addresses which is of different length than the total number of 32bit addresses previously calculated..");

            f.write('    -- Addresses\n')
            for i in range(0, totalRegs32):
                f.write('    regs_addresses(%d)(%s downto %s) <= %s;\n' % (i, VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_ADDRESS_MSB', VHDL_REG_CONSTANT_PREFIX + module.getVhdlName() + '_ADDRESS_LSB', vhdlHexPadded(uniqueAddresses[i], module.regAddressMsb - module.regAddressLsb + 1))) # TODO: this is a hack using literal values - you should sort it out in the future and use constants (the thing is that the register address constants are not good for this since there are more of them than there are 32bit registers, so you need a constant for each group of regs that go to the same 32bit reg)
            f.write('\n')

            # connect read signals
            f.write('    -- Connect read signals\n')
            for reg in module.regs:
                isSingleBit = reg.msb == reg.lsb
                if 'r' in reg.permission:
                    f.write('    regs_read_arr(%d)(%s) <= %s;\n' % (uniqueAddresses.index(reg.address), VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_BIT' if isSingleBit else VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_MSB' + ' downto ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_LSB', reg.signal))

            f.write('\n')

            # connect write signals
            f.write('    -- Connect write signals\n')
            for reg in module.regs:
                isSingleBit = reg.msb == reg.lsb
                if reg.isWritePulse == True:
                    f.write('    -- NOTE: this should be a write pulse (not implemented yet in the generate_registers.py)\n')
                if 'w' in reg.permission:
                    f.write('    %s <= regs_write_arr(%d)(%s);\n' % (reg.signal, uniqueAddresses.index(reg.address), VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_BIT' if isSingleBit else VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_MSB' + ' downto ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_LSB'))
            f.write('\n')

            # connect write pulse signals
            # f.write('    -- Connect write pulse signals\n')
            # for reg in module.regs:
            #     isSingleBit = reg.msb == reg.lsb
            #     if 'w' in reg.permission and reg.isWritePulse == True:
            #         if not isSingleBit:
            #             raise ValueError("Only single bit registers are supported for write pulse signals: %s" % reg.name)
            #         if reg.writePulseLength == 0:
            #             raise ValueError("Found write pulse with pulse length = 0: %s" % reg.name)
            #         #if reg.writePulseLength == 1:
            #         #f.write('    %s <= regs_write_arr(%d)(%s);\n' % (reg.signal, uniqueAddresses.index(reg.address), VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_BIT' if isSingleBit else VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_MSB' + ' downto ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_LSB'))
            # f.write('\n')

            # Defaults
            f.write('    -- Defaults\n')
            for reg in module.regs:
                isSingleBit = reg.msb == reg.lsb
                if reg.default is not None:
                    f.write('    regs_defaults(%d)(%s) <= %s;\n' % (uniqueAddresses.index(reg.address), VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_BIT' if isSingleBit else VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_MSB' + ' downto ' + VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_LSB', VHDL_REG_CONSTANT_PREFIX + reg.getVhdlName() + '_DEFAULT'))
            f.write('\n')

    f.close()

    if not signalSectionFound or not signalSectionDone:
        print('--> ERROR <-- Could not find a signal section in the file.. Please include "' + VHDL_REG_SIGNAL_MARKER_START + '" and "' + VHDL_REG_SIGNAL_MARKER_END + '" comments denoting the area where the generated code will be inserted')
        print('        e.g. someting like that would work and look nice:')
        print('        ' + VHDL_REG_SIGNAL_MARKER_START + ' ' + VHDL_REG_GENERATED_DISCLAIMER)
        print('        ' + VHDL_REG_SIGNAL_MARKER_END + ' ----------------------------------------------')
        raise ValueError('No signal declaration markers found in %s -- see above' % module.file)

    if not slaveSectionFound or not slaveSectionDone:
        print('--> ERROR <-- Could not find a slave section in the file.. Please include "' + VHDL_REG_SLAVE_MARKER_START + '" and "' + VHDL_REG_SLAVE_MARKER_END + '" comments denoting the area where the generated code will be inserted')
        print('        e.g. someting like that would work and look nice:')
        print('        --===============================================================================================')
        print('        -- ' + VHDL_REG_GENERATED_DISCLAIMER)
        print('        ' + VHDL_REG_SLAVE_MARKER_START + ' ' + '==========================================================================')
        print('        ' + VHDL_REG_SLAVE_MARKER_END + ' ============================================================================')
        raise ValueError('No slave markers found in %s -- see above' % module.file)

    if not registersLibraryFound:
        raise ValueError('Registers library not included in %s -- please add "use work.registers.all;"' % module.file)

# prints out bash scripts for quick and dirty testing in CTP7 linux (TODO: compile and install python there and write a nice command line interface which would use the address table (something like acm13tool with reg names autocomplete would be cool)
def writeStatusBashScript(modules, filename):
    print('Writing CTP7 status bash script')

    f = open(filename, 'w')

    f.write('#!/bin/sh\n\n')
    f.write('MODULE=$1\n')

    f.write('if [ -z "$MODULE" ]; then\n')
    f.write('    echo "Usage: this_script.sh <module_name>"\n')
    f.write('    echo "Available modules:"\n')
    for module in modules:
        f.write('    echo "%s"' % module.name.replace(TOP_NODE_NAME + '.', ''))
    f.write('    exit\n')
    f.write('fi\n\n')

    for module in modules:
        f.write('if [ "$MODULE" = "%s" ]; then\n' % module.name.replace(TOP_NODE_NAME + '.', ''))
        for reg in module.regs:
            if 'r' in reg.permission:
                if reg.mask == 0xffffffff:
                    f.write("    printf '" + reg.name.ljust(45) + " = 0x%x\\n' `mpeek " + hex(AXI_IPB_BASE_ADDRESS + ((module.baseAddress + reg.address) << 2)) + "` \n")
                else:
                    f.write("    printf '" + reg.name.ljust(45) + " = 0x%x\\n' $(( (`mpeek " + hex(AXI_IPB_BASE_ADDRESS + ((module.baseAddress + reg.address) << 2)) + "` & " + hexPadded32(reg.mask) + ") >> " + str(reg.lsb) + " ))\n")
        f.write('fi\n\n')

# prints out bash script to read registers matching an expression
def writeRegReadBashScript(modules, filename):
    print('Writing CTP7 reg read bash script')

    f = open(filename, 'w')

    f.write('#!/bin/sh\n\n')
    f.write('REQUEST=$1\n\n')
    f.write('set -- ')

    for module in modules:
        for reg in module.regs:
            if 'r' in reg.permission:
                if reg.mask == 0xffffffff:
                    f.write('\\\n    "' + reg.name + ":`mpeek " + hex(AXI_IPB_BASE_ADDRESS + ((module.baseAddress + reg.address) << 2)) + "`\"")
#                    f.write('\\\n    "' + reg.name + ":`echo " + hex(AXI_IPB_BASE_ADDRESS + ((module.baseAddress + reg.address) << 2)) + "`\"")
                else:
                    f.write('\\\n    "' + reg.name + ":$(( (`mpeek " + hex(AXI_IPB_BASE_ADDRESS + ((module.baseAddress + reg.address) << 2)) + "` & " + hexPadded32(reg.mask) + ") >> " + str(reg.lsb) + " ))\"")
#                    f.write('\\\n    "' + reg.name + ":`echo " + hex(AXI_IPB_BASE_ADDRESS + ((module.baseAddress + reg.address) << 2)) + "`\"")

    f.write('\n\n')
    f.write('for reg; do\n')
    f.write('  KEY=${reg%%:*}\n')
    f.write('  case $KEY in\n')
    f.write("     *$REQUEST*) printf '%s            = 0x%x\\n' $KEY ${reg#*:};;\n")
    f.write('  esac\n')
    f.write('done\n')

# returns the number of required 32 bit registers for this module -- basically it counts the number of registers with different addresses
def getNumRequiredRegs32(module):
    totalRegs32 = 0
    if len(module.regs) > 0:
        totalRegs32 = 1
        lastAddress = module.regs[0].address
        for reg in module.regs:
            if reg.address != lastAddress:
                totalRegs32 += 1
                lastAddress = reg.address
    return totalRegs32

def hex(number):
    if number is None:
        return 'None'
    else:
        return "{0:#0x}".format(number)

def hexPadded32(number):
    if number is None:
        return 'None'
    else:
        return "{0:#0{1}x}".format(number, 10)

def binaryPadded32(number):
    if number is None:
        return 'None'
    else:
        return "{0:#0{1}b}".format(number, 34)

def vhdlHexPadded(number, numBits):
    if number is None:
        return 'None'
    else:
        hex32 = hexPadded32(number)
        binary32 = binaryPadded32(number)

        ret = ''

        # if the number is not aligned with hex nibbles, add  some binary in front
        numSingleBits = (numBits % 4)
        if (numSingleBits != 0):
            ret += "'" if numSingleBits == 1 else '"'
            # go back from the MSB down to the boundary of the most significant nibble
            for i in range(numBits, numBits // 4 * 4, -1):
                ret += binary32[i *  -1]
            ret += "'" if numSingleBits == 1 else '"'


        # add the right amount of hex characters

        if numBits // 4 > 0:
            if (numSingleBits != 0):
                ret += ' & '
            ret += 'x"'
            for i in range(numBits // 4, 0, -1):
                ret += hex32[i * -1]
            ret += '"'
        return ret


def parseInt(string):
    if string is None:
        return None
    elif string.startswith('0x'):
        return int(string, 16)
    elif string.startswith('0b'):
        return int(string, 2)
    else:
        return int(string)

def getLowHighFromBitmask(bitmask):
    binary32 = binaryPadded32(bitmask)
    lsb = -1
    msb = -1
    rangeDone = False
    for i in range(1, 33):
        if binary32[i * -1] == '1':
            if rangeDone == True:
                raise ValueError('Non-continuous bitmasks are not supported: %s' % hexPadded32(bitmask))
            if lsb == -1:
                lsb = i - 1
            msb = i - 1
        if lsb != -1 and binary32[i * -1] == '0':
            if rangeDone == False:
                rangeDone = True
    return msb, lsb

def substituteVars(string, vars):
    if string is None:
        return string
    ret = string
    for varKey in vars.keys():
        ret = ret.replace('${' + varKey + '}', str(vars[varKey]))
    return ret

if __name__ == '__main__':
    main()