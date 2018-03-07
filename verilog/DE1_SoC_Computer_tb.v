`timescale 1ps / 1ps


module DE1_SoC_Computer_tb ();

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  Internal REG/WIRE declarations
//=======================================================

reg	signed	[17:0]	v1			;
wire	signed	[17:0]	v1new			;
reg	signed	[17:0]	v1dot			;
wire	signed	[17:0]	v1dotnew		;
wire	signed	[17:0]	k1_m = 18'h1_0000	;
wire	signed	[17:0]	k1_mxv1			;
wire	signed	[17:0]	D1_m = 18'h0_4000	;
wire	signed	[17:0]	D1_mxv1dot		;
reg 	signed	[17:0]	func1			;

reg	signed	[17:0]	v2			;
wire	signed	[17:0]	v2new			;
reg	signed	[17:0]	v2dot			;
wire	signed	[17:0]	v2dotnew		;
wire	signed	[17:0]	k2_m = 18'h1_0000	;
wire	signed	[17:0]	k2_mxv2			;
wire	signed	[17:0]	D2_m = 18'h0_4000	;
wire	signed	[17:0]	D2_mxv2dot		;
reg	signed	[17:0]	func2			;

wire		[ 3:0]	dt = 4'd9		;
wire	signed	[17:0]	kmid_m = 18'h1_0000	;
wire	signed	[17:0]	kmid_mxv1		;
wire	signed	[17:0]	kmid_mxv2		;

// Bus master
wire	[31:0]	bus_addr			;
wire	[31:0]	video_base_addr = 32'h800_0000	;	/* address of the onchip
							 * SRAM that we will be
							 * loaded into the pixel
							 * buffer */
wire	[ 3:0]	bus_byte_enable			;	/* specifies that data is being transferred */
reg 		bus_read			;	/* high when requesting data */
reg 		bus_write			;	/* high when writing data */
reg 	[31:0]	bus_write_data			;	/* data to send to Avalon bus */
wire		bus_ack				; 	/* Avalon bus raises this when done */
wire	[31:0]	bus_read_data			;	/* data from Avalon bus */
reg 	[30:0]	timer				;
reg 	[ 3:0]	state				;
wire		state_clock			;

// Pixel address
reg 	[ 9:0]	x_coord, y_coord		;


// Simulation variables
reg		clk_ = 0			;
reg	[ 3:0]	key_ = 4'b0000			;
wire		vga_hs_ = 0			;
wire		vga_vs_ = 0			;


//=======================================================
//  Behavioral Modelling
//=======================================================

//compute the intermediary values for our function
signed_mult k_m1 (
	.out(k1_mxv1),
	.a(k1_m),
	.b(v1)
);
signed_mult D_m1 (
	.out(D1_mxv1dot),
	.a(D1_m),
	.b(v1dot)
);

signed_mult k_m2 (
	.out(k2_mxv2),
	.a(k2_m),
	.b(v2)
);
signed_mult D_m2 (
	.out(D2_mxv2dot),
	.a(D2_m),
	.b(v2dot)
);

signed_mult kmid_m1 (
	.out(kmid_mxv1),
	.a(kmid_m),
	.b(v1)
);
signed_mult kmid_m2 (
	.out(kmid_mxv2),
	.a(kmid_m),
	.b(v2)
);

// integrate
integrator int1 (
	.xnew(v1dotnew),
	.reset(key_[3]),
	.clock(clk_),
	.dt(dt),
	.x(v1),
	.func(func1)
);
integrator int2 (
	.xnew(v2dotnew),
	.reset(key_[3]),
	.clock(clk_),
	.dt(dt),
	.x(v2),
	.func(func2)
);

integrator int12 (
	.xnew(v1new),
	.reset(key_[3]),
	.clock(clk_),
	.dt(dt),
	.x(v1),
	.func(v1dotnew)
);
integrator int22 (
	.xnew(v2new),
	.reset(key_[3]),
	.clock(clk_),
	.dt(dt),
	.x(v2),
	.func(v2dotnew)
);

always clk_ = #100 ~clk_;

initial #105 key_ = 4'b0001;


// assign bus_addr to pixel address
assign bus_addr = video_base_addr + {22'b0, x_coord} + ({22'b0, y_coord}<<10);
assign bus_byte_enable = 4'b0001;

always @ (posedge clk_) begin	// on VGA sync signal...
	$display("key: ", key_);
	$display("state: ", state);
	$display("vga_vs: ", vga_vs_);
	$display("vga_hs: ", vga_hs_);

	// if pushbutton 1 (furthest right) is pushed, reset state
	if (~key_[0]) begin
		$display("begin");
		state <= 0;	
		bus_read <= 0;
		bus_write <= 0;
		// pixel address at upper left corner
		x_coord <= 0;
		y_coord <= 10'd100;
		timer <= 0;
		// set starting values
		v1 <= 18'h3_8000;	// 18'h3_8000
		v2 <= 18'h0_8000;
		v1dot <= 0;
		v2dot <= 0;
		func1 <= 0;
		func2 <= 0;
	end
	else begin	// increment timer
		timer <= timer + 1;
	end

	// write to bus master if VGA is not reading
	if (state==0 && (~vga_vs_ | ~vga_hs_)) begin
		$display("continuing");
		state <= 2;		// why do i need this????

		func1 <= -k1_mxv1 + (kmid_mxv2 - kmid_mxv1) - D1_mxv1dot;
		func2 <= -k2_mxv2 - (kmid_mxv2 - kmid_mxv1) - D2_mxv2dot;
		
		$display("func1: ", func1);
		$display("func2: ", func2);

		$display("vlnew: ", v1new);
		$display("v2new: ", v2new);

		v1 <= v1new;
		v2 <= v2new;

		$display("v1: ", v1);
		$display("v2: ", v2);

		x_coord <= x_coord + 10'd1;
		if (x_coord > 10'd639) begin
			x_coord <= 10'd0;
		end
		
		if (v1[17]) begin
			y_coord <= y_coord - v1[16:13];
		end
		else begin
			y_coord <= y_coord + v1[16:13];
		end
		$display("v1: ", v1);
		$display("v1[16:13]: ", v1[16:13]);
		$display("y_coord + v1[16:13]: ", y_coord + v1[16:13]);
		if (y_coord > 10'd399) begin
			$display("Got too big");
			y_coord <= 0;
		end

		bus_write_data <= 8'h03;
		bus_write <= 1'b1;
	end

	// detect bus-transaction-complete ACK
	// You MUST do this check
	if (state==2) begin
		$display("ACK");
		state <= 0;
		bus_write <= 0;
	end
end

endmodule
