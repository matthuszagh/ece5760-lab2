/* comp_tb.v
 *
 * A testbench for comp.v.
 */

`timescale 1ns/1ps
module comp_tb;

   reg fast_clk_tb=0;
   reg sample_clk_tb=0;
   wire [23:0] data_tb;

   always begin
      #20 fast_clk_tb <= !fast_clk_tb;
   end

   always begin
      #20000 sample_clk_tb <= !sample_clk_tb;
   end

   comp dut(
            .clk_fast(fast_clk_tb),
            .clk_sample(sample_clk_tb),
            .data(data_tb)
            );
endmodule // comp_tb
