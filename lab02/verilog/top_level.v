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

   reg [7:0] 		       screen_buf [0:1279];   // Screen display is 1280 pixels wide.
   reg [18:0] 		       count = 0;             // Adjust this based on desired frame rate.
   reg 			       slow_clk = 0;
   reg [7:0] 		       val = 0;
   integer 		       i;                     // Index for shift register.

   // Display the frame.
   always @ (posedge vga_clk_int) begin
      // Create slow clock that will be used to write new values to the frame.
      count <= count + 1;
      if (count == 0) begin
	 slow_clk = ~slow_clk;
      end

      // Keep the horizontal position within its limits.
      if (h_pos < horiz_len) begin
	 h_pos <= h_pos + 1;
	 // Output data to screen.
	 if (v_pos == {3'b0, screen_buf[h_pos]}) begin
	    r_color <= white;
	    b_color <= white;
	    g_color <= white;
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


   // Data.
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
   always @ (posedge slow_clk) begin
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

   // IP core instantiation.
   system pll (
	       // PLL
	       .clk_clk(CLOCK_50),
	       .reset_reset_n(~reset),
	       .vga_clk_int_clk(vga_clk_int),
	       .vga_clk_ext_clk(vga_clk_ext)
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
