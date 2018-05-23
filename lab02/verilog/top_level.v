/* top_level.v
 *
 * A top level module for ECE5760 lab2.
 */

module top_level (
		  // Clock pins.
		  input         CLOCK_50,

		  // VGA pins.
		  output [7:0]  VGA_G,
		  output [7:0]  VGA_B,
		  output [7:0]  VGA_R,
		  output        VGA_BLANK_N,
		  output        VGA_CLK,
		  output        VGA_HS,
		  output        VGA_VS,

		  // Push buttons.
		  input [3:0]   KEY,

                  // HEX
                  output [6:0]  HEX0,
                  output [6:0]  HEX1,
                  output [6:0]  HEX2,
                  output [6:0]  HEX3,
                  output [6:0]  HEX4,
                  output [6:0]  HEX5,

                  // Memory
                  output [14:0] hps_memory_mem_a,
		  output [2:0]  hps_memory_mem_ba,
		  output        hps_memory_mem_ck,
		  output        hps_memory_mem_ck_n,
		  output        hps_memory_mem_cke,
		  output        hps_memory_mem_cs_n,
		  output        hps_memory_mem_ras_n,
		  output        hps_memory_mem_cas_n,
		  output        hps_memory_mem_we_n,
		  output        hps_memory_mem_reset_n,
		  inout [31:0]  hps_memory_mem_dq,
		  inout [3:0]   hps_memory_mem_dqs,
		  inout [3:0]   hps_memory_mem_dqs_n,
		  output        hps_memory_mem_odt,
		  output [3:0]  hps_memory_mem_dm,
		  input         hps_memory_oct_rzqin
		  );

   // VGA parameters.
   wire [7:0] vga_g;
   wire [7:0] vga_b;
   wire [7:0] vga_r;
   wire       vga_blank_n;
   wire       vga_clk;
   wire       vga_hs;
   wire       vga_vs;

   // Internal signals.
   wire       reset = ~KEY[0];
   wire       vga_clk_int;
   wire       vga_clk_ext;

   reg [18:0] count = 0;             // Adjust this based on desired frame rate.
   reg        slow_clk = 0;

   // Create a slow clock to drive most of the equation solver logic and drive new values to the frame.
   always @ (posedge vga_clk_int) begin
      count <= count + 1;
      if (count == 0) begin
	 slow_clk = ~slow_clk;
      end
   end // always @ (posedge vga_clk_int)

   // Data.
   wire signed [9:0] k1_m1;
   wire signed [9:0] k2_m2;
   wire signed [9:0] km_m1;
   wire signed [9:0] km_m2;
   wire signed [9:0] k13_m1;
   wire signed [9:0] k33_m2;
   wire signed [9:0] x1_0;
   wire signed [9:0] x2_0;
   wire signed [9:0] d1;
   wire signed [9:0] d2;
   wire [3:0]        dt;
   wire [3:0]        d_scale_fact;

   wire signed [9:0] x1;
   wire signed [9:0] x2;

   wire [3:0]        read_address;
   wire [15:0]       read_data;

   // VGA driver instantiation.
   vga_driver vga (
                   // Inputs.
                   .vga_clk_int(vga_clk_int),
                   .vga_clk_ext(vga_clk_ext),
                   .slow_clk(slow_clk),
                   .x1(x1),
                   .x2(x2),
                   // Outputs.
                   .vga_g(vga_g),
                   .vga_b(vga_b),
                   .vga_r(vga_r),
                   .vga_blank_n(vga_blank_n),
                   .vga_clk(vga_clk),
                   .vga_hs(vga_hs),
                   .vga_vs(vga_vs)
                   );

   // HPS memory read module instantiation.
   read_mem mem (
                 // Inputs
                 .clock_50(CLOCK_50),
                 .read_data(read_data),
                 // Outputs.
                 .k1_m1(k1_m1),
                 .k2_m2(k2_m2),
                 .km_m1(km_m1),
                 .km_m2(km_m2),
                 .k13_m1(k13_m1),
                 .k33_m2(k33_m2),
                 .x1_0(x1_0),
                 .x2_0(x2_0),
                 .d1(d1),
                 .d2(d2),
                 .dt(dt),
                 .d_scale_fact(d_scale_fact),
                 .read_address(read_address)
                 );

   // Differential equation solver module instantiation.
   diff_q diff_inst (
                     // Inputs.
                     .slow_clk(slow_clk),
                     .k1_m1(k1_m1),
                     .k2_m2(k2_m2),
                     .km_m1(km_m1),
                     .km_m2(km_m2),
                     .k13_m1(k13_m1),
                     .k33_m2(k33_m2),
                     .x1_0(x1_0),
                     .x2_0(x2_0),
                     .d1(d1),
                     .d2(d2),
                     .dt(dt),
                     .d_scale_fact(d_scale_fact),
                     // Outputs.
                     .x1(x1),
                     .x2(x2)
                     );

   // IP core instantiation.
   system pll (
	       .clk_clk(CLOCK_50),
	       .reset_reset_n(~reset),
	       // PLL
	       .vga_clk_int_clk(vga_clk_int),
	       .vga_clk_ext_clk(vga_clk_ext),
	       // RAM
	       .ram_conduit_address(read_address),
	       .ram_conduit_readdata(read_data),
               .ram_conduit_clken(1'b1),
               .ram_conduit_write(1'b0),
               .ram_conduit_byteenable(2'b11),
               // Memory
               .memory_mem_a(hps_memory_mem_a),             //      memory.mem_a
	       .memory_mem_ba(hps_memory_mem_ba),           //            .mem_ba
	       .memory_mem_ck(hps_memory_mem_ck),           //            .mem_ck
	       .memory_mem_ck_n(hps_memory_mem_ck_n),       //            .mem_ck_n
	       .memory_mem_cke(hps_memory_mem_cke),         //            .mem_cke
	       .memory_mem_cs_n(hps_memory_mem_cs_n),       //            .mem_cs_n
	       .memory_mem_ras_n(hps_memory_mem_ras_n),     //            .mem_ras_n
	       .memory_mem_cas_n(hps_memory_mem_cas_n),     //            .mem_cas_n
	       .memory_mem_we_n(hps_memory_mem_we_n),       //            .mem_we_n
	       .memory_mem_reset_n(hps_memory_mem_reset_n), //            .mem_reset_n
	       .memory_mem_dq(hps_memory_mem_dq),           //            .mem_dq
	       .memory_mem_dqs(hps_memory_mem_dqs),         //            .mem_dqs
	       .memory_mem_dqs_n(hps_memory_mem_dqs_n),     //            .mem_dqs_n
	       .memory_mem_odt(hps_memory_mem_odt),         //            .mem_odt
	       .memory_mem_dm(hps_memory_mem_dm),           //            .mem_dm
	       .memory_oct_rzqin(hps_memory_oct_rzqin)      //            .oct_rzqin
	       );

   HexDigit set_hex0(HEX0, k13_m1[3:0]);
   HexDigit set_hex1(HEX1, k13_m1[7:4]);
   HexDigit set_hex2(HEX2, k13_m1[9:8]);
   HexDigit set_hex3(HEX3, x2_0[3:0]);
   HexDigit set_hex4(HEX4, x2_0[7:4]);
   HexDigit set_hex5(HEX5, x2_0[9:8]);

   assign VGA_CLK = vga_clk;

   assign VGA_R = vga_r;
   assign VGA_B = vga_b;
   assign VGA_G = vga_g;

   assign VGA_BLANK_N = vga_blank_n;
   assign VGA_HS = vga_hs;
   assign VGA_VS = vga_vs;

endmodule
