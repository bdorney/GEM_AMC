#!/bin/sh

MODULE=$1
if [ -z "$MODULE" ]; then
    echo "Usage: this_script.sh <module_name>"
    echo "Available modules:"
    echo "TTC"    echo "TRIGGER"    echo "GEM_SYSTEM"    echo "DAQ"    echo "OH_LINKS"    echo "OH"    exit
fi

if [ "$MODULE" = "TTC" ]; then
    printf 'GEM_AMC.TTC.CTRL.L1A_ENABLE                   = 0x%x\n' $(( (`mpeek 0x64c00000` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_BC0                    = 0x%x\n' $(( (`mpeek 0x64c00004` & 0x000000ff) >> 0 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_EC0                    = 0x%x\n' $(( (`mpeek 0x64c00004` & 0x0000ff00) >> 8 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_RESYNC                 = 0x%x\n' $(( (`mpeek 0x64c00004` & 0x00ff0000) >> 16 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_OC0                    = 0x%x\n' $(( (`mpeek 0x64c00004` & 0xff000000) >> 24 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_HARD_RESET             = 0x%x\n' $(( (`mpeek 0x64c00008` & 0x000000ff) >> 0 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_CALPULSE               = 0x%x\n' $(( (`mpeek 0x64c00008` & 0x0000ff00) >> 8 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_START                  = 0x%x\n' $(( (`mpeek 0x64c00008` & 0x00ff0000) >> 16 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_STOP                   = 0x%x\n' $(( (`mpeek 0x64c00008` & 0xff000000) >> 24 ))
    printf 'GEM_AMC.TTC.CONFIG.CMD_TEST_SYNC              = 0x%x\n' $(( (`mpeek 0x64c0000c` & 0x000000ff) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.MMCM_LOCKED                = 0x%x\n' $(( (`mpeek 0x64c00010` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.TTC_SINGLE_ERROR_CNT       = 0x%x\n' $(( (`mpeek 0x64c00014` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.TTC_DOUBLE_ERROR_CNT       = 0x%x\n' $(( (`mpeek 0x64c00014` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.LOCKED                 = 0x%x\n' $(( (`mpeek 0x64c00018` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.UNLOCK_CNT             = 0x%x\n' $(( (`mpeek 0x64c0001c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.OVERFLOW_CNT           = 0x%x\n' $(( (`mpeek 0x64c00020` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TTC.STATUS.BC0.UNDERFLOW_CNT          = 0x%x\n' $(( (`mpeek 0x64c00020` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TTC.CMD_COUNTERS.L1A                  = 0x%x\n' `mpeek 0x64c00024` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.BC0                  = 0x%x\n' `mpeek 0x64c00028` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.EC0                  = 0x%x\n' `mpeek 0x64c0002c` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.RESYNC               = 0x%x\n' `mpeek 0x64c00030` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.OC0                  = 0x%x\n' `mpeek 0x64c00034` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.HARD_RESET           = 0x%x\n' `mpeek 0x64c00038` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.CALPULSE             = 0x%x\n' `mpeek 0x64c0003c` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.START                = 0x%x\n' `mpeek 0x64c00040` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.STOP                 = 0x%x\n' `mpeek 0x64c00044` 
    printf 'GEM_AMC.TTC.CMD_COUNTERS.TEST_SYNC            = 0x%x\n' `mpeek 0x64c00048` 
    printf 'GEM_AMC.TTC.L1A_ID                            = 0x%x\n' $(( (`mpeek 0x64c0004c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.TTC.TTC_SPY_BUFFER                    = 0x%x\n' `mpeek 0x64c00050` 
fi

if [ "$MODULE" = "TRIGGER" ]; then
    printf 'GEM_AMC.TRIGGER.CTRL.OH_KILL_MASK             = 0x%x\n' $(( (`mpeek 0x66000004` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.STATUS.OR_TRIGGER_RATE        = 0x%x\n' `mpeek 0x66000040` 
    printf 'GEM_AMC.TRIGGER.OH0.TRIGGER_RATE              = 0x%x\n' `mpeek 0x66000400` 
    printf 'GEM_AMC.TRIGGER.OH0.CLUSTER_SIZE_0_RATE       = 0x%x\n' `mpeek 0x66000404` 
    printf 'GEM_AMC.TRIGGER.OH0.CLUSTER_SIZE_1_RATE       = 0x%x\n' `mpeek 0x66000408` 
    printf 'GEM_AMC.TRIGGER.OH0.CLUSTER_SIZE_2_RATE       = 0x%x\n' `mpeek 0x6600040c` 
    printf 'GEM_AMC.TRIGGER.OH0.CLUSTER_SIZE_3_RATE       = 0x%x\n' `mpeek 0x66000410` 
    printf 'GEM_AMC.TRIGGER.OH0.CLUSTER_SIZE_4_RATE       = 0x%x\n' `mpeek 0x66000414` 
    printf 'GEM_AMC.TRIGGER.OH0.CLUSTER_SIZE_5_RATE       = 0x%x\n' `mpeek 0x66000418` 
    printf 'GEM_AMC.TRIGGER.OH0.CLUSTER_SIZE_6_RATE       = 0x%x\n' `mpeek 0x6600041c` 
    printf 'GEM_AMC.TRIGGER.OH0.CLUSTER_SIZE_7_RATE       = 0x%x\n' `mpeek 0x66000420` 
    printf 'GEM_AMC.TRIGGER.OH0.CLUSTER_SIZE_8_RATE       = 0x%x\n' `mpeek 0x66000424` 
    printf 'GEM_AMC.TRIGGER.OH0.LINK0_NOT_VALID_CNT       = 0x%x\n' $(( (`mpeek 0x66000428` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.LINK1_NOT_VALID_CNT       = 0x%x\n' $(( (`mpeek 0x66000428` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH0.LINK0_MISSED_COMMA_CNT    = 0x%x\n' $(( (`mpeek 0x6600042c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.LINK1_MISSED_COMMA_CNT    = 0x%x\n' $(( (`mpeek 0x6600042c` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH0.LINK0_OVERFLOW_CNT        = 0x%x\n' $(( (`mpeek 0x66000430` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.LINK1_OVERFLOW_CNT        = 0x%x\n' $(( (`mpeek 0x66000430` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH0.LINK0_UNDERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000434` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.LINK1_UNDERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000434` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH0.LINK0_SYNC_WORD_CNT       = 0x%x\n' $(( (`mpeek 0x66000438` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.LINK1_SYNC_WORD_CNT       = 0x%x\n' $(( (`mpeek 0x66000438` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH0.DEBUG_LAST_CLUSTER_0      = 0x%x\n' $(( (`mpeek 0x66000440` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.DEBUG_LAST_CLUSTER_1      = 0x%x\n' $(( (`mpeek 0x66000444` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.DEBUG_LAST_CLUSTER_2      = 0x%x\n' $(( (`mpeek 0x66000448` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.DEBUG_LAST_CLUSTER_3      = 0x%x\n' $(( (`mpeek 0x6600044c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.DEBUG_LAST_CLUSTER_4      = 0x%x\n' $(( (`mpeek 0x66000450` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.DEBUG_LAST_CLUSTER_5      = 0x%x\n' $(( (`mpeek 0x66000454` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.DEBUG_LAST_CLUSTER_6      = 0x%x\n' $(( (`mpeek 0x66000458` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH0.DEBUG_LAST_CLUSTER_7      = 0x%x\n' $(( (`mpeek 0x6600045c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.TRIGGER_RATE              = 0x%x\n' `mpeek 0x66000800` 
    printf 'GEM_AMC.TRIGGER.OH1.CLUSTER_SIZE_0_RATE       = 0x%x\n' `mpeek 0x66000804` 
    printf 'GEM_AMC.TRIGGER.OH1.CLUSTER_SIZE_1_RATE       = 0x%x\n' `mpeek 0x66000808` 
    printf 'GEM_AMC.TRIGGER.OH1.CLUSTER_SIZE_2_RATE       = 0x%x\n' `mpeek 0x6600080c` 
    printf 'GEM_AMC.TRIGGER.OH1.CLUSTER_SIZE_3_RATE       = 0x%x\n' `mpeek 0x66000810` 
    printf 'GEM_AMC.TRIGGER.OH1.CLUSTER_SIZE_4_RATE       = 0x%x\n' `mpeek 0x66000814` 
    printf 'GEM_AMC.TRIGGER.OH1.CLUSTER_SIZE_5_RATE       = 0x%x\n' `mpeek 0x66000818` 
    printf 'GEM_AMC.TRIGGER.OH1.CLUSTER_SIZE_6_RATE       = 0x%x\n' `mpeek 0x6600081c` 
    printf 'GEM_AMC.TRIGGER.OH1.CLUSTER_SIZE_7_RATE       = 0x%x\n' `mpeek 0x66000820` 
    printf 'GEM_AMC.TRIGGER.OH1.CLUSTER_SIZE_8_RATE       = 0x%x\n' `mpeek 0x66000824` 
    printf 'GEM_AMC.TRIGGER.OH1.LINK0_NOT_VALID_CNT       = 0x%x\n' $(( (`mpeek 0x66000828` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.LINK1_NOT_VALID_CNT       = 0x%x\n' $(( (`mpeek 0x66000828` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH1.LINK0_MISSED_COMMA_CNT    = 0x%x\n' $(( (`mpeek 0x6600082c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.LINK1_MISSED_COMMA_CNT    = 0x%x\n' $(( (`mpeek 0x6600082c` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH1.LINK0_OVERFLOW_CNT        = 0x%x\n' $(( (`mpeek 0x66000830` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.LINK1_OVERFLOW_CNT        = 0x%x\n' $(( (`mpeek 0x66000830` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH1.LINK0_UNDERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000834` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.LINK1_UNDERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000834` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH1.LINK0_SYNC_WORD_CNT       = 0x%x\n' $(( (`mpeek 0x66000838` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.LINK1_SYNC_WORD_CNT       = 0x%x\n' $(( (`mpeek 0x66000838` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH1.DEBUG_LAST_CLUSTER_0      = 0x%x\n' $(( (`mpeek 0x66000840` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.DEBUG_LAST_CLUSTER_1      = 0x%x\n' $(( (`mpeek 0x66000844` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.DEBUG_LAST_CLUSTER_2      = 0x%x\n' $(( (`mpeek 0x66000848` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.DEBUG_LAST_CLUSTER_3      = 0x%x\n' $(( (`mpeek 0x6600084c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.DEBUG_LAST_CLUSTER_4      = 0x%x\n' $(( (`mpeek 0x66000850` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.DEBUG_LAST_CLUSTER_5      = 0x%x\n' $(( (`mpeek 0x66000854` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.DEBUG_LAST_CLUSTER_6      = 0x%x\n' $(( (`mpeek 0x66000858` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH1.DEBUG_LAST_CLUSTER_7      = 0x%x\n' $(( (`mpeek 0x6600085c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.TRIGGER_RATE              = 0x%x\n' `mpeek 0x66000c00` 
    printf 'GEM_AMC.TRIGGER.OH2.CLUSTER_SIZE_0_RATE       = 0x%x\n' `mpeek 0x66000c04` 
    printf 'GEM_AMC.TRIGGER.OH2.CLUSTER_SIZE_1_RATE       = 0x%x\n' `mpeek 0x66000c08` 
    printf 'GEM_AMC.TRIGGER.OH2.CLUSTER_SIZE_2_RATE       = 0x%x\n' `mpeek 0x66000c0c` 
    printf 'GEM_AMC.TRIGGER.OH2.CLUSTER_SIZE_3_RATE       = 0x%x\n' `mpeek 0x66000c10` 
    printf 'GEM_AMC.TRIGGER.OH2.CLUSTER_SIZE_4_RATE       = 0x%x\n' `mpeek 0x66000c14` 
    printf 'GEM_AMC.TRIGGER.OH2.CLUSTER_SIZE_5_RATE       = 0x%x\n' `mpeek 0x66000c18` 
    printf 'GEM_AMC.TRIGGER.OH2.CLUSTER_SIZE_6_RATE       = 0x%x\n' `mpeek 0x66000c1c` 
    printf 'GEM_AMC.TRIGGER.OH2.CLUSTER_SIZE_7_RATE       = 0x%x\n' `mpeek 0x66000c20` 
    printf 'GEM_AMC.TRIGGER.OH2.CLUSTER_SIZE_8_RATE       = 0x%x\n' `mpeek 0x66000c24` 
    printf 'GEM_AMC.TRIGGER.OH2.LINK0_NOT_VALID_CNT       = 0x%x\n' $(( (`mpeek 0x66000c28` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.LINK1_NOT_VALID_CNT       = 0x%x\n' $(( (`mpeek 0x66000c28` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH2.LINK0_MISSED_COMMA_CNT    = 0x%x\n' $(( (`mpeek 0x66000c2c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.LINK1_MISSED_COMMA_CNT    = 0x%x\n' $(( (`mpeek 0x66000c2c` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH2.LINK0_OVERFLOW_CNT        = 0x%x\n' $(( (`mpeek 0x66000c30` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.LINK1_OVERFLOW_CNT        = 0x%x\n' $(( (`mpeek 0x66000c30` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH2.LINK0_UNDERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000c34` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.LINK1_UNDERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66000c34` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH2.LINK0_SYNC_WORD_CNT       = 0x%x\n' $(( (`mpeek 0x66000c38` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.LINK1_SYNC_WORD_CNT       = 0x%x\n' $(( (`mpeek 0x66000c38` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH2.DEBUG_LAST_CLUSTER_0      = 0x%x\n' $(( (`mpeek 0x66000c40` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.DEBUG_LAST_CLUSTER_1      = 0x%x\n' $(( (`mpeek 0x66000c44` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.DEBUG_LAST_CLUSTER_2      = 0x%x\n' $(( (`mpeek 0x66000c48` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.DEBUG_LAST_CLUSTER_3      = 0x%x\n' $(( (`mpeek 0x66000c4c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.DEBUG_LAST_CLUSTER_4      = 0x%x\n' $(( (`mpeek 0x66000c50` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.DEBUG_LAST_CLUSTER_5      = 0x%x\n' $(( (`mpeek 0x66000c54` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.DEBUG_LAST_CLUSTER_6      = 0x%x\n' $(( (`mpeek 0x66000c58` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH2.DEBUG_LAST_CLUSTER_7      = 0x%x\n' $(( (`mpeek 0x66000c5c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.TRIGGER_RATE              = 0x%x\n' `mpeek 0x66001000` 
    printf 'GEM_AMC.TRIGGER.OH3.CLUSTER_SIZE_0_RATE       = 0x%x\n' `mpeek 0x66001004` 
    printf 'GEM_AMC.TRIGGER.OH3.CLUSTER_SIZE_1_RATE       = 0x%x\n' `mpeek 0x66001008` 
    printf 'GEM_AMC.TRIGGER.OH3.CLUSTER_SIZE_2_RATE       = 0x%x\n' `mpeek 0x6600100c` 
    printf 'GEM_AMC.TRIGGER.OH3.CLUSTER_SIZE_3_RATE       = 0x%x\n' `mpeek 0x66001010` 
    printf 'GEM_AMC.TRIGGER.OH3.CLUSTER_SIZE_4_RATE       = 0x%x\n' `mpeek 0x66001014` 
    printf 'GEM_AMC.TRIGGER.OH3.CLUSTER_SIZE_5_RATE       = 0x%x\n' `mpeek 0x66001018` 
    printf 'GEM_AMC.TRIGGER.OH3.CLUSTER_SIZE_6_RATE       = 0x%x\n' `mpeek 0x6600101c` 
    printf 'GEM_AMC.TRIGGER.OH3.CLUSTER_SIZE_7_RATE       = 0x%x\n' `mpeek 0x66001020` 
    printf 'GEM_AMC.TRIGGER.OH3.CLUSTER_SIZE_8_RATE       = 0x%x\n' `mpeek 0x66001024` 
    printf 'GEM_AMC.TRIGGER.OH3.LINK0_NOT_VALID_CNT       = 0x%x\n' $(( (`mpeek 0x66001028` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.LINK1_NOT_VALID_CNT       = 0x%x\n' $(( (`mpeek 0x66001028` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH3.LINK0_MISSED_COMMA_CNT    = 0x%x\n' $(( (`mpeek 0x6600102c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.LINK1_MISSED_COMMA_CNT    = 0x%x\n' $(( (`mpeek 0x6600102c` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH3.LINK0_OVERFLOW_CNT        = 0x%x\n' $(( (`mpeek 0x66001030` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.LINK1_OVERFLOW_CNT        = 0x%x\n' $(( (`mpeek 0x66001030` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH3.LINK0_UNDERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66001034` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.LINK1_UNDERFLOW_CNT       = 0x%x\n' $(( (`mpeek 0x66001034` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH3.LINK0_SYNC_WORD_CNT       = 0x%x\n' $(( (`mpeek 0x66001038` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.LINK1_SYNC_WORD_CNT       = 0x%x\n' $(( (`mpeek 0x66001038` & 0xffff0000) >> 16 ))
    printf 'GEM_AMC.TRIGGER.OH3.DEBUG_LAST_CLUSTER_0      = 0x%x\n' $(( (`mpeek 0x66001040` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.DEBUG_LAST_CLUSTER_1      = 0x%x\n' $(( (`mpeek 0x66001044` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.DEBUG_LAST_CLUSTER_2      = 0x%x\n' $(( (`mpeek 0x66001048` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.DEBUG_LAST_CLUSTER_3      = 0x%x\n' $(( (`mpeek 0x6600104c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.DEBUG_LAST_CLUSTER_4      = 0x%x\n' $(( (`mpeek 0x66001050` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.DEBUG_LAST_CLUSTER_5      = 0x%x\n' $(( (`mpeek 0x66001054` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.DEBUG_LAST_CLUSTER_6      = 0x%x\n' $(( (`mpeek 0x66001058` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.TRIGGER.OH3.DEBUG_LAST_CLUSTER_7      = 0x%x\n' $(( (`mpeek 0x6600105c` & 0x0000ffff) >> 0 ))
fi

if [ "$MODULE" = "GEM_SYSTEM" ]; then
    printf 'GEM_AMC.GEM_SYSTEM.TK_LINK_RX_POLARITY        = 0x%x\n' $(( (`mpeek 0x66400000` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.GEM_SYSTEM.TK_LINK_TX_POLARITY        = 0x%x\n' $(( (`mpeek 0x66400004` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.GEM_SYSTEM.BOARD_ID                   = 0x%x\n' $(( (`mpeek 0x66400008` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.GEM_SYSTEM.RELEASE_BUILD              = 0x%x\n' $(( (`mpeek 0x6640000c` & 0x000000ff) >> 0 ))
    printf 'GEM_AMC.GEM_SYSTEM.RELEASE_MINOR              = 0x%x\n' $(( (`mpeek 0x6640000c` & 0x0000ff00) >> 8 ))
    printf 'GEM_AMC.GEM_SYSTEM.RELEASE_MAJOR              = 0x%x\n' $(( (`mpeek 0x6640000c` & 0x00ff0000) >> 16 ))
    printf 'GEM_AMC.GEM_SYSTEM.RELEASE_DAY                = 0x%x\n' $(( (`mpeek 0x66400010` & 0x000000ff) >> 0 ))
    printf 'GEM_AMC.GEM_SYSTEM.RELEASE_MONTH              = 0x%x\n' $(( (`mpeek 0x66400010` & 0x00000f00) >> 8 ))
    printf 'GEM_AMC.GEM_SYSTEM.RELEASE_YEAR               = 0x%x\n' $(( (`mpeek 0x66400010` & 0xfff00000) >> 20 ))
fi

if [ "$MODULE" = "DAQ" ]; then
    printf 'GEM_AMC.DAQ.CONTROL.DAQ_ENABLE                = 0x%x\n' $(( (`mpeek 0x65c00000` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.DAQ.CONTROL.DAQ_LINK_RESET            = 0x%x\n' $(( (`mpeek 0x65c00000` & 0x00000004) >> 2 ))
    printf 'GEM_AMC.DAQ.CONTROL.RESET                     = 0x%x\n' $(( (`mpeek 0x65c00000` & 0x00000008) >> 3 ))
    printf 'GEM_AMC.DAQ.CONTROL.TTS_OVERRIDE              = 0x%x\n' $(( (`mpeek 0x65c00000` & 0x000000f0) >> 4 ))
    printf 'GEM_AMC.DAQ.CONTROL.INPUT_ENABLE_MASK         = 0x%x\n' $(( (`mpeek 0x65c00000` & 0xffffff00) >> 8 ))
    printf 'GEM_AMC.DAQ.STATUS.DAQ_LINK_RDY               = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.DAQ.STATUS.DAQ_CLK_LOCKED             = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000002) >> 1 ))
    printf 'GEM_AMC.DAQ.STATUS.TTC_RDY                    = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000004) >> 2 ))
    printf 'GEM_AMC.DAQ.STATUS.DAQ_LINK_AFULL             = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000008) >> 3 ))
    printf 'GEM_AMC.DAQ.STATUS.TTC_BC0_LOCKED             = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00000010) >> 4 ))
    printf 'GEM_AMC.DAQ.STATUS.L1A_FIFO_HAD_OVERFLOW      = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x00800000) >> 23 ))
    printf 'GEM_AMC.DAQ.STATUS.L1A_FIFO_IS_UNDERFLOW      = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x01000000) >> 24 ))
    printf 'GEM_AMC.DAQ.STATUS.L1A_FIFO_IS_FULL           = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x02000000) >> 25 ))
    printf 'GEM_AMC.DAQ.STATUS.L1A_FIFO_IS_NEAR_FULL      = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x04000000) >> 26 ))
    printf 'GEM_AMC.DAQ.STATUS.L1A_FIFO_IS_EMPTY          = 0x%x\n' $(( (`mpeek 0x65c00004` & 0x08000000) >> 27 ))
    printf 'GEM_AMC.DAQ.STATUS.TTS_STATE                  = 0x%x\n' $(( (`mpeek 0x65c00004` & 0xf0000000) >> 28 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.NOTINTABLE_ERR         = 0x%x\n' $(( (`mpeek 0x65c00008` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.DISPER_ERR             = 0x%x\n' $(( (`mpeek 0x65c0000c` & 0x0000ffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.L1AID                  = 0x%x\n' $(( (`mpeek 0x65c00010` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.EVT_SENT               = 0x%x\n' `mpeek 0x65c00014` 
    printf 'GEM_AMC.DAQ.CONTROL.DAV_TIMEOUT               = 0x%x\n' $(( (`mpeek 0x65c00018` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.MAX_DAV_TIMER          = 0x%x\n' $(( (`mpeek 0x65c0001c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_STATUS.LAST_DAV_TIMER         = 0x%x\n' $(( (`mpeek 0x65c00020` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_CONTROL.RUN_PARAMS            = 0x%x\n' $(( (`mpeek 0x65c0003c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.EXT_CONTROL.RUN_TYPE              = 0x%x\n' $(( (`mpeek 0x65c0003c` & 0x0f000000) >> 24 ))
    printf 'GEM_AMC.DAQ.OH0.COUNTERS.CORRUPT_VFAT_BLK_CNT = 0x%x\n' `mpeek 0x65c00044` 
    printf 'GEM_AMC.DAQ.OH0.COUNTERS.EVN                  = 0x%x\n' $(( (`mpeek 0x65c00048` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH0.CONTROL.EOE_TIMEOUT           = 0x%x\n' $(( (`mpeek 0x65c0004c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH0.COUNTERS.MAX_EOE_TIMER        = 0x%x\n' $(( (`mpeek 0x65c0005c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH0.COUNTERS.LAST_EOE_TIMER       = 0x%x\n' $(( (`mpeek 0x65c00060` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH0.LASTBLOCK0                    = 0x%x\n' `mpeek 0x65c00064` 
    printf 'GEM_AMC.DAQ.OH0.LASTBLOCK1                    = 0x%x\n' `mpeek 0x65c00068` 
    printf 'GEM_AMC.DAQ.OH0.LASTBLOCK2                    = 0x%x\n' `mpeek 0x65c0006c` 
    printf 'GEM_AMC.DAQ.OH0.LASTBLOCK3                    = 0x%x\n' `mpeek 0x65c00070` 
    printf 'GEM_AMC.DAQ.OH0.LASTBLOCK4                    = 0x%x\n' `mpeek 0x65c00074` 
    printf 'GEM_AMC.DAQ.OH0.LASTBLOCK5                    = 0x%x\n' `mpeek 0x65c00078` 
    printf 'GEM_AMC.DAQ.OH0.LASTBLOCK6                    = 0x%x\n' `mpeek 0x65c0007c` 
    printf 'GEM_AMC.DAQ.OH1.COUNTERS.CORRUPT_VFAT_BLK_CNT = 0x%x\n' `mpeek 0x65c00084` 
    printf 'GEM_AMC.DAQ.OH1.COUNTERS.EVN                  = 0x%x\n' $(( (`mpeek 0x65c00088` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH1.CONTROL.EOE_TIMEOUT           = 0x%x\n' $(( (`mpeek 0x65c0008c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH1.COUNTERS.MAX_EOE_TIMER        = 0x%x\n' $(( (`mpeek 0x65c0009c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH1.COUNTERS.LAST_EOE_TIMER       = 0x%x\n' $(( (`mpeek 0x65c000a0` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH1.LASTBLOCK0                    = 0x%x\n' `mpeek 0x65c000a4` 
    printf 'GEM_AMC.DAQ.OH1.LASTBLOCK1                    = 0x%x\n' `mpeek 0x65c000a8` 
    printf 'GEM_AMC.DAQ.OH1.LASTBLOCK2                    = 0x%x\n' `mpeek 0x65c000ac` 
    printf 'GEM_AMC.DAQ.OH1.LASTBLOCK3                    = 0x%x\n' `mpeek 0x65c000b0` 
    printf 'GEM_AMC.DAQ.OH1.LASTBLOCK4                    = 0x%x\n' `mpeek 0x65c000b4` 
    printf 'GEM_AMC.DAQ.OH1.LASTBLOCK5                    = 0x%x\n' `mpeek 0x65c000b8` 
    printf 'GEM_AMC.DAQ.OH1.LASTBLOCK6                    = 0x%x\n' `mpeek 0x65c000bc` 
    printf 'GEM_AMC.DAQ.OH2.COUNTERS.CORRUPT_VFAT_BLK_CNT = 0x%x\n' `mpeek 0x65c000c4` 
    printf 'GEM_AMC.DAQ.OH2.COUNTERS.EVN                  = 0x%x\n' $(( (`mpeek 0x65c000c8` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH2.CONTROL.EOE_TIMEOUT           = 0x%x\n' $(( (`mpeek 0x65c000cc` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH2.COUNTERS.MAX_EOE_TIMER        = 0x%x\n' $(( (`mpeek 0x65c000dc` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH2.COUNTERS.LAST_EOE_TIMER       = 0x%x\n' $(( (`mpeek 0x65c000e0` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH2.LASTBLOCK0                    = 0x%x\n' `mpeek 0x65c000e4` 
    printf 'GEM_AMC.DAQ.OH2.LASTBLOCK1                    = 0x%x\n' `mpeek 0x65c000e8` 
    printf 'GEM_AMC.DAQ.OH2.LASTBLOCK2                    = 0x%x\n' `mpeek 0x65c000ec` 
    printf 'GEM_AMC.DAQ.OH2.LASTBLOCK3                    = 0x%x\n' `mpeek 0x65c000f0` 
    printf 'GEM_AMC.DAQ.OH2.LASTBLOCK4                    = 0x%x\n' `mpeek 0x65c000f4` 
    printf 'GEM_AMC.DAQ.OH2.LASTBLOCK5                    = 0x%x\n' `mpeek 0x65c000f8` 
    printf 'GEM_AMC.DAQ.OH2.LASTBLOCK6                    = 0x%x\n' `mpeek 0x65c000fc` 
    printf 'GEM_AMC.DAQ.OH3.COUNTERS.CORRUPT_VFAT_BLK_CNT = 0x%x\n' `mpeek 0x65c00104` 
    printf 'GEM_AMC.DAQ.OH3.COUNTERS.EVN                  = 0x%x\n' $(( (`mpeek 0x65c00108` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH3.CONTROL.EOE_TIMEOUT           = 0x%x\n' $(( (`mpeek 0x65c0010c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH3.COUNTERS.MAX_EOE_TIMER        = 0x%x\n' $(( (`mpeek 0x65c0011c` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH3.COUNTERS.LAST_EOE_TIMER       = 0x%x\n' $(( (`mpeek 0x65c00120` & 0x00ffffff) >> 0 ))
    printf 'GEM_AMC.DAQ.OH3.LASTBLOCK0                    = 0x%x\n' `mpeek 0x65c00124` 
    printf 'GEM_AMC.DAQ.OH3.LASTBLOCK1                    = 0x%x\n' `mpeek 0x65c00128` 
    printf 'GEM_AMC.DAQ.OH3.LASTBLOCK2                    = 0x%x\n' `mpeek 0x65c0012c` 
    printf 'GEM_AMC.DAQ.OH3.LASTBLOCK3                    = 0x%x\n' `mpeek 0x65c00130` 
    printf 'GEM_AMC.DAQ.OH3.LASTBLOCK4                    = 0x%x\n' `mpeek 0x65c00134` 
    printf 'GEM_AMC.DAQ.OH3.LASTBLOCK5                    = 0x%x\n' `mpeek 0x65c00138` 
    printf 'GEM_AMC.DAQ.OH3.LASTBLOCK6                    = 0x%x\n' `mpeek 0x65c0013c` 
fi

if [ "$MODULE" = "OH_LINKS" ]; then
    printf 'GEM_AMC.OH_LINKS.OH0.TRACK_LINK_ERROR_CNT     = 0x%x\n' `mpeek 0x65800400` 
    printf 'GEM_AMC.OH_LINKS.OH0.VFAT_BLOCK_CNT           = 0x%x\n' `mpeek 0x65800404` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRACK_LINK_TX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800408` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRACK_LINK_TX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x6580040c` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRACK_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800410` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRACK_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65800414` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRIG0_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800418` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRIG0_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x6580041c` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRIG1_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800420` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRIG1_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65800424` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRACK_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65800428` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRACK_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x6580042c` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRIG0_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65800430` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRIG0_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x65800434` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRIG1_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65800438` 
    printf 'GEM_AMC.OH_LINKS.OH0.TRIG1_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x6580043c` 
    printf 'GEM_AMC.OH_LINKS.OH0.DEBUG_CLK_CNT            = 0x%x\n' `mpeek 0x65800440` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRACK_LINK_ERROR_CNT     = 0x%x\n' `mpeek 0x65800800` 
    printf 'GEM_AMC.OH_LINKS.OH1.VFAT_BLOCK_CNT           = 0x%x\n' `mpeek 0x65800804` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRACK_LINK_TX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800808` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRACK_LINK_TX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x6580080c` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRACK_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800810` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRACK_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65800814` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRIG0_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800818` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRIG0_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x6580081c` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRIG1_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800820` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRIG1_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65800824` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRACK_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65800828` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRACK_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x6580082c` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRIG0_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65800830` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRIG0_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x65800834` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRIG1_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65800838` 
    printf 'GEM_AMC.OH_LINKS.OH1.TRIG1_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x6580083c` 
    printf 'GEM_AMC.OH_LINKS.OH1.DEBUG_CLK_CNT            = 0x%x\n' `mpeek 0x65800840` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRACK_LINK_ERROR_CNT     = 0x%x\n' `mpeek 0x65800c00` 
    printf 'GEM_AMC.OH_LINKS.OH2.VFAT_BLOCK_CNT           = 0x%x\n' `mpeek 0x65800c04` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRACK_LINK_TX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800c08` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRACK_LINK_TX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65800c0c` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRACK_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800c10` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRACK_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65800c14` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRIG0_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800c18` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRIG0_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65800c1c` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRIG1_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65800c20` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRIG1_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65800c24` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRACK_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65800c28` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRACK_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x65800c2c` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRIG0_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65800c30` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRIG0_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x65800c34` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRIG1_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65800c38` 
    printf 'GEM_AMC.OH_LINKS.OH2.TRIG1_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x65800c3c` 
    printf 'GEM_AMC.OH_LINKS.OH2.DEBUG_CLK_CNT            = 0x%x\n' `mpeek 0x65800c40` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRACK_LINK_ERROR_CNT     = 0x%x\n' `mpeek 0x65801000` 
    printf 'GEM_AMC.OH_LINKS.OH3.VFAT_BLOCK_CNT           = 0x%x\n' `mpeek 0x65801004` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRACK_LINK_TX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65801008` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRACK_LINK_TX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x6580100c` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRACK_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65801010` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRACK_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65801014` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRIG0_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65801018` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRIG0_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x6580101c` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRIG1_LINK_RX_SYNC_OVF_CNT = 0x%x\n' `mpeek 0x65801020` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRIG1_LINK_RX_SYNC_UNF_CNT = 0x%x\n' `mpeek 0x65801024` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRACK_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65801028` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRACK_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x6580102c` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRIG0_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65801030` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRIG0_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x65801034` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRIG1_LINK_NOT_IN_TABLE_CNT = 0x%x\n' `mpeek 0x65801038` 
    printf 'GEM_AMC.OH_LINKS.OH3.TRIG1_LINK_DISPERR_CNT   = 0x%x\n' `mpeek 0x6580103c` 
    printf 'GEM_AMC.OH_LINKS.OH3.DEBUG_CLK_CNT            = 0x%x\n' `mpeek 0x65801040` 
fi

if [ "$MODULE" = "OH" ]; then
    printf 'GEM_AMC.OH.OH0.FW_DATE                        = 0x%x\n' `mpeek 0x65030000` 
    printf 'GEM_AMC.OH.OH1.FW_DATE                        = 0x%x\n' `mpeek 0x65070000` 
    printf 'GEM_AMC.OH.OH2.FW_DATE                        = 0x%x\n' `mpeek 0x650b0000` 
    printf 'GEM_AMC.OH.OH3.FW_DATE                        = 0x%x\n' `mpeek 0x650f0000` 
    printf 'GEM_AMC.OH.OH0.CONTROL.VFAT.MASK              = 0x%x\n' `mpeek 0x91000000` 
    printf 'GEM_AMC.OH.OH0.CONTROL.TRIGGER.SOURCE         = 0x%x\n' $(( (`mpeek 0x91000004` & 0x00000007) >> 0 ))
    printf 'GEM_AMC.OH.OH0.CONTROL.TRIGGER.LOOPBACK       = 0x%x\n' $(( (`mpeek 0x91000008` & 0x0000001f) >> 0 ))
    printf 'GEM_AMC.OH.OH0.CONTROL.CLOCK.REF_CLK          = 0x%x\n' $(( (`mpeek 0x91000010` & 0x00000003) >> 0 ))
    printf 'GEM_AMC.OH.OH1.CONTROL.VFAT.MASK              = 0x%x\n' `mpeek 0x91040000` 
    printf 'GEM_AMC.OH.OH1.CONTROL.TRIGGER.SOURCE         = 0x%x\n' $(( (`mpeek 0x91040004` & 0x00000007) >> 0 ))
    printf 'GEM_AMC.OH.OH1.CONTROL.TRIGGER.LOOPBACK       = 0x%x\n' $(( (`mpeek 0x91040008` & 0x0000001f) >> 0 ))
    printf 'GEM_AMC.OH.OH1.CONTROL.CLOCK.REF_CLK          = 0x%x\n' $(( (`mpeek 0x91040010` & 0x00000003) >> 0 ))
    printf 'GEM_AMC.OH.OH2.CONTROL.VFAT.MASK              = 0x%x\n' `mpeek 0x91080000` 
    printf 'GEM_AMC.OH.OH2.CONTROL.TRIGGER.SOURCE         = 0x%x\n' $(( (`mpeek 0x91080004` & 0x00000007) >> 0 ))
    printf 'GEM_AMC.OH.OH2.CONTROL.TRIGGER.LOOPBACK       = 0x%x\n' $(( (`mpeek 0x91080008` & 0x0000001f) >> 0 ))
    printf 'GEM_AMC.OH.OH2.CONTROL.CLOCK.REF_CLK          = 0x%x\n' $(( (`mpeek 0x91080010` & 0x00000003) >> 0 ))
    printf 'GEM_AMC.OH.OH3.CONTROL.VFAT.MASK              = 0x%x\n' `mpeek 0x910c0000` 
    printf 'GEM_AMC.OH.OH3.CONTROL.TRIGGER.SOURCE         = 0x%x\n' $(( (`mpeek 0x910c0004` & 0x00000007) >> 0 ))
    printf 'GEM_AMC.OH.OH3.CONTROL.TRIGGER.LOOPBACK       = 0x%x\n' $(( (`mpeek 0x910c0008` & 0x0000001f) >> 0 ))
    printf 'GEM_AMC.OH.OH3.CONTROL.CLOCK.REF_CLK          = 0x%x\n' $(( (`mpeek 0x910c0010` & 0x00000003) >> 0 ))
    printf 'GEM_AMC.OH.OH0.STATUS.FPGA_PLL_LOCK           = 0x%x\n' $(( (`mpeek 0x95000004` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH0.STATUS.EXT_PLL_LOCK            = 0x%x\n' $(( (`mpeek 0x95000008` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH0.STATUS.CDCE_LOCK               = 0x%x\n' $(( (`mpeek 0x9500000c` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH0.STATUS.GTX_LOCK                = 0x%x\n' $(( (`mpeek 0x95000010` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH1.STATUS.FPGA_PLL_LOCK           = 0x%x\n' $(( (`mpeek 0x95040004` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH1.STATUS.EXT_PLL_LOCK            = 0x%x\n' $(( (`mpeek 0x95040008` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH1.STATUS.CDCE_LOCK               = 0x%x\n' $(( (`mpeek 0x9504000c` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH1.STATUS.GTX_LOCK                = 0x%x\n' $(( (`mpeek 0x95040010` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH2.STATUS.FPGA_PLL_LOCK           = 0x%x\n' $(( (`mpeek 0x95080004` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH2.STATUS.EXT_PLL_LOCK            = 0x%x\n' $(( (`mpeek 0x95080008` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH2.STATUS.CDCE_LOCK               = 0x%x\n' $(( (`mpeek 0x9508000c` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH2.STATUS.GTX_LOCK                = 0x%x\n' $(( (`mpeek 0x95080010` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH3.STATUS.FPGA_PLL_LOCK           = 0x%x\n' $(( (`mpeek 0x950c0004` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH3.STATUS.EXT_PLL_LOCK            = 0x%x\n' $(( (`mpeek 0x950c0008` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH3.STATUS.CDCE_LOCK               = 0x%x\n' $(( (`mpeek 0x950c000c` & 0x00000001) >> 0 ))
    printf 'GEM_AMC.OH.OH3.STATUS.GTX_LOCK                = 0x%x\n' $(( (`mpeek 0x950c0010` & 0x00000001) >> 0 ))
fi

