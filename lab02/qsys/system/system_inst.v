	system u0 (
		.clk_clk                (<connected-to-clk_clk>),                //         clk.clk
		.memory_mem_a           (<connected-to-memory_mem_a>),           //      memory.mem_a
		.memory_mem_ba          (<connected-to-memory_mem_ba>),          //            .mem_ba
		.memory_mem_ck          (<connected-to-memory_mem_ck>),          //            .mem_ck
		.memory_mem_ck_n        (<connected-to-memory_mem_ck_n>),        //            .mem_ck_n
		.memory_mem_cke         (<connected-to-memory_mem_cke>),         //            .mem_cke
		.memory_mem_cs_n        (<connected-to-memory_mem_cs_n>),        //            .mem_cs_n
		.memory_mem_ras_n       (<connected-to-memory_mem_ras_n>),       //            .mem_ras_n
		.memory_mem_cas_n       (<connected-to-memory_mem_cas_n>),       //            .mem_cas_n
		.memory_mem_we_n        (<connected-to-memory_mem_we_n>),        //            .mem_we_n
		.memory_mem_reset_n     (<connected-to-memory_mem_reset_n>),     //            .mem_reset_n
		.memory_mem_dq          (<connected-to-memory_mem_dq>),          //            .mem_dq
		.memory_mem_dqs         (<connected-to-memory_mem_dqs>),         //            .mem_dqs
		.memory_mem_dqs_n       (<connected-to-memory_mem_dqs_n>),       //            .mem_dqs_n
		.memory_mem_odt         (<connected-to-memory_mem_odt>),         //            .mem_odt
		.memory_mem_dm          (<connected-to-memory_mem_dm>),          //            .mem_dm
		.memory_oct_rzqin       (<connected-to-memory_oct_rzqin>),       //            .oct_rzqin
		.ram_conduit_address    (<connected-to-ram_conduit_address>),    // ram_conduit.address
		.ram_conduit_chipselect (<connected-to-ram_conduit_chipselect>), //            .chipselect
		.ram_conduit_clken      (<connected-to-ram_conduit_clken>),      //            .clken
		.ram_conduit_write      (<connected-to-ram_conduit_write>),      //            .write
		.ram_conduit_readdata   (<connected-to-ram_conduit_readdata>),   //            .readdata
		.ram_conduit_writedata  (<connected-to-ram_conduit_writedata>),  //            .writedata
		.ram_conduit_byteenable (<connected-to-ram_conduit_byteenable>), //            .byteenable
		.reset_reset_n          (<connected-to-reset_reset_n>),          //       reset.reset_n
		.vga_clk_ext_clk        (<connected-to-vga_clk_ext_clk>),        // vga_clk_ext.clk
		.vga_clk_int_clk        (<connected-to-vga_clk_int_clk>)         // vga_clk_int.clk
	);

