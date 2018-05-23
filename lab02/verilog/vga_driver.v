/* vga_driver.v
 *
 * Implements logic to drive the VGA DAC.
 */

module vga_driver (
		  // Clock pins.
		  input        vga_clk_int,
                  input        vga_clk_ext,
                  input        slow_clk,

                  // Screen position values.
                  input signed [9:0]  x1,
                  input signed [9:0]  x2,

		  // VGA pins.
		  output [7:0] vga_g,
		  output [7:0] vga_b,
		  output [7:0] vga_r,
		  output       vga_blank_n,
		  output       vga_clk,
		  output       vga_hs,
		  output       vga_vs
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

   // Color params.
   localparam white        = 8'b1111_1111;
   localparam black        = 8'b0000_0000;
   localparam turquoise_r  = 8'b0010_0100;
   localparam turquoise_g  = 8'b1110_1011;
   localparam turquoise_b  = 8'b1100_1001;

   // Internal signals.
   reg [10:0]		       h_pos = 0;
   reg [10:0] 		       v_pos = 0;
   reg [ 7:0] 		       r_color = black;
   reg [ 7:0] 		       g_color = black;
   reg [ 7:0] 		       b_color = black;

   reg [17:0] 		       screen_buf [0:1279];   // Screen display is 1280 pixels wide.
   reg [17:0] 		       val = 0;
   integer 		       index;                 // Index for shift register.

   // Display the frame.
   always @ (posedge vga_clk_int) begin
      // Keep the horizontal position within its limits.
      if (h_pos < horiz_len) begin
	 h_pos <= h_pos + 1;
	 // Output data to screen.
	 if ((v_pos == {2'b0, screen_buf[h_pos][8:0]}) && (v_pos != 0)) begin
	    r_color <= white;
	    b_color <= white;
	    g_color <= white;
	 end
	 else if ((v_pos == {2'b0, screen_buf[h_pos][17:9]}) && (v_pos != 0)) begin
	    r_color <= turquoise_r;
	    b_color <= turquoise_b;
	    g_color <= turquoise_g;
	 end
	 else begin
	    r_color <= black;
	    b_color <= black;
	    g_color <= black;
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
   end // always @ (posedge vga_clk_int)

   // Update the frame.
   always @ (posedge slow_clk) begin
      // Load new value to the screen buffer.
      val <= {x2[8:0], x1[8:0]};
      screen_buf[1279] <= val;
      for (index=1279; index>0; index=index-1) begin
	 screen_buf[index-1] <= screen_buf[index];
      end
   end // always @ (posedge slow_clk)

   assign vga_clk = vga_clk_ext;

   assign vga_r = (h_pos < hdisplay) ? r_color : 0;
   assign vga_b = (h_pos < hdisplay) ? b_color : 0;
   assign vga_g = (h_pos < hdisplay) ? g_color : 0;

   assign vga_blank_n = ~((h_pos >= hdisplay & h_pos < hback_porch) | (v_pos >= vdisplay & v_pos < vback_porch));
   assign vga_hs = ~(h_pos >= hfront_porch & h_pos < hsync);
   assign vga_vs = ~(v_pos >= vfront_porch & v_pos < vsync);

endmodule
