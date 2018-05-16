/* top_level.v
 *
 * A top level module for ECE5760 lab2.
 */

module top_level (
		  // Clock pins.
		  input        CLOCK_50,
		  // input        CLOCK2_50,

		  // VGA pins.
		  output [7:0] VGA_G,
		  output [7:0] VGA_B,
		  output [7:0] VGA_R,
		  output       VGA_BLANK_N,
		  output       VGA_CLK,
		  output       VGA_HS,
		  output       VGA_VS,

		  // // HEX pins.
		  // output [6:0] HEX0,
		  // output [6:0] HEX1,
		  // output [6:0] HEX2,
		  // output [6:0] HEX3,
		  // output [6:0] HEX4,
		  // output [6:0] HEX5,

		  // Push buttons.
		  input [3:0]  KEY
		  );
   
   // VGA parameters.
   localparam horiz_len    = 1688;
   localparam hdisplay     = 1280;
   localparam hfront_porch = hdisplay + 161;
   localparam hsync        = hfront_porch + 112;
   localparam hback_porch  = hsync + 135;
   
   localparam vert_len     = 1066;
   localparam vdisplay     = 1024;
   localparam vfront_porch = vdisplay + 1;
   localparam vsync        = vfront_porch + 3;
   localparam vback_porch  = vsync + 38;

   // Color params
   localparam white        = 8'b1111_1111;
   localparam black        = 8'b0000_0000;
   
   // Internal signals.
   wire 		       reset = ~KEY[0];
   wire 		       vga_clk_int;
   wire 		       vga_clk_ext;
   reg [10:0]		       h_pos = 0;
   reg [10:0] 		       v_pos = 0;
   reg [ 7:0] 		       r_color = black;
   reg [ 7:0] 		       g_color = black;
   reg [ 7:0] 		       b_color = black;
//   reg        		       draw = 0;
   wire [10:0] 		       write_address = h_pos;
   wire [10:0] 		       read_address = h_pos;
   reg 			       write = 0;
   reg [7:0] 		       write_data;
   wire [7:0] 		       read_data;

   always @ (posedge vga_clk_int) begin
      // Keep the horizontal position within its limits.
      if (h_pos < horiz_len) begin
	 h_pos <= h_pos + 1;
	 // Output data to screen.
	 if (v_pos == {3'b0, read_data}) begin
	    r_color <= white;
	    b_color <= white;
	    g_color <= white;
	 end
	 else begin
	    r_color <= black;
	    b_color <= black;
	    g_color <= black;
	 end
	 // Write data to memory that we want to output to screen.
	 if (h_pos == v_pos) begin
	    write <= 1;
	    write_data <= v_pos[7:0];
	 end
	 else begin
	    write <= 0;
	 end
      end
      else begin
	 h_pos <= 0;
	 v_pos <= v_pos + 1;
      end
      // Keep the vertical position within its limits.
      if (v_pos == vert_len) begin
	 v_pos <= 0;
      end
   end

   // IP core instantiation.
   system pll (
	       // PLL
	       .clk_clk(CLOCK_50),
	       .reset_reset_n(~reset),
	       .vga_clk_int_clk(vga_clk_int),
	       .vga_clk_ext_clk(vga_clk_ext)
	       );

   ram ram_inst (
		 .aclr(reset),
		 .clock(vga_clk_int),
		 .data(write_data),
		 .rdaddress(read_address),
		 .wraddress(write_address),
		 .wren(write),
		 .q(read_data)
		 );

   // HexDigit hex0(HEX0, vga_clk);
   // HexDigit hex1(HEX1, CLOCK_50);

   assign VGA_CLK = vga_clk_ext;
      
   assign VGA_R = (h_pos < hdisplay) ? r_color : 0;
   assign VGA_B = (h_pos < hdisplay) ? b_color : 0;
   assign VGA_G = (h_pos < hdisplay) ? g_color : 0;

   assign VGA_BLANK_N = ~((h_pos >= hdisplay & h_pos < hback_porch) | (v_pos >= vdisplay & v_pos < vback_porch));
   assign VGA_HS = ~(h_pos >= hfront_porch & h_pos < hsync);
   assign VGA_VS = ~(v_pos >= vfront_porch & v_pos < vsync);

endmodule
