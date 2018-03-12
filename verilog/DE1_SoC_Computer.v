

module DE1_SoC_Computer (
	////////////////////////////////////
	// FPGA Pins
	////////////////////////////////////

	// Clock pins
	input			CLOCK_50		,
	input			CLOCK2_50		,	// synchronizes the activity of the VGA
	input			CLOCK3_50		,
	input			CLOCK4_50		,

	// ADC
	inout			ADC_CS_N		,
	output			ADC_DIN			,
	input			ADC_DOUT		,
	output			ADC_SCLK		,

	// Audio
	input			AUD_ADCDAT		,
	inout			AUD_ADCLRCK		,
	inout			AUD_BCLK		,
	output			AUD_DACDAT		,
	inout			AUD_DACLRCK		,
	output			AUD_XCK			,

	// SDRAM
	output	[12: 0]		DRAM_ADDR		,
	output	[ 1: 0]		DRAM_BA			,
	output			DRAM_CAS_N		,
	output			DRAM_CKE		,
	output			DRAM_CLK		,
	output			DRAM_CS_N		,
	inout	[15: 0]		DRAM_DQ			,
	output			DRAM_LDQM		,
	output			DRAM_RAS_N		,
	output			DRAM_UDQM		,
	output			DRAM_WE_N		,

	// I2C Bus for Configuration of the Audio and Video-In Chips
	output			FPGA_I2C_SCLK		,
	inout			FPGA_I2C_SDAT		,

	// 40-pin headers
	inout	[35: 0]		GPIO_0			,
	inout	[35: 0]		GPIO_1			,

	// Seven Segment Displays
	output	[ 6: 0]		HEX0			,
	output	[ 6: 0]		HEX1			,
	output	[ 6: 0]		HEX2			,
	output	[ 6: 0]		HEX3			,
	output	[ 6: 0]		HEX4			,
	output	[ 6: 0]		HEX5			,

	// IR
	input			IRDA_RXD		,
	output			IRDA_TXD		,

	// Pushbuttons
	input	[ 3: 0]		KEY			,

	// LEDs
	output	[ 9: 0]		LEDR			,

	// PS2 Ports
	inout			PS2_CLK			,
	inout			PS2_DAT			,

	inout			PS2_CLK2		,
	inout			PS2_DAT2		,

	// Slider Switches
	input	[ 9: 0]		SW			,

	// Video-In
	input			TD_CLK27		,
	input	[ 7: 0]		TD_DATA			,
	input			TD_HS			,
	output			TD_RESET_N		,
	input			TD_VS			,

	// VGA
	output	[ 7: 0]		VGA_B			,	// blue line
	output			VGA_BLANK_N		,
	output			VGA_CLK			,	// clock
	output	[ 7: 0]		VGA_G			,	// green line
	output			VGA_HS			,	// hsync
	output	[ 7: 0]		VGA_R			,	// red line
	output			VGA_SYNC_N		,
	output			VGA_VS			,	// vsync



	////////////////////////////////////
	// HPS Pins
	////////////////////////////////////
		
	// DDR3 SDRAM
	output	[14: 0]		HPS_DDR3_ADDR		,
	output	[ 2: 0]		HPS_DDR3_BA		,
	output			HPS_DDR3_CAS_N		,
	output			HPS_DDR3_CKE		,
	output			HPS_DDR3_CK_N		,
	output			HPS_DDR3_CK_P		,
	output			HPS_DDR3_CS_N		,
	output	[ 3: 0]		HPS_DDR3_DM		,
	inout	[31: 0]		HPS_DDR3_DQ		,
	inout	[ 3: 0]		HPS_DDR3_DQS_N		,
	inout	[ 3: 0]		HPS_DDR3_DQS_P		,
	output			HPS_DDR3_ODT		,
	output			HPS_DDR3_RAS_N		,
	output			HPS_DDR3_RESET_N	,
	input			HPS_DDR3_RZQ		,
	output			HPS_DDR3_WE_N		,

	// Ethernet
	output			HPS_ENET_GTX_CLK	,
	inout			HPS_ENET_INT_N		,
	output			HPS_ENET_MDC		,
	inout			HPS_ENET_MDIO		,
	input			HPS_ENET_RX_CLK		,
	input	[ 3: 0]		HPS_ENET_RX_DATA	,
	input			HPS_ENET_RX_DV		,
	output	[ 3: 0]		HPS_ENET_TX_DATA	,
	output			HPS_ENET_TX_EN		,

	// Flash
	inout	[ 3: 0]		HPS_FLASH_DATA		,
	output			HPS_FLASH_DCLK		,
	output			HPS_FLASH_NCSO		,

	// Accelerometer
	inout			HPS_GSENSOR_INT		,

	// General Purpose I/O
	inout	[ 1: 0]		HPS_GPIO		,

	// I2C
	inout			HPS_I2C_CONTROL		,
	inout			HPS_I2C1_SCLK		,
	inout			HPS_I2C1_SDAT		,
	inout			HPS_I2C2_SCLK		,
	inout			HPS_I2C2_SDAT		,

	// Pushbutton
	inout			HPS_KEY			,

	// LED
	inout			HPS_LED			,

	// SD Card
	output			HPS_SD_CLK		,
	inout			HPS_SD_CMD		,
	inout	[ 3: 0]		HPS_SD_DATA		,

	// SPI
	output			HPS_SPIM_CLK		,
	input			HPS_SPIM_MISO		,
	output			HPS_SPIM_MOSI		,
	inout			HPS_SPIM_SS		,

	// UART
	input			HPS_UART_RX		,
	output			HPS_UART_TX		,

	// USB
	inout			HPS_CONV_USB_N		,
	input			HPS_USB_CLKOUT		,
	inout	[ 7: 0]		HPS_USB_DATA		,
	input			HPS_USB_DIR		,
	input			HPS_USB_NXT		,
	output			HPS_USB_STP

);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  Internal REG/WIRE declarations
//=======================================================

