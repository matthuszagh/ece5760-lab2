// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// VENDOR "Altera"
// PROGRAM "Quartus Prime"
// VERSION "Version 15.1.0 Build 185 10/21/2015 SJ Lite Edition"

// DATE "05/16/2018 09:46:21"

// 
// Device: Altera 5CSEMA5F31C6 Package FBGA896
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module system (
	clk_clk,
	reset_reset_n,
	vga_clk_ext_clk,
	vga_clk_int_clk)/* synthesis synthesis_greybox=0 */;
input 	clk_clk;
input 	reset_reset_n;
output 	vga_clk_ext_clk;
output 	vga_clk_int_clk;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \pll_0|altera_pll_i|outclk_wire[1] ;
wire \pll_0|altera_pll_i|outclk_wire[0] ;
wire \clk_clk~input_o ;
wire \reset_reset_n~input_o ;


system_system_pll_0 pll_0(
	.outclk_wire_1(\pll_0|altera_pll_i|outclk_wire[1] ),
	.outclk_wire_0(\pll_0|altera_pll_i|outclk_wire[0] ),
	.clk_clk(\clk_clk~input_o ),
	.reset_reset_n(\reset_reset_n~input_o ));

assign \clk_clk~input_o  = clk_clk;

assign \reset_reset_n~input_o  = reset_reset_n;

assign vga_clk_ext_clk = \pll_0|altera_pll_i|outclk_wire[1] ;

assign vga_clk_int_clk = \pll_0|altera_pll_i|outclk_wire[0] ;

endmodule

module system_system_pll_0 (
	outclk_wire_1,
	outclk_wire_0,
	clk_clk,
	reset_reset_n)/* synthesis synthesis_greybox=0 */;
output 	outclk_wire_1;
output 	outclk_wire_0;
input 	clk_clk;
input 	reset_reset_n;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



system_altera_pll_1 altera_pll_i(
	.outclk({outclk_wire_1,outclk_wire_0}),
	.refclk(clk_clk),
	.rst(reset_reset_n));

endmodule

module system_altera_pll_1 (
	outclk,
	refclk,
	rst)/* synthesis synthesis_greybox=0 */;
output 	[1:0] outclk;
input 	refclk;
input 	rst;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \fboutclk_wire[0] ;


generic_pll \general[1].gpll (
	.refclk(refclk),
	.fbclk(\fboutclk_wire[0] ),
	.rst(!rst),
	.writerefclkdata({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.writeoutclkdata({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.writephaseshiftdata({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.writedutycycledata(64'b0000000000000000000000000000000000000000000000000000000000000000),
	.outclk(outclk[1]),
	.fboutclk(),
	.locked(),
	.readrefclkdata(),
	.readoutclkdata(),
	.readphaseshiftdata(),
	.readdutycycledata());
defparam \general[1].gpll .clock_name_global = "false";
defparam \general[1].gpll .duty_cycle = 50;
defparam \general[1].gpll .fractional_vco_multiplier = "false";
defparam \general[1].gpll .output_clock_frequency = "108.0 mhz";
defparam \general[1].gpll .phase_shift = "5787 ps";
defparam \general[1].gpll .reference_clock_frequency = "50.0 mhz";
defparam \general[1].gpll .simulation_type = "timing";

generic_pll \general[0].gpll (
	.refclk(refclk),
	.fbclk(\fboutclk_wire[0] ),
	.rst(!rst),
	.writerefclkdata({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.writeoutclkdata({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.writephaseshiftdata({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.writedutycycledata(64'b0000000000000000000000000000000000000000000000000000000000000000),
	.outclk(outclk[0]),
	.fboutclk(\fboutclk_wire[0] ),
	.locked(),
	.readrefclkdata(),
	.readoutclkdata(),
	.readphaseshiftdata(),
	.readdutycycledata());
defparam \general[0].gpll .clock_name_global = "false";
defparam \general[0].gpll .duty_cycle = 50;
defparam \general[0].gpll .fractional_vco_multiplier = "false";
defparam \general[0].gpll .output_clock_frequency = "108.0 mhz";
defparam \general[0].gpll .phase_shift = "0 ps";
defparam \general[0].gpll .reference_clock_frequency = "50.0 mhz";
defparam \general[0].gpll .simulation_type = "timing";

endmodule
