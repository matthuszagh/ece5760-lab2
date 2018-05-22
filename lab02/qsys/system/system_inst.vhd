	component system is
		port (
			clk_clk                : in    std_logic                     := 'X';             -- clk
			memory_mem_a           : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba          : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck          : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n        : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke         : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n        : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n       : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n       : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n        : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n     : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq          : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs         : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n       : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt         : out   std_logic;                                        -- mem_odt
			memory_mem_dm          : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin       : in    std_logic                     := 'X';             -- oct_rzqin
			ram_conduit_address    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- address
			ram_conduit_chipselect : in    std_logic                     := 'X';             -- chipselect
			ram_conduit_clken      : in    std_logic                     := 'X';             -- clken
			ram_conduit_write      : in    std_logic                     := 'X';             -- write
			ram_conduit_readdata   : out   std_logic_vector(15 downto 0);                    -- readdata
			ram_conduit_writedata  : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			ram_conduit_byteenable : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			reset_reset_n          : in    std_logic                     := 'X';             -- reset_n
			vga_clk_ext_clk        : out   std_logic;                                        -- clk
			vga_clk_int_clk        : out   std_logic                                         -- clk
		);
	end component system;

	u0 : component system
		port map (
			clk_clk                => CONNECTED_TO_clk_clk,                --         clk.clk
			memory_mem_a           => CONNECTED_TO_memory_mem_a,           --      memory.mem_a
			memory_mem_ba          => CONNECTED_TO_memory_mem_ba,          --            .mem_ba
			memory_mem_ck          => CONNECTED_TO_memory_mem_ck,          --            .mem_ck
			memory_mem_ck_n        => CONNECTED_TO_memory_mem_ck_n,        --            .mem_ck_n
			memory_mem_cke         => CONNECTED_TO_memory_mem_cke,         --            .mem_cke
			memory_mem_cs_n        => CONNECTED_TO_memory_mem_cs_n,        --            .mem_cs_n
			memory_mem_ras_n       => CONNECTED_TO_memory_mem_ras_n,       --            .mem_ras_n
			memory_mem_cas_n       => CONNECTED_TO_memory_mem_cas_n,       --            .mem_cas_n
			memory_mem_we_n        => CONNECTED_TO_memory_mem_we_n,        --            .mem_we_n
			memory_mem_reset_n     => CONNECTED_TO_memory_mem_reset_n,     --            .mem_reset_n
			memory_mem_dq          => CONNECTED_TO_memory_mem_dq,          --            .mem_dq
			memory_mem_dqs         => CONNECTED_TO_memory_mem_dqs,         --            .mem_dqs
			memory_mem_dqs_n       => CONNECTED_TO_memory_mem_dqs_n,       --            .mem_dqs_n
			memory_mem_odt         => CONNECTED_TO_memory_mem_odt,         --            .mem_odt
			memory_mem_dm          => CONNECTED_TO_memory_mem_dm,          --            .mem_dm
			memory_oct_rzqin       => CONNECTED_TO_memory_oct_rzqin,       --            .oct_rzqin
			ram_conduit_address    => CONNECTED_TO_ram_conduit_address,    -- ram_conduit.address
			ram_conduit_chipselect => CONNECTED_TO_ram_conduit_chipselect, --            .chipselect
			ram_conduit_clken      => CONNECTED_TO_ram_conduit_clken,      --            .clken
			ram_conduit_write      => CONNECTED_TO_ram_conduit_write,      --            .write
			ram_conduit_readdata   => CONNECTED_TO_ram_conduit_readdata,   --            .readdata
			ram_conduit_writedata  => CONNECTED_TO_ram_conduit_writedata,  --            .writedata
			ram_conduit_byteenable => CONNECTED_TO_ram_conduit_byteenable, --            .byteenable
			reset_reset_n          => CONNECTED_TO_reset_reset_n,          --       reset.reset_n
			vga_clk_ext_clk        => CONNECTED_TO_vga_clk_ext_clk,        -- vga_clk_ext.clk
			vga_clk_int_clk        => CONNECTED_TO_vga_clk_int_clk         -- vga_clk_int.clk
		);

