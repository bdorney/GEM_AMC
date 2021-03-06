library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gem_board_config_package.CFG_NUM_OF_OHs;

package gem_pkg is

    --========================--
    --==  Firmware version  ==--
    --========================-- 

    constant C_FIRMWARE_DATE    : std_logic_vector(31 downto 0) := x"20181114";
    constant C_FIRMWARE_MAJOR   : integer range 0 to 255        := 1;
    constant C_FIRMWARE_MINOR   : integer range 0 to 255        := 16;
    constant C_FIRMWARE_BUILD   : integer range 0 to 255        := 0;
    
    ------ Change log ------
    -- 1.8.6  no gbt sync procedure with oh
    -- 1.8.7  advanced ILA trigger for gbt link
    -- 1.8.8  tied unused 8b10b or gbt links to 0
    -- 1.8.9  disable automatic phase shifting, just use unknown phase from 160MHz ref clock, also use bufg for the MMCM feedback clock
    -- 1.8.9  special version with 8b10b main link moved to OH2 and longer IPBusBridge timeout (comms with OH are perfect, but can't read VFATs at all)
    -- 1.9.0  fixed TX phase alignment, removed MMCM reset (was driven by the GTH startup FSM and messing things up).
    --        if 0 shifts are applied it's known to result in bad phase, so for now just made that if this happens, 
    --        then lock is never asserted, which will prevent GTH startup from completing and will be clearly visible during FPGA programming.
    -- 1.9.1  using TTC 120MHz as the GBT common RX clock instead of recovered clock from the main link (so all links should work even if link 1 is not connected)
    -- 1.9.2  separate SCA controlers for each channel implemented. There's also inbuilt ability to broadcast JTAG and custom SCA commands to any set of selected channels
    -- 1.9.3  Added SCA not ready counters (since last SCA reset). This will show if the SCA communication is stable (once established). 
    --        If yes, we could add an automatic SCA reset + configure after each time the SCA ready goes high after being low.
    -- 1.9.4  Swapped calpulse and bc0 bits in the GBT link because the OH was reading them backwards. Also re-enabled forwarding of resync and calpulse to OH.
    -- 1.10.0 Resync functionality added to the DAQ module. Note that OHs are only sent the resync signal AFTER the DAQ module has drained the buffers and reset.
    -- 1.11.0 Added zero suppression option in the DAQ module - it throws away the complete VFAT blocks where channel data is all zero.
    --        The VFAT payload word count is correctly indicated in the chamber header and trailer, but the zero suppression flags in the chamber header are 
    --        still not implemented because the VFAT order coming from OH is not guaranteed anyway (so can't tell which VFAT position was skipped anyway)..
    -- 1.11.1 Changed the default value of TTC_HARD_RESET_EN from 1 to 0 (TTC hard resets are not forwarded to OH by default)
    -- 1.11.2 Fixed a mismatched width bug when checking VFAT data for zero suppression. Extended reset_daq pulse for resync. Debug probes added for resync debugging.
    -- 1.11.3 Fixed a bug in resync procedure - has to also wait for DAQ output FIFO to drain before doing the reset
    -- 1.11.4 Updated DAQ timeout defaults to sensible values that work well with 100kHz of L1A rate
    -- 1.11.5 Updates in SCA ADC monitoring - setting fixed gain of 90% and enabling current source when measuring the PT100 ADC channels
    -- 1.11.6 Changed the SCA ADC MONITORING_OFF register default to 0xffffffff so that monitoring is off at startup
    -- 1.11.7 Debug version of DAQLink
    -- 1.11.8 Delay DAQ reset after resync by 4 clocks
    -- 1.11.9 Fix a possible deadlock in case of infifo underflow, in this case just put in some fake data and set a flag in the chamber trailer.
    -- 1.12.0 Added a lot of TTC clock monitoring features, including unlock counters and phase monitoring. It's also possible to reset or disable the phase alignment procedure through registers
    -- 1.12.1 Changed phase_unlock detection to only trigger if the PLL lock goes low  for several clock cycles (currently set at 12). Also added recording of minimum and maximum phase in phase monitor.
    -- 1.12.2 Shift out of phase initially after phase alignment reset (can be disabled with a register). Also a running mean of the phase measurement was added.
    -- 1.12.3 GTH PI clock phase adjustment implemented when shifting the MMCM outputs (which affects the TXUSRCLK phase). This should keep the GTH PI and TXUSRCLK reasonably in phase
    -- 1.12.4 Added GTH shift count and GTH shift error registers. Also set TXDLYBYPASS = 1, and TXPIPPMSEL = 1
    -- 1.12.5 Inverted the GTH shift direction w.r.t. MMCM shift direction, because in MMCM we're shifting the feedback clock, which actually shifts the outputs in the opposite direction..
    -- 1.12.6 Set TXDLYBYPASS back to 0, and set TXPIPPMSEL to 1 only when shifting the PI phase and only if PA_GTH_SHIFT_USE_SEL is set to 1 (GTH reset doesn't complete if it's set to 1).
    --        Also GTH PIPPM shift direction is configurable now. The delay between phase shifts is also configurable.
    -- 1.12.7 Configurable TXDLYBYPASS, and a possibility to do manual shifts using registers
    -- 1.12.8 Fixed a bug which previously prevented the GTH PIPPM shifting when doing a manual shift, so only the MMCM would be shifted
    -- 1.12.9 Fix manual shift pulse length, and add manual shift support for GTH PIPPM only. Also set TXDLYBYPASS to 1 by default, because it really messes up the MMCM shifting
    -- 1.12.10 Fix a bug in MMCM manual shifting, where a single write to manual shift enable register would sometimes not work or do multiple shifts
    -- 1.12.11 Added a manual PLL reset control
    -- 1.12.12 Added a way to do combined shifts: when PA_GTH_MANUAL_COMBINED, PA_GTH_MANUAL_OVERRIDE, and PA_MANUAL_OVERRIDE are set,
    --         then pulsing the PA_GTH_MANUAL_SHIFT_EN will shift the GTH and also when necessary it will shift the MMCM in a way that keeps the internal GTH phase unchanged, but results in MMCM shift w.r.t. TTC backplane clock
    --         (the MMCM shift direction is controlled automatically based on selected PA_GTH_MANUAL_SHIFT_DIR)
    -- 1.12.13 Added flipflops for ipb_mosi inputs in the ipbus_slave.vhd to ease the timing on the ipbus path
    -- 1.13.0  TTC commands are now latched using the backplane clock and buffered before decoding. The buffer is reset after a TTC module reset or a TTC resync command. This should avoid sampling bad TTC commands if the fabric clock phase shifts w.r.t. the backplane clock phase.
    --         After a reset the buffer is filled up to a specified amount controlled by the BUF_DEPTH_AFTER_RESET register, which is set to 8 by default (total available buffer depth is 16).
    --         Whenever the buffer depth exceeds a specified maximum depth (BUF_OOS_MAX_DEPTH, default = 9) or falls below a specified minimum depth level (BUF_OOS_MIN_DEPTH, default = 7), a TTS out-of-sync condition is triggered.
    --         While the buffer is being filled initially after a reset, a TTS busy state is asserted (this should only last for BUF_DEPTH_AFTER_RESET clock cycles, which is 8 by default).
    --         There are status registers to monitor the current buffer depth, buffer out of sync condition, and buffer busy condition.
    --         Note that this introduces additional L1A latency, equal to BUF_DEPTH_AFTER_RESET + 1, so frontend latency should be adjusted accordingly.
    -- 1.13.1  Wait until the TTC command FIFO has reset before enabling the writing
    -- 1.13.2  Switched to distributed RAM FIFO for TTC command buffer
    -- 1.13.3  Delay the check of OOS by 1 clock by starting to read 1 clock before asserting reset_done in the ttc command buffer logic
    -- 1.13.4  Fixed a few bugs in DAQ: zero suppression was causing event size overflow; the chamber TTS state was not being propagated to top TTS (except for the last chamber); the TTS countdown period after reset was not working (not a problem really)
    -- 1.14.0  Switched from end-of-event based on VFAT BC to OH EC and BC counters (default is using OH EC BC, but it can be switched back to VFAT BC with a registers). Also added OH EC BC counters to the readout in an unused spot of chamber trailer bits [31:0]
    -- 1.14.1  In PA phase monitor, the sampling clock source was switched from the backplane clock to the jitter cleaned MMCM clock. This is to check if the spread on the phase measurement would improve.
    -- 1.15.0  DAQ input processor is now also counting the number of zero suppressed VFAT words and putting that into the datastream, using a spot previously dedicated to per chamber zero suppression flags (bits [51:40] in chamber header). DAQ format version has been changed from 0 to 1 to reflect that.
    --         Also registers are available to read the current, min, and max "VFAT live word count", which is the number of non-zero-suppressed + zero-suppressed 64bit words (total should be equal to 24 * 3 in normal conditions regardless of zero suppression setting)
    --         Also this version introduces autokilling of bad links (is enabled by default, but can be disabled). When a given link times out more than a certain number of times in a row (this parameter is configurable, and is set to 100 by default), then this input will be autokilled.
    --         The autokill mask is reset during each resync. The autokill mask, and the individual link timeout counters (both consecutive and total) can be read with registers.
    --         Default values of the TTC command buffer min and max for OOS have been set to 2 and 4 respectively (previously these were set at 3 and 3).
    -- 1.15.1  Minor fixes related to input autokill: when an input is autokilled, also mask its TTS state, and also the consecutive timeout count for the first input had a bug related to resetting which was fixed
    -- 1.15.2  TTC buffer monitoring counters added: number of OOS instances, number of underflow and overflow instances, number of seconds since last OOS, last and max duration of the OOS state in clock cycles
    -- 1.15.3  ILA added to check the clocks and fifo signals in the TTC command buffer
    -- 1.16.0  Updated the Chip2Chip interface to be compatible with the new linux versions that support gemloader 
    
    --======================--
    --==      General     ==--
    --======================-- 
        
    constant C_LED_PULSE_LENGTH_TTC_CLK : std_logic_vector(20 downto 0) := std_logic_vector(to_unsigned(1_600_000, 21));

    function count_ones(s : std_logic_vector) return integer;
    function bool_to_std_logic(L : BOOLEAN) return std_logic;

    --======================--
    --== Config Constants ==--
    --======================-- 
    
    -- DAQ
    constant C_DAQ_FORMAT_VERSION     : std_logic_vector(3 downto 0)  := x"1";

    --============--
    --== Common ==--
    --============--   
    
    type t_std_array is array(integer range <>) of std_logic;
  
    type t_std32_array is array(integer range <>) of std_logic_vector(31 downto 0);
        
    type t_std16_array is array(integer range <>) of std_logic_vector(15 downto 0);

    type t_std24_array is array(integer range <>) of std_logic_vector(23 downto 0);

    type t_std4_array is array(integer range <>) of std_logic_vector(3 downto 0);

    type t_std2_array is array(integer range <>) of std_logic_vector(1 downto 0);

    --============--
    --==   GBT  ==--
    --============--   

    type t_gbt_frame_array is array(integer range <>) of std_logic_vector(83 downto 0);

    --========================--
    --== GTH/GTX link types ==--
    --========================--

    type t_gt_8b10b_tx_data is record
        txdata         : std_logic_vector(31 downto 0);
        txcharisk      : std_logic_vector(3 downto 0);
        txchardispmode : std_logic_vector(3 downto 0);
        txchardispval  : std_logic_vector(3 downto 0);
    end record;

    type t_gt_8b10b_rx_data is record
        rxdata          : std_logic_vector(31 downto 0);
        rxbyteisaligned : std_logic;
        rxbyterealign   : std_logic;
        rxcommadet      : std_logic;
        rxdisperr       : std_logic_vector(3 downto 0);
        rxnotintable    : std_logic_vector(3 downto 0);
        rxchariscomma   : std_logic_vector(3 downto 0);
        rxcharisk       : std_logic_vector(3 downto 0);
    end record;

    type t_gt_8b10b_tx_data_arr is array(integer range <>) of t_gt_8b10b_tx_data;
    type t_gt_8b10b_rx_data_arr is array(integer range <>) of t_gt_8b10b_rx_data;

    type t_gbt_mgt_tx_links is record
        tx0data          : std_logic_vector(39 downto 0); -- main GBT link for OH v2b 
        tx1data          : std_logic_vector(39 downto 0); -- this will only be used in OH v3 (for now this will just have a dummy load if CFG_USE_3x_GBTs is set to true)
        tx2data          : std_logic_vector(39 downto 0); -- this will only be used in OH v3 (for now this will just have a dummy load if CFG_USE_3x_GBTs is set to true)
    end record;

    type t_gbt_mgt_rx_links is record
        rx0clk           : std_logic;
        rx1clk           : std_logic;
        rx2clk           : std_logic;
        rx0data          : std_logic_vector(39 downto 0); -- main GBT link for OH v2b 
        rx1data          : std_logic_vector(39 downto 0); -- this will only be used in OH v3 (for now this will just have a dummy load if CFG_USE_3x_GBTs is set to true)
        rx2data          : std_logic_vector(39 downto 0); -- this will only be used in OH v3 (for now this will just have a dummy load if CFG_USE_3x_GBTs is set to true)
    end record;

    type t_gbt_mgt_rx_links_arr  is array(integer range <>) of t_gbt_mgt_rx_links;
    type t_gbt_mgt_tx_links_arr  is array(integer range <>) of t_gbt_mgt_tx_links;

    type t_gt_gbt_tx_data_arr is array(integer range <>) of std_logic_vector(39 downto 0);
    type t_gt_gbt_rx_data_arr is array(integer range <>) of std_logic_vector(39 downto 0);

    --========================--
    --== SBit cluster data  ==--
    --========================--

    type t_sbit_cluster is record
        size        : std_logic_vector(2 downto 0);
        address     : std_logic_vector(10 downto 0);
    end record;

    type t_oh_sbits is array(7 downto 0) of t_sbit_cluster;
    type t_oh_sbits_arr is array(integer range <>) of t_oh_sbits;

    type t_sbit_link_status is record
        valid           : std_logic;
        sync_word       : std_logic;
        missed_comma    : std_logic;
        underflow       : std_logic;
        overflow        : std_logic;
    end record;

    type t_oh_sbit_links is array(1 downto 0) of t_sbit_link_status;    
    type t_oh_sbit_links_arr is array(integer range <>) of t_oh_sbit_links;

    --====================--
    --==     DAQLink    ==--
    --====================--

    type t_daq_to_daqlink is record
        reset           : std_logic;
        ttc_clk         : std_logic;
        ttc_bc0         : std_logic;
        trig            : std_logic_vector(7 downto 0);
        tts_clk         : std_logic;
        tts_state       : std_logic_vector(3 downto 0);
        resync          : std_logic;
        event_clk       : std_logic;
        event_valid     : std_logic;
        event_header    : std_logic;
        event_trailer   : std_logic;
        event_data      : std_logic_vector(63 downto 0);
    end record;

    type t_daqlink_to_daq is record
        ready           : std_logic;
        almost_full     : std_logic;
        disperr_cnt     : std_logic_vector(15 downto 0);
        notintable_cnt  : std_logic_vector(15 downto 0);
    end record;

    --====================--
    --== DAQ data input ==--
    --====================--
    
    type t_data_link is record
        clk             : std_logic;
        data_en    : std_logic;
        data       : std_logic_vector(15 downto 0);
    end record;
    
    type t_data_link_array is array(integer range <>) of t_data_link;    

    --=====================================--
    --==   DAQ input status and control  ==--
    --=====================================--
    
    type t_daq_input_status is record
        evtfifo_empty               : std_logic;
        evtfifo_near_full           : std_logic;
        evtfifo_full                : std_logic;
        evtfifo_underflow           : std_logic;
        evtfifo_near_full_cnt       : std_logic_vector(15 downto 0);
        evtfifo_wr_rate             : std_logic_vector(16 downto 0);
        infifo_empty                : std_logic;
        infifo_near_full            : std_logic;
        infifo_full                 : std_logic;
        infifo_underflow            : std_logic;
        infifo_near_full_cnt        : std_logic_vector(15 downto 0);
        infifo_wr_rate              : std_logic_vector(14 downto 0);
        tts_state                   : std_logic_vector(3 downto 0);
        err_event_too_big           : std_logic;
        err_evtfifo_full            : std_logic;
        err_infifo_underflow        : std_logic;
        err_infifo_full             : std_logic;
        err_corrupted_vfat_data     : std_logic;
        err_vfat_block_too_big      : std_logic;
        err_vfat_block_too_small    : std_logic;
        err_event_bigger_than_24    : std_logic;
        err_mixed_oh_bc             : std_logic;
        err_mixed_vfat_bc           : std_logic;
        err_mixed_vfat_ec           : std_logic;
        cnt_corrupted_vfat          : std_logic_vector(31 downto 0);
        eb_event_num                : std_logic_vector(23 downto 0);
        eb_max_timer                : std_logic_vector(23 downto 0);
        eb_last_timer               : std_logic_vector(23 downto 0);
        ep_vfat_block_data          : t_std32_array(6 downto 0);
        eb_vfat_live_words_64       : std_logic_vector(11 downto 0);
        eb_vfat_live_words_64_min   : std_logic_vector(11 downto 0);
        eb_vfat_live_words_64_max   : std_logic_vector(11 downto 0);
    end record;

    type t_daq_input_status_arr is array(integer range <>) of t_daq_input_status;

    type t_daq_input_control is record
        eb_timeout_delay        : std_logic_vector(23 downto 0);
        eb_zero_supression_en   : std_logic;
        eb_eoe_use_oh_ec_bc     : std_logic;
    end record;
    
    type t_daq_input_control_arr is array(integer range <>) of t_daq_input_control;

    --====================--
    --==   DAQ other    ==--
    --====================--

    type t_chamber_infifo_rd is record
        dout          : std_logic_vector(191 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
        data_cnt      : std_logic_vector(11 downto 0);
    end record;

    type t_chamber_infifo_rd_array is array(integer range <>) of t_chamber_infifo_rd;

    type t_chamber_evtfifo_rd is record
        dout          : std_logic_vector(103 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
        data_cnt      : std_logic_vector(11 downto 0);
    end record;

    type t_chamber_evtfifo_rd_array is array(integer range <>) of t_chamber_evtfifo_rd;

    --====================--
    --==     OH Link    ==--
    --====================--

    type t_sync_fifo_status is record
        ovf         : std_logic;
        unf         : std_logic;
    end record;
    
    type t_gt_status is record
        not_in_table    : std_logic;
        disperr         : std_logic;
    end record;

    type t_oh_link_status is record
        tk_error            : std_logic;
        evt_rcvd            : std_logic;
        tk_tx_sync_status   : t_sync_fifo_status;      
        tk_rx_sync_status   : t_sync_fifo_status;      
        tr0_rx_sync_status  : t_sync_fifo_status;      
        tr1_rx_sync_status  : t_sync_fifo_status;
        tk_rx_gt_status     : t_gt_status;     
        tr0_rx_gt_status    : t_gt_status;     
        tr1_rx_gt_status    : t_gt_status;     
    end record;
    
    type t_oh_link_status_arr is array(integer range <>) of t_oh_link_status;    
        
    --================--
    --== T1 command ==--
    --================--
    
    type t_t1 is record
        lv1a        : std_logic;
        calpulse    : std_logic;
        resync      : std_logic;
        bc0         : std_logic;
    end record;
    
    type t_t1_array is array(integer range <>) of t_t1;
	
end gem_pkg;
   
package body gem_pkg is

    function count_ones(s : std_logic_vector) return integer is
        variable temp : natural := 0;
    begin
        for i in s'range loop
            if s(i) = '1' then
                temp := temp + 1;
            end if;
        end loop;

        return temp;
    end function count_ones;

    function bool_to_std_logic(L : BOOLEAN) return std_logic is
    begin
        if L then
            return ('1');
        else
            return ('0');
        end if;
    end function bool_to_std_logic;
    
end gem_pkg;