reg	signed	[17:0]	v1				;
wire	signed	[17:0]	v1new				;
reg	signed	[17:0]	v1dot				;
wire	signed	[17:0]	v1dotnew			;
reg	signed	[17:0]	k1_m = 18'h1_0000		;
wire	signed	[17:0]	k1_mxv1				;
reg	signed	[17:0]	D1_m = 18'h0_4000		;
wire	signed	[17:0]	D1_mxv1dot			;
wire 	signed	[17:0]	func1				;

reg	signed	[17:0]	v2				;
wire	signed	[17:0]	v2new				;
reg	signed	[17:0]	v2dot				;
wire	signed	[17:0]	v2dotnew			;
reg	signed	[17:0]	k2_m = 18'h1_0000		;
wire	signed	[17:0]	k2_mxv2				;
reg	signed	[17:0]	D2_m = 18'h0_4000		;
wire	signed	[17:0]	D2_mxv2dot			;
wire	signed	[17:0]	func2				;

reg		[ 3:0]	dt = 4'd9			;
reg	signed	[17:0]	kmid_m = 18'h1_0000		;
wire	signed	[17:0]	kmid_mxv1			;
wire	signed	[17:0]	kmid_mxv2			;

// Bus master
wire	[31:0]	bus_addr				;
wire	[31:0]	video_base_addr = 32'h800_0000		;	/* address of the onchip
								 * SRAM that we will be
								 * loaded into the pixel
								 * buffer */
wire	[ 3:0]	bus_byte_enable				;	/* specifies that data is being transferred */
reg 		bus_read				;	/* high when requesting data */
reg 		bus_write				;	/* high when writing data */
reg 	[31:0]	bus_write_data				;	/* data to send to Avalon bus */
wire		bus_ack					; 	/* Avalon bus raises this when done */
wire	[31:0]	bus_read_data				;	/* data from Avalon bus */
reg 	[30:0]	timer					;
reg 	[ 3:0]	state					;
wire		state_clock				;
reg		integrator_reset_			;	/* used to specify when the integrators should be
								 * initialized */

