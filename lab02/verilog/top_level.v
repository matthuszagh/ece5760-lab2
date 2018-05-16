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
		  output       VGA_SYNC_N,

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
   
   // Parameters.
   localparam horiz_len    = 1688;
   localparam hdisplay     = 1280;
   localparam hfront_porch = hdisplay + 161;       // 48
   localparam hsync        = hfront_porch + 112;
   localparam hback_porch  = hsync + 135;          // 248
   
   localparam vert_len     = 1066;
   localparam vdisplay     = 1024;
   localparam vfront_porch = vdisplay + 1;
   localparam vsync        = vfront_porch + 3;
   localparam vback_porch  = vsync + 38;
   
   // Internal signals.
   wire 		       reset = ~KEY[0];
   wire 		       vga_clk_int;
   wire 		       vga_clk_ext;
   reg [10:0]		       h_pos = 0;
   reg [10:0] 		       v_pos = 0;
   reg [ 7:0] 		       r_color = 8'b1111_1111;
   reg [ 7:0] 		       g_color = 8'b1111_1111;
   reg [ 7:0] 		       b_color = 8'b1111_1111;
   reg 			       draw = 0;

   always @ (posedge vga_clk_int) begin
      // Keep the horizontal position within its limits.
      if (h_pos < horiz_len) begin
	 h_pos <= h_pos + 1;
	 if (h_pos == v_pos) begin
	    draw = 1'b1;
	 end
	 else begin
	    draw = 1'b0;
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
	       .clk_clk(CLOCK_50),
	       .reset_reset_n(~reset),
	       .vga_clk_int_clk(vga_clk_int),
	       .vga_clk_ext_clk(vga_clk_ext)
	       );

   // HexDigit hex0(HEX0, vga_clk);
   // HexDigit hex1(HEX1, CLOCK_50);

   assign VGA_CLK = vga_clk_ext;
      
   assign VGA_R = (draw & (h_pos < hdisplay)) ? r_color : 0;
   assign VGA_B = (draw & (h_pos < hdisplay)) ? b_color : 0;
   assign VGA_G = (draw & (h_pos < hdisplay)) ? g_color : 0;

   assign VGA_BLANK_N = ~((h_pos >= hdisplay & h_pos < hback_porch) | (v_pos >= vdisplay & v_pos < vback_porch));
   assign VGA_HS = ~(h_pos >= hfront_porch & h_pos < hsync);
   assign VGA_VS = ~(v_pos >= vfront_porch & v_pos < vsync);
   assign VGA_SYNC_N = VGA_HS ^ VGA_VS;

endmodule
