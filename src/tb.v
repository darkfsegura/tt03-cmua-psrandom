`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input BB_SYSTEM_CLOCK_50,
    input BB_SYSTEM_RESET_InHigh,
    input BB_SYSTEM_loadseed_InLow,
    input BB_SYSTEM_loadrand_InLow,
    input [3:0] BB_SYSTEM_data_InBUS,
    output [7:0] BB_SYSTEM_data_OutBUS
   );

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    wire [7:0] inputs = {BB_SYSTEM_data_InBUS[3],BB_SYSTEM_data_InBUS[2],BB_SYSTEM_data_InBUS[1],BB_SYSTEM_data_InBUS[0], BB_SYSTEM_loadrand_InLow,BB_SYSTEM_loadseed_InLow,BB_SYSTEM_RESET_InHigh, BB_SYSTEM_CLOCK_50};
    wire [7:0] outputs;
    assign BB_SYSTEM_data_OutBUS = outputs[7:0];

    // instantiate the DUT
    BB_SYSTEM BB_SYSTEM(
        `ifdef GL_TEST
            .vccd1( 1'b1),
            .vssd1( 1'b0),
        `endif
        .io_in  (inputs),
        .io_out (outputs)
        );

endmodule
