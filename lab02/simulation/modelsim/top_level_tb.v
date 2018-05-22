/* top_level_tb.v
 *
 * A testbench for top_level.v
 */

`timescale 10ns / 1ns

module top_level_tb ();

   reg clk_tb = 0;

   integer i;

   reg [8:0] val;
   reg [8:0] screen_buf[0:1279];
   
   wire signed [9:0] k1_m1 = 10'd2;  //10'b00_0000_0010;    // k1/m1 = spring constant of spring 1 divided by mass 1.
   wire signed [9:0] k2_m2 = 10'd2;  //10'b00_0000_0010;
   wire signed [9:0] km_m1 = 10'd2;  //10'b00_0000_0010;    // km/m1 ; km = spring constant of middle spring.
   wire signed [9:0] km_m2 = 10'd2;  //10'b00_0000_0010;
   wire signed [9:0] k13_m1 = 10'd16; //10'b00_0000_0010;   // cubic spring term.
   wire signed [9:0] k23_m2 = 10'd16; //10'b00_0000_0010;
   localparam x1_i = 130;                         // initial x1 position.
   localparam x2_i = 310;
   localparam v1_i = 0;                           // initial velocity of x1.
   localparam v2_i = 0;
   wire signed [9:0] x1_0 = 10'd150;  //10'b00_1001_0110;     // 150 - origin of x1 mass (i.e. where spring 1 does not exert a force.
   wire signed [9:0] x2_0 = 10'd300;  //10'b01_0010_1100;     // 300
   wire signed [9:0] d1 = 10'd1;      //10'b00_0000_0000;       // damping coefficient of the 1st mass (proportional to its velocity)
   wire signed [9:0] d2 = 10'd1;      //10'b00_0000_0000;
   wire [3:0] dt = 4'd5;                          // time step. will perform arithmetic right shift, so equal to multiply by 2^(-dt)
   wire [3:0] d_scale_fact = 4'd2;
  
   // Position and velocity.
   reg signed [9:0] x1 = x1_i;
   reg signed [9:0] v1 = v1_i;
   reg signed [9:0] x2 = x2_i;
   reg signed [9:0] v2 = v2_i;

   // Update the frame.
   always @ (posedge clk_tb) begin
      if ((x1 + (v1>>>dt)) > 511) x1 <= 511;
      else if ((x1 + (v1>>>dt)) < 0) x1 <= 0;
      else x1 <= x1 + (v1>>>dt);

      if ((x2 + (v2>>>dt)) > 511) x2 <= 511;
      else if ((x2 + (v2>>>dt)) < 0) x2 <= 0;
      else x2 <= x2 + (v2>>>dt);

      v1 <= v1 - ((k1_m1*(x1-x1_0))>>>dt) + ((km_m1*(x2-x2_0 - x1+x1_0))>>>dt) - (((d1*v1)>>>dt)>>>d_scale_fact) - ((k13_m1*((x1-x1_0)**3))>>>dt);
      v2 <= v2 - ((k2_m2*(x2-x2_0))>>>dt) + ((km_m2*(x1-x1_0 - x2+x2_0))>>>dt) - (((d2*v2)>>>dt)>>>d_scale_fact) - ((k23_m2*((x2-x2_0)**3))>>>dt);

      // New value put in.
      val <= {x2[8:0], x1[8:0]};
      screen_buf[1279] <= val;
      for (i=1279; i>0; i=i-1) begin
	 screen_buf[i-1] <= screen_buf[i];
      end
   end

   always begin
      #1 clk_tb = !clk_tb;
   end
   
endmodule
