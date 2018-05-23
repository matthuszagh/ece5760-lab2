/* top_level_tb.v
 *
 * A testbench to ensure the proper interaction of all modules together.
 *
 * This leaves out the memory read which is a bit harder to test and
 * seems to be working fine.
 */

`timescale 100ns/1ns

module top_level_tb;

   // Clocks
   reg clk_tb = 0;

   // Parameters
   wire signed [9:0] k1_m1_tb = 10'd2;
   wire signed [9:0] k2_m2_tb = 10'd2;
   wire signed [9:0] km_m1_tb = 10'd2;
   wire signed [9:0] km_m2_tb = 10'd2;
   wire signed [9:0] k13_m1_tb = 10'd16;
   wire signed [9:0] k33_m2_tb = 10'd16;
   wire signed [9:0] x1_0_tb = 10'd150;
   wire signed [9:0] x2_0_tb = 10'd300;
   wire signed [9:0] d1_tb = 10'd1;
   wire signed [9:0] d2_tb = 10'd1;
   wire [3:0]        dt_tb = 4'd5;
   wire [3:0]        d_scale_fact_tb = 4'd1;

   // Positions
   wire signed [9:0] x1_tb;
   wire signed [9:0] x2_tb;

   // Screen display
   wire [7:0] vga_g_tb;
   wire [7:0] vga_b_tb;
   wire [7:0] vga_r_tb;
   wire       vga_blank_n_tb;
   wire       vga_clk_tb;
   wire       vga_hs_tb;
   wire       vga_vs_tb;

   // Testbench instantiations
   vga_driver vga_tb (
                      // Inputs.
                      .vga_clk_int(clk_tb),
                      .vga_clk_ext(clk_tb),
                      .slow_clk(clk_tb),
                      .x1(x1_tb),
                      .x2(x2_tb),
                      // Outputs.
                      .vga_g(vga_g_tb),
                      .vga_b(vga_b_tb),
                      .vga_r(vga_r_tb),
                      .vga_blank_n(vga_blank_n_tb),
                      .vga_clk(vga_clk_tb),
                      .vga_hs(vga_hs_tb),
                      .vga_vs(vga_vs_tb)
                      );

   diff_q diff_tb (
                   // Inputs.
                   .slow_clk(clk_tb),
                   .k1_m1(k1_m1_tb),
                   .k2_m2(k2_m2_tb),
                   .km_m1(km_m1_tb),
                   .km_m2(km_m2_tb),
                   .k13_m1(k13_m1_tb),
                   .k33_m2(k33_m2_tb),
                   .x1_0(x1_0_tb),
                   .x2_0(x2_0_tb),
                   .d1(d1_tb),
                   .d2(d2_tb),
                   .dt(dt_tb),
                   .d_scale_fact(d_scale_fact_tb),
                   // Outputs.
                   .x1(x1_tb),
                   .x2(x2_tb)
                   );

   // Generate testbench clock signal.
   always begin
      #1 clk_tb = ~clk_tb;
   end

endmodule // top_level_tb
