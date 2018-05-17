#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 [get_ports CLOCK_50]



#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks

create_generated_clock -source [get_pins {pll|pll_0|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -name clk_vga [get_ports {VGA_CLK}]

create_generated_clock -name slow_clk -multiply_by 262144 -source clk_vga [get_pins slow_clk]


#**************************************************************
# Set Clock Latency
#**************************************************************
set max_ref_clk 2.0;	# Best guess of max time for input reference clock to reach source reg.
set min_ref_clk 1.8;	# Best guess of min time for input reference clock to reach source reg.

set_clock_latency -source -late $max_ref_clk [get_clocks CLOCK_50]
set_clock_latency -source -early $min_ref_clk [get_clocks CLOCK_50]



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Output Delay
#**************************************************************
set vga_tsu_ext 0.2;		# ADV7123 setup time at 3.3V.
set vga_th_ext 1.5;	      	# ADV7123 hold time at 3.3V.
set vga_max_fpga2ext 1.5;	# Estimate for max time for delay between fpga output pin and ADV7123 input pin.
set vga_min_fpga2ext 0.5;	# Estimate for min time for delay between fpga output pin and ADV7123 input pin.

# VGA_CLK
set_false_path -to [get_ports VGA_CLK]
# VGA_R
set_output_delay -clock clk_vga -max [expr $vga_tsu_ext+$vga_max_fpga2ext] [get_ports VGA_R*]
set_output_delay -clock clk_vga -min [expr -$vga_th_ext+$vga_min_fpga2ext] [get_ports VGA_R*]
# VGA_G
set_output_delay -clock clk_vga -max [expr $vga_tsu_ext+$vga_max_fpga2ext] [get_ports VGA_G*]
set_output_delay -clock clk_vga -min [expr -$vga_th_ext+$vga_min_fpga2ext] [get_ports VGA_G*]
# VGA_B
set_output_delay -clock clk_vga -max [expr $vga_tsu_ext+$vga_max_fpga2ext] [get_ports VGA_B*]
set_output_delay -clock clk_vga -min [expr -$vga_th_ext+$vga_min_fpga2ext] [get_ports VGA_B*]
# VGA_BLANK_N
set_output_delay -clock clk_vga -max [expr $vga_tsu_ext+$vga_max_fpga2ext] [get_ports VGA_BLANK_N]
set_output_delay -clock clk_vga -min [expr -$vga_th_ext+$vga_min_fpga2ext] [get_ports VGA_BLANK_N]
# VGA_HS
set_output_delay -clock clk_vga -max [expr $vga_tsu_ext+$vga_max_fpga2ext] [get_ports VGA_HS]
set_output_delay -clock clk_vga -min [expr -$vga_th_ext+$vga_min_fpga2ext] [get_ports VGA_HS]
# VGA_VS
set_output_delay -clock clk_vga -max [expr $vga_tsu_ext+$vga_max_fpga2ext] [get_ports VGA_VS]
set_output_delay -clock clk_vga -min [expr -$vga_th_ext+$vga_min_fpga2ext] [get_ports VGA_VS]