// Pixel address
reg 	[ 9:0]	x_coord, y_coord			;


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
	.reset(integrator_reset_),
	.clock(CLOCK2_50),
	.dt(dt),
	.x(v1),
	.func(func1)
);
integrator int2 (
	.xnew(v2dotnew),
	.reset(integrator_reset_),
	.clock(CLOCK2_50),
	.dt(dt),
	.x(v2),
	.func(func2)
);

integrator int12 (
	.xnew(v1new),
	.reset(integrator_reset_),
	.clock(CLOCK2_50),
	.dt(dt),
	.x(v1),
	.func(v1dotnew)
);
integrator int22 (
	.xnew(v2new),
	.reset(integrator_reset_),
	.clock(CLOCK2_50),
	.dt(dt),
	.x(v2),
	.func(v2dotnew)
);

assign func1 = -k1_mxv1 + (kmid_mxv2 - kmid_mxv1) - D1_mxv1dot;
assign func2 = -k2_mxv2 - (kmid_mxv2 - kmid_mxv1) - D2_mxv2dot;

// assign bus_addr to pixel address
assign bus_addr = video_base_addr + {22'b0, x_coord} + ({22'b0, y_coord}<<10);
assign bus_byte_enable = 4'b0001;

// set all hex digits to  0
HexDigit set_hex_0(HEX0, x_coord[0]);
HexDigit set_hex_1(HEX1, x_coord[1]);
HexDigit set_hex_2(HEX2, x_coord[2]);
HexDigit set_hex_3(HEX3, x_coord[3]);
HexDigit set_hex_4(HEX4, x_coord[4]);
HexDigit set_hex_5(HEX5, x_coord[5]);

