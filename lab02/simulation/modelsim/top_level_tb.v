/* top_level_tb.v
 *
 * A testbench for top_level.v
 */

`timescale 10ns / 1ns

module top_level_tb ();

   reg clk_tb = 0;
   reg vga_g_tb;
   reg vga_b_tb;
   reg vga_r_tb;
   reg vga_blank_tb;
   reg vga_clk_tb;
   reg vga_hs_tb;
   reg vga_vs_tb;

   initial begin
      clk_tb = 0;
      vga_g_tb = 0;
      vga_b_tb = 0;
      vga_r_tb = 0;
      vga_blank_tb = 0;
      vga_clk_tb = 0;
      vga_hs_tb = 0;
      vga_vs_tb = 0;
   end
   
   always begin
      #1 clk_tb = !clk_tb;
   end
   
   top_level tb (
		 .CLOCK_50(clk_tb),
		 .VGA_G(vga_g_tb),
		 .VGA_B(vga_b_tb),
		 .VGA_R(vga_r_tb),
		 .VGA_BLANK_N(vga_blank_tb),
		 .VGA_CLK(vga_clk_tb),
		 .VGA_HS(vga_hs_tb),
		 .VGA_VS(vga_vs_tb)
		 );

endmodule
