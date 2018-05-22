
module system (
	clk_clk,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	ram_conduit_address,
	ram_conduit_chipselect,
	ram_conduit_clken,
	ram_conduit_write,
	ram_conduit_readdata,
	ram_conduit_writedata,
	ram_conduit_byteenable,
	reset_reset_n,
	vga_clk_ext_clk,
	vga_clk_int_clk);	

	input		clk_clk;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	input	[3:0]	ram_conduit_address;
	input		ram_conduit_chipselect;
	input		ram_conduit_clken;
	input		ram_conduit_write;
	output	[15:0]	ram_conduit_readdata;
	input	[15:0]	ram_conduit_writedata;
	input	[1:0]	ram_conduit_byteenable;
	input		reset_reset_n;
	output		vga_clk_ext_clk;
	output		vga_clk_int_clk;
endmodule