always @ (posedge CLOCK2_50) begin	// on VGA sync signal...
	// if pushbutton 1 (furthest right) is pushed, reset state
	if (~KEY[0]) begin
		state <= 0;	
		bus_read <= 0;
		bus_write <= 0;
		// pixel address at upper left corner
		x_coord <= 0;
		//y_coord <= 10'd100;
		timer <= 0;
		// set starting values
		v1 <= 18'h3_8000;
		v2 <= 18'h0_8000;
		v1dot <= 0;
		v2dot <= 0;
		integrator_reset_ <= 1;
	end
	else begin	// increment timer
		timer <= timer + 1;
	end

	// write to bus master if VGA is not reading
	if (state==0 && timer==3 && (~VGA_VS | ~VGA_HS)) begin
		state <= 2;		// why do i need this????
		integrator_reset_ <= 0;
		timer <= 0;	
	
		v1 <= v1new;
		v2 <= v2new;

		v1dot <= v1dotnew;
		v2dot <= v2dotnew;

		x_coord <= x_coord + 10'd1;
		if (x_coord > 10'd639) begin
			x_coord <= 10'd0;
		end

		y_coord <= (v1>>>12)+32;

		bus_write_data <= 8'hff;
		bus_write <= 1'b1;
	end

	// detect bus-transaction-complete ACK
	// You MUST do this check
	if (state==2 && bus_ack==1) begin
		state <= 0;
		bus_write <= 0;
	end
end


//=======================================================
//  Structural coding
//=======================================================

Computer_System The_System (
	/* This module instantiation connects the FPGA IO cells (specified by the
	 * Qsys output, Computer_System.v) to the ports of our top-level module,
	 * DE1_SoC_Computer.v.
	 */
	////////////////////////////////////
	// FPGA Side
	////////////////////////////////////

	// Global signals
	.system_pll_ref_clk_clk								(CLOCK_50),
	.system_pll_ref_reset_reset							(1'b0),

	// AV Config
	.av_config_SDAT                                  	(FPGA_I2C_SDAT),   	// .SDAT
	.av_config_SCLK                                  	(FPGA_I2C_SCLK),   	// .SCLK
	
	// Bus master (32 bits)
	.bus_master_video_external_interface_address     	(bus_addr),			// .address
	.bus_master_video_external_interface_byte_enable 	(bus_byte_enable), 	// .byte_enable
	.bus_master_video_external_interface_read        	(bus_read),        	// .read
	.bus_master_video_external_interface_write       	(bus_write),       	// .write
	.bus_master_video_external_interface_write_data  	(bus_write_data),  	// .write_data
	.bus_master_video_external_interface_acknowledge 	(bus_ack), 			// .acknowledge
	.bus_master_video_external_interface_read_data   	(bus_read_data),	// .read_data

	// VGA Subsystem
	.vga_pll_ref_clk_clk								(CLOCK2_50),
	.vga_pll_ref_reset_reset							(1'b0),
	.vga_CLK											(VGA_CLK),
	.vga_BLANK											(VGA_BLANK_N),
	.vga_SYNC											(VGA_SYNC_N),
	.vga_HS												(VGA_HS),
	.vga_VS												(VGA_VS),
	.vga_R												(VGA_R),
	.vga_G												(VGA_G),
	.vga_B												(VGA_B),

	// SDRAM
	.sdram_clk_clk										(DRAM_CLK),
 	.sdram_addr											(DRAM_ADDR),
	.sdram_ba											(DRAM_BA),
	.sdram_cas_n										(DRAM_CAS_N),
	.sdram_cke											(DRAM_CKE),
	.sdram_cs_n											(DRAM_CS_N),
	.sdram_dq											(DRAM_DQ),
	.sdram_dqm											({DRAM_UDQM,DRAM_LDQM}),
	.sdram_ras_n										(DRAM_RAS_N),
	.sdram_we_n											(DRAM_WE_N),
	
	////////////////////////////////////
	// HPS Side
	////////////////////////////////////
	// DDR3 SDRAM
	.memory_mem_a										(HPS_DDR3_ADDR),
	.memory_mem_ba										(HPS_DDR3_BA),
	.memory_mem_ck										(HPS_DDR3_CK_P),
	.memory_mem_ck_n									(HPS_DDR3_CK_N),
	.memory_mem_cke										(HPS_DDR3_CKE),
	.memory_mem_cs_n									(HPS_DDR3_CS_N),
	.memory_mem_ras_n									(HPS_DDR3_RAS_N),
	.memory_mem_cas_n									(HPS_DDR3_CAS_N),
	.memory_mem_we_n									(HPS_DDR3_WE_N),
	.memory_mem_reset_n									(HPS_DDR3_RESET_N),
	.memory_mem_dq										(HPS_DDR3_DQ),
	.memory_mem_dqs										(HPS_DDR3_DQS_P),
	.memory_mem_dqs_n									(HPS_DDR3_DQS_N),
	.memory_mem_odt										(HPS_DDR3_ODT),
	.memory_mem_dm										(HPS_DDR3_DM),
	.memory_oct_rzqin									(HPS_DDR3_RZQ),
		  
	// Ethernet
	.hps_io_hps_io_gpio_inst_GPIO35						(HPS_ENET_INT_N),
	.hps_io_hps_io_emac1_inst_TX_CLK					(HPS_ENET_GTX_CLK),
	.hps_io_hps_io_emac1_inst_TXD0						(HPS_ENET_TX_DATA[0]),
	.hps_io_hps_io_emac1_inst_TXD1						(HPS_ENET_TX_DATA[1]),
	.hps_io_hps_io_emac1_inst_TXD2						(HPS_ENET_TX_DATA[2]),
	.hps_io_hps_io_emac1_inst_TXD3						(HPS_ENET_TX_DATA[3]),
	.hps_io_hps_io_emac1_inst_RXD0						(HPS_ENET_RX_DATA[0]),
	.hps_io_hps_io_emac1_inst_MDIO						(HPS_ENET_MDIO),
	.hps_io_hps_io_emac1_inst_MDC						(HPS_ENET_MDC),
	.hps_io_hps_io_emac1_inst_RX_CTL					(HPS_ENET_RX_DV),
	.hps_io_hps_io_emac1_inst_TX_CTL					(HPS_ENET_TX_EN),
	.hps_io_hps_io_emac1_inst_RX_CLK					(HPS_ENET_RX_CLK),
	.hps_io_hps_io_emac1_inst_RXD1						(HPS_ENET_RX_DATA[1]),
	.hps_io_hps_io_emac1_inst_RXD2						(HPS_ENET_RX_DATA[2]),
	.hps_io_hps_io_emac1_inst_RXD3						(HPS_ENET_RX_DATA[3]),

	// Flash
	.hps_io_hps_io_qspi_inst_IO0						(HPS_FLASH_DATA[0]),
	.hps_io_hps_io_qspi_inst_IO1						(HPS_FLASH_DATA[1]),
	.hps_io_hps_io_qspi_inst_IO2						(HPS_FLASH_DATA[2]),
	.hps_io_hps_io_qspi_inst_IO3						(HPS_FLASH_DATA[3]),
	.hps_io_hps_io_qspi_inst_SS0						(HPS_FLASH_NCSO),
	.hps_io_hps_io_qspi_inst_CLK						(HPS_FLASH_DCLK),

	// Accelerometer
	.hps_io_hps_io_gpio_inst_GPIO61						(HPS_GSENSOR_INT),

	// General Purpose I/O
	.hps_io_hps_io_gpio_inst_GPIO40						(HPS_GPIO[0]),
	.hps_io_hps_io_gpio_inst_GPIO41						(HPS_GPIO[1]),

	// I2C
	.hps_io_hps_io_gpio_inst_GPIO48						(HPS_I2C_CONTROL),
	.hps_io_hps_io_i2c0_inst_SDA						(HPS_I2C1_SDAT),
	.hps_io_hps_io_i2c0_inst_SCL						(HPS_I2C1_SCLK),
	.hps_io_hps_io_i2c1_inst_SDA						(HPS_I2C2_SDAT),
	.hps_io_hps_io_i2c1_inst_SCL						(HPS_I2C2_SCLK),

	// Pushbutton
	.hps_io_hps_io_gpio_inst_GPIO54						(HPS_KEY),

	// LED
	.hps_io_hps_io_gpio_inst_GPIO53						(HPS_LED),

	// SD Card
	.hps_io_hps_io_sdio_inst_CMD						(HPS_SD_CMD),
	.hps_io_hps_io_sdio_inst_D0							(HPS_SD_DATA[0]),
	.hps_io_hps_io_sdio_inst_D1							(HPS_SD_DATA[1]),
	.hps_io_hps_io_sdio_inst_CLK						(HPS_SD_CLK),
	.hps_io_hps_io_sdio_inst_D2							(HPS_SD_DATA[2]),
	.hps_io_hps_io_sdio_inst_D3							(HPS_SD_DATA[3]),

	// SPI
	.hps_io_hps_io_spim1_inst_CLK						(HPS_SPIM_CLK),
	.hps_io_hps_io_spim1_inst_MOSI						(HPS_SPIM_MOSI),
	.hps_io_hps_io_spim1_inst_MISO						(HPS_SPIM_MISO),
	.hps_io_hps_io_spim1_inst_SS0						(HPS_SPIM_SS),

	// UART
	.hps_io_hps_io_uart0_inst_RX						(HPS_UART_RX),
	.hps_io_hps_io_uart0_inst_TX						(HPS_UART_TX),

	// USB
	.hps_io_hps_io_gpio_inst_GPIO09						(HPS_CONV_USB_N),
	.hps_io_hps_io_usb1_inst_D0							(HPS_USB_DATA[0]),
	.hps_io_hps_io_usb1_inst_D1							(HPS_USB_DATA[1]),
	.hps_io_hps_io_usb1_inst_D2							(HPS_USB_DATA[2]),
	.hps_io_hps_io_usb1_inst_D3							(HPS_USB_DATA[3]),
	.hps_io_hps_io_usb1_inst_D4							(HPS_USB_DATA[4]),
	.hps_io_hps_io_usb1_inst_D5							(HPS_USB_DATA[5]),
	.hps_io_hps_io_usb1_inst_D6							(HPS_USB_DATA[6]),
	.hps_io_hps_io_usb1_inst_D7							(HPS_USB_DATA[7]),
	.hps_io_hps_io_usb1_inst_CLK						(HPS_USB_CLKOUT),
	.hps_io_hps_io_usb1_inst_STP						(HPS_USB_STP),
	.hps_io_hps_io_usb1_inst_DIR						(HPS_USB_DIR),
	.hps_io_hps_io_usb1_inst_NXT						(HPS_USB_NXT)
);


endmodule
