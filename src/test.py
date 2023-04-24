import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_BB_SYSTEM(dut):
    dut._log.info("START")
    clock = Clock(dut.BB_SYSTEM_CLOCK_50, 10, units="us")
    cocotb.start_soon(clock.start())

    dut._log.info("RESET")
    dut.BB_SYSTEM_RESET_InHigh.value = 0
    dut.BB_SYSTEM_loadseed_InLow.value = 1
    dut.BB_SYSTEM_loadrand_InLow.value = 1
    dut.BB_SYSTEM_data_InBUS.value = 0
    await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
    dut.BB_SYSTEM_RESET_InHigh.value = 1
    await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
    dut.BB_SYSTEM_RESET_InHigh.value = 0
	
    dut._log.info("LOAD SEED 0001")
    dut.BB_SYSTEM_loadseed_InLow.value = 1
    await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
    dut.BB_SYSTEM_loadseed_InLow.value = 0
    dut.BB_SYSTEM_data_InBUS.value = 1
    await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
    dut.BB_SYSTEM_loadseed_InLow.value = 1

    dut._log.info("LOAD RAND")
    for i in range(5):
        dut._log.info("Check PSRANDOM")
        dut.BB_SYSTEM_loadrand_InLow.value = 1
        await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
        dut.BB_SYSTEM_loadrand_InLow.value = 0
        await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
        dut.BB_SYSTEM_loadrand_InLow.value = 1
        await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)

    dut._log.info("LOAD SEED 0010")
    dut.BB_SYSTEM_loadseed_InLow.value = 1
    await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
    dut.BB_SYSTEM_loadseed_InLow.value = 0
    dut.BB_SYSTEM_data_InBUS.value = 2
    await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
    dut.BB_SYSTEM_loadseed_InLow.value = 1

    dut._log.info("LOAD RAND")
    for i in range(5):
        dut._log.info("Check PSRANDOM")
        dut.BB_SYSTEM_loadrand_InLow.value = 1
        await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
        dut.BB_SYSTEM_loadrand_InLow.value = 0
        await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
        dut.BB_SYSTEM_loadrand_InLow.value = 1
        await ClockCycles(dut.BB_SYSTEM_CLOCK_50, 10000)
