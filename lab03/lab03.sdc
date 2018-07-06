create_clock -name clk_50 -period 20 [get_ports CLOCK_50]

derive_pll_clocks

create_generated_clock -source [get_pins {scl}] -name scl [get_ports FPGA_I2C_SCLK]
create_generated_clock -source [get_pins {i2s_inst|ip_pll|pll_0|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -name bclk [get_ports AUD_BCLK]

derive_clock_uncertainty

set_false_path -to [get_ports FPGA_I2C_SCLK]
set_false_path -to [get_ports AUD_XCK]
set_false_path -to [get_ports AUD_BCLK]
set_false_path -to [get_ports AUD_DACLRCK]

set_false_path -to [get_ports HEX*]

set_output_delay -clock scl -min 0.0 [get_ports FPGA_I2C_SDAT]
set_output_delay -clock scl -max 0.0 [get_ports FPGA_I2C_SDAT]

set_output_delay -clock bclk -min 0.0 [get_ports AUD_DACDAT]
set_output_delay -clock bclk -max 0.0 [get_ports AUD_DACDAT]