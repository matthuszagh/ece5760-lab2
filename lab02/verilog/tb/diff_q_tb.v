/* diff_q_tb.v
 *
 * A testbench for diff_q.v.
 */

`timescale 100ns / 1ns

module diff_q_tb;

   reg slow_clk_tb = 0;
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

   wire signed [9:0] x1_tb;
   wire signed [9:0] x2_tb;

   diff_q tb (
              // Inputs
              .slow_clk(slow_clk_tb),
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
              // Outputs
              .x1(x1_tb),
              .x2(x2_tb)
              );

   always begin
      #1 slow_clk_tb = ~slow_clk_tb;
   end

endmodule // diff_q_tb
