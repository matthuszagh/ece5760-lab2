	component system is
		port (
			clk_clk         : in  std_logic := 'X'; -- clk
			reset_reset_n   : in  std_logic := 'X'; -- reset_n
			vga_clk_ext_clk : out std_logic;        -- clk
			vga_clk_int_clk : out std_logic         -- clk
		);
	end component system;

	u0 : component system
		port map (
			clk_clk         => CONNECTED_TO_clk_clk,         --         clk.clk
			reset_reset_n   => CONNECTED_TO_reset_reset_n,   --       reset.reset_n
			vga_clk_ext_clk => CONNECTED_TO_vga_clk_ext_clk, -- vga_clk_ext.clk
			vga_clk_int_clk => CONNECTED_TO_vga_clk_int_clk  -- vga_clk_int.clk
		);

