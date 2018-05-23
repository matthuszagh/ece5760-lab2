/* diff_q.v
 *
 * The differential equation numerical solver.
 */

module diff_q (
	       // Clock pins.
	       input               slow_clk,

               // Parameter input.
               input signed [9:0]  k1_m1,
               input signed [9:0]  k2_m2,
               input signed [9:0]  km_m1,
               input signed [9:0]  km_m2,
               input signed [9:0]  k13_m1,
               input signed [9:0]  k33_m2,
               input signed [9:0]  x1_0,
               input signed [9:0]  x2_0,
               input signed [9:0]  d1,
               input signed [9:0]  d2,
               input [3:0]         dt,
               input [3:0]         d_scale_fact,

               // Results of computation.
               output signed [9:0] x1,
               output signed [9:0] x2
	       );

   // Data.
   localparam x1_i = 130;
   localparam x2_i = 310;
   localparam v1_i = 0;
   localparam v2_i = 0;

   // Position and velocity.
   reg signed [9:0] x1_int = x1_i;
   reg signed [9:0] v1 = v1_i;
   reg signed [9:0] x2_int = x2_i;
   reg signed [9:0] v2 = v2_i;

   // Update the frame.
   always @ (posedge slow_clk) begin
      if ((x1_int + (v1>>>dt)) > 511) x1_int <= 511;
      else if ((x1_int + (v1>>>dt)) < 0) x1_int <= 0;
      else x1_int <= x1_int + (v1>>>dt);

      if ((x2_int + (v2>>>dt)) > 511) x2_int <= 511;
      else if ((x2_int + (v2>>>dt)) < 0) x2_int <= 0;
      else x2_int <= x2_int + (v2>>>dt);

      v1 <= v1 - ((k1_m1*(x1_int-x1_0))>>>dt) + ((km_m1*(x2_int-x2_0 - x1_int+x1_0))>>>dt) - (((d1*v1)>>>dt)>>>d_scale_fact) - ((k13_m1*((x1_int-x1_0)**3))>>>dt);
      v2 <= v2 - ((k2_m2*(x2_int-x2_0))>>>dt) + ((km_m2*(x1_int-x1_0 - x2_int+x2_0))>>>dt) - (((d2*v2)>>>dt)>>>d_scale_fact) - ((k33_m2*((x2_int-x2_0)**3))>>>dt);
   end // always @ (posedge slow_clk)

   assign x1 = x1_int;
   assign x2 = x2_int;

endmodule
