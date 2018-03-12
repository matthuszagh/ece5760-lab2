/* integrator_tb.v
 * 
 * A testbench for integrator.v
 */

`timescale 1ps / 1ps


module integrator_tb();

wire	signed	[17:0]	xnew_		;
reg			reset_		;
reg			clk_		;
reg		[ 3:0]	dt_		;
reg	signed	[17:0]	x_		;
reg	signed	[17:0]	func_		;

initial begin
	reset_	= 0		;
	clk_	= 0		;
	dt_	= 8		;
	x_	= -32768	;
	func_	= 0 /*18'h0_8000*/	;
end

always clk_ = #100 ~clk_;

integrator int(.xnew(xnew_),
	       .reset(reset_),
       	       .clock(clk_),
               .dt(dt_),
               .x(x_),
               .func(func_));

always @ (posedge clk_) begin
	$display(xnew_)	;
end


endmodule
