/* top_level.v
 *
 * A top level module for ECE5760 lab2.
 */

module top_level (
		  // Clock pins.
		  input        CLOCK_50,

		  // VGA pins.
		  output [7:0] VGA_G,
		  output [7:0] VGA_B,
		  output [7:0] VGA_R,
		  output       VGA_BLANK_N,
		  output       VGA_CLK,
		  output       VGA_HS,
		  output       VGA_VS,

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
   localparam turquoise_r  = 8'b0010_0100;
   localparam turquoise_g  = 8'b1110_1011;
   localparam turquoise_b  = 8'b1100_1001;
   
   // Internal signals.
   wire 		       reset = ~KEY[0];
   wire 		       vga_clk_int;
   wire 		       vga_clk_ext;
   reg [10:0]		       h_pos = 0;
   reg [10:0] 		       v_pos = 0;
   reg [ 7:0] 		       r_color = black;
   reg [ 7:0] 		       g_color = black;
   reg [ 7:0] 		       b_color = black;

   reg [17:0] 		       screen_buf [0:1279];   // Screen display is 1280 pixels wide.
   reg [18:0] 		       count = 0;             // Adjust this based on desired frame rate.
   reg 			       slow_clk = 0;
   reg [17:0] 		       val = 0;
   integer 		       index;                 // Index for shift register.

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

   // Data.
   reg signed [9:0] k1_m1;// = 10'd2;                     // k1/m1 = spring constant of spring 1 divided by mass 1.
   reg signed [9:0] k2_m2;// = 10'd2;
   reg signed [9:0] km_m1;// = 10'd2;                     // km/m1 ; km = spring constant of middle spring.
   reg signed [9:0] km_m2;// = 10'd2;
   reg signed [9:0] k13_m1;// = 10'd16;                   // cubic spring term.
   reg signed [9:0] k23_m2;// = 10'd16;
   localparam x1_i = 130;
   localparam x2_i = 310;
   localparam v1_i = 0;
   localparam v2_i = 0;
   // reg signed [9:0] x1_i = 10'd130;                    // initial x1 position.
   // reg signed [9:0] x2_i = 10'd310;
   // reg signed [9:0] v1_i = 10'd0;                      // initial velocity of x1.
   // reg signed [9:0] v2_i = 10'd0;
   reg signed [9:0] x1_0;// = 10'd150;                    // origin of x1 mass (i.e. where spring 1 does not exert a force.
   reg signed [9:0] x2_0;// = 10'd300;
   reg signed [9:0] d1;// = 10'd1;                        // damping coefficient of the 1st mass (proportional to its velocity)
   reg signed [9:0] d2;// = 10'd1;
   reg [3:0] 	    dt;// = 4'd5;                         // time step. will perform arithmetic right shift, so equal to multiply by 2^(-dt)
   reg [3:0] 	    d_scale_fact;// = 4'd2;               // scale the damping coefficient.
   reg [3:0] 	    mem_read_count = 3'd0;             // select signal to sequentially parameters specified by the HPS.
   wire [3:0] 	    read_address = mem_read_count;  // address to read parameter from
   wire [15:0] 	    read_data;                         // data to read from mem
   
   // Position and velocity.
   reg signed [9:0] x1 = x1_i;
   reg signed [9:0] v1 = v1_i;
   reg signed [9:0] x2 = x2_i;
   reg signed [9:0] v2 = v2_i;

   // Update the frame.
   always @ (posedge slow_clk) begin
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
      for (index=1279; index>0; index=index-1) begin
	 screen_buf[index-1] <= screen_buf[index];
      end
   end // always @ (posedge slow_clk)

   // Read parameters from HPS.
   always @ (posedge CLOCK_50) begin
      mem_read_count <= mem_read_count + 1;
      case (mem_read_count)
	5'd00 : k1_m1 <= read_data[9:0];
	5'd01 : k2_m2 <= read_data[9:0];
	5'd02 : km_m1 <= read_data[9:0];
	5'd03 : km_m2 <= read_data[9:0];
	5'd04 : k13_m1 <= read_data[9:0];
	5'd05 : k23_m2 <= read_data[9:0];
	// 5'd12 : x1_i <= read_data[9:0];
	// 5'd14 : x2_i <= read_data[9:0];
	// 5'd16 : v1_i <= read_data[9:0];
	// 5'd18 : v2_i <= read_data[9:0];
	5'd10 : x1_0 <= read_data[9:0];
	5'd11 : x2_0 <= read_data[9:0];
	5'd12 : d1 <= read_data[9:0];
	5'd13 : d2 <= read_data[9:0];
	5'd14 : dt <= read_data[3:0];
	5'd15 : d_scale_fact <= read_data[3:0];
      endcase // case (mem_read_count)
   end // always @ (posedge CLOCK_50)
	
   // IP core instantiation.
   system pll (
	       .clk_clk(CLOCK_50),
	       .reset_reset_n(~reset),
	       // PLL
	       .vga_clk_int_clk(vga_clk_int),
	       .vga_clk_ext_clk(vga_clk_ext),
	       // RAM
	       .ram_conduit_address(read_address),
	       .ram_conduit_readdata(read_data)
	       );

   assign VGA_CLK = vga_clk_ext;
      
   assign VGA_R = (h_pos < hdisplay) ? r_color : 0;
   assign VGA_B = (h_pos < hdisplay) ? b_color : 0;
   assign VGA_G = (h_pos < hdisplay) ? g_color : 0;

   assign VGA_BLANK_N = ~((h_pos >= hdisplay & h_pos < hback_porch) | (v_pos >= vdisplay & v_pos < vback_porch));
   assign VGA_HS = ~(h_pos >= hfront_porch & h_pos < hsync);
   assign VGA_VS = ~(v_pos >= vfront_porch & v_pos < vsync);

endmodule
