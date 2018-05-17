/* top_level_tb.v
 *
 * A testbench for top_level.v
 */

`timescale 10ns / 1ns

module top_level_tb ();

   reg clk_tb = 0;

   integer i;

   reg [7:0] val;
   reg [7:0] screen_buf[0:1279];
   
   wire signed [8:0] k1_m1 = 9'b0_0000_0001;    //1;1;   // k1/m1 = spring constant of spring 1 divided by mass 1.
   wire signed [8:0] k2_m2 = 9'b0_0000_0001;    //1;1;
   wire signed [8:0] km_m1 = 9'b0_0000_0001;    //1;1;   // km/m1 ; km = spring constant of middle spring.
   wire signed [8:0] km_m2 = 9'b0_0000_0001;    //1;1;
   localparam x1_i = 50; //8'b0011_0010;  //50;   // initial x1 position.
   localparam x2_i = 200; //8'b1010_1010;   // 170;
   localparam v1_i = 0; //8'b0000_0000;    // initial velocity of x1.
   localparam v2_i = 0; //8'b0000_0000;
   wire signed [8:0] x1_0 = 9'b0_0101_0101; //85;   // origin of x1 mass (i.e. where spring 1 does not exert a force.
   wire signed [8:0] x2_0 = 9'b0_1010_1010;   //170;
   wire signed [8:0] d1 = 9'b0_0000_0000;    //1;      // damping coefficient of the 1st mass (proportional to its velocity)
   wire signed [8:0] d2 = 9'b0_0000_0000;    //1;
   wire [3:0] dt = 4'd4;      // time step. will perform arithmetic right shift, so equal to multiply by 2^(-dt)
   
   // Position and velocity.
   reg signed [8:0] x1 = x1_i;
   reg signed [8:0] v1 = v1_i;
   reg signed [8:0] x2 = x2_i;
   reg signed [8:0] v2 = v2_i;

   // Update the frame.
   always @ (posedge clk_tb) begin
      if ((x1 + (v1>>>dt)) > 255) x1 <= 255;
      else if ((x1 + (v1>>>dt)) < 0) x1 <= 0;
      else x1 <= x1 + (v1>>>dt);

      if ((x2 + (v2>>>dt)) > 255) x2 <= 255;
      else if ((x2 + (v2>>>dt)) < 0) x2 <= 0;
      else x2 <= x2 + (v2>>>dt);

      v1 <= v1 - ((k1_m1*(x1-x1_0))>>>dt) + ((km_m1*(x2-x2_0 - x1+x1_0))>>>dt) - ((d1*v1)>>>dt);
      v2 <= v2 - ((k2_m2*(x2-x2_0))>>>dt) + ((km_m2*(x1-x1_0 - x2+x2_0))>>>dt) - ((d2*v2)>>>dt);

      // New value put in.
      val <= x1[7:0];
      screen_buf[1279] <= val;
      for (i=1279; i>0; i=i-1) begin
	 screen_buf[i-1] <= screen_buf[i];
      end
   end

   always begin
      #1 clk_tb = !clk_tb;
   end
   
endmodule
