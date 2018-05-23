/* read_mem.v
 *
 * Reads memory from the HPS in real-time and uses it to update the differential equation numerical solver.
 */

module read_mem (
                 // Clock pins.
		 input               clock_50,

                 // Data in.
                 input [15:0]        read_data,

                 // Read parameters for output.
                 output signed [9:0] k1_m1,
                 output signed [9:0] k2_m2,
                 output signed [9:0] km_m1,
                 output signed [9:0] km_m2,
                 output signed [9:0] k13_m1,
                 output signed [9:0] k33_m2,
                 output signed [9:0] x1_0,
                 output signed [9:0] x2_0,
                 output signed [9:0] d1,
                 output signed [9:0] d2,
                 output [3:0]        dt,
                 output [3:0]        d_scale_fact,
                 output [3:0]        read_address
		 );

   // Data.
   reg signed [9:0] k1_m1_int;                     // k1/m1 = spring constant of spring 1 divided by mass 1.
   reg signed [9:0] k2_m2_int;
   reg signed [9:0] km_m1_int;                     // km/m1 ; km = spring constant of middle spring.
   reg signed [9:0] km_m2_int;
   reg signed [9:0] k13_m1_int;                    // cubic spring term.
   reg signed [9:0] k33_m2_int;
   reg signed [9:0] x1_0_int;                      // origin of x1 mass (i.e. where spring 1 does not exert a force.
   reg signed [9:0] x2_0_int;
   reg signed [9:0] d1_int;                        // damping coefficient of the 1st mass (proportional to its velocity)
   reg signed [9:0] d2_int;
   reg [3:0] 	    dt_int;                         // time step. will perform arithmetic right shift, so equal to multiply by 2^(-dt)
   reg [3:0] 	    d_scale_fact_int;               // scale the damping coefficient.

   reg [3:0]        mem_read_count = 3'd0;          // select signal to sequentially parameters specified by the HPS.

   // Read parameters from HPS.
   always @ (posedge clock_50) begin
      mem_read_count <= mem_read_count + 1;
      case (mem_read_count)
	4'd01 : k1_m1_int <= read_data[9:0];
	4'd02 : k2_m2_int <= read_data[9:0];
	4'd03 : km_m1_int <= read_data[9:0];
	4'd04 : km_m2_int <= read_data[9:0];
	4'd05 : k13_m1_int <= read_data[9:0];

	4'd10 : k33_m2_int <= read_data[9:0];
	4'd11 : x1_0_int <= read_data[9:0];
	4'd12 : x2_0_int <= read_data[9:0];
	4'd13 : d1_int <= read_data[9:0];
	4'd14 : d2_int <= read_data[9:0];
	4'd15 : dt_int <= read_data[3:0];
	4'd00 : d_scale_fact_int <= read_data[3:0];
      endcase // case (mem_read_count)
   end // always @ (posedge CLOCK_50)

   assign k1_m1 = k1_m1_int;
   assign k2_m2 = k2_m2_int;
   assign km_m1 = km_m1_int;
   assign km_m2 = km_m2_int;
   assign k13_m1 = k13_m1_int;
   assign k33_m2 = k33_m2_int;
   assign x1_0 = x1_0_int;
   assign x2_0 = x2_0_int;
   assign d1 = d1_int;
   assign d2 = d2_int;
   assign dt = dt_int;
   assign d_scale_fact = d_scale_fact_int;
   assign read_address = mem_read_count;

endmodule
