	component ip is
		port (
			clk_clk                  : in  std_logic := 'X'; -- clk
			pll_0_outclk12288mhz_clk : out std_logic;        -- clk
			pll_0_outclk2592mhz_clk  : out std_logic;        -- clk
			reset_reset_n            : in  std_logic := 'X'  -- reset_n
		);
	end component ip;

	u0 : component ip
		port map (
			clk_clk                  => CONNECTED_TO_clk_clk,                  --                  clk.clk
			pll_0_outclk12288mhz_clk => CONNECTED_TO_pll_0_outclk12288mhz_clk, -- pll_0_outclk12288mhz.clk
			pll_0_outclk2592mhz_clk  => CONNECTED_TO_pll_0_outclk2592mhz_clk,  --  pll_0_outclk2592mhz.clk
			reset_reset_n            => CONNECTED_TO_reset_reset_n             --                reset.reset_n
		);

