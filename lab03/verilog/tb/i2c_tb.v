/* i2c_tb.v
 *
 * Tests the operation of the I2C controller, implemented by module i2c.v.
 */

`timescale 10ns/1ns
module i2c_tb;
   reg clk_50_tb = 0;
   reg start_tb = 0;
   wire [0:87] data_tb = {8'b0011_0100,                 // address frame
                          8'b0000_1010, 8'b0000_0110,   // 48kHz sampling frequency
                          8'b0000_1000, 8'b0001_0000,   // DAC for line out
                          8'b0000_0101, 8'b0111_1001,   // sound volume
                          8'b0000_1110, 8'b0000_1010,   // data transfer interface
                          8'b0001_0000, 8'b0000_0000};  // DAC sampling rate
   wire        sda_tb;
   wire        scl_tb;
   wire        configured_tb;
   reg         sda_reg_tb = 1'b1;
   reg         we_tb = 1;

   assign sda_tb = (we_tb) ? 1'bz : sda_reg_tb;

   i2c tb(
          .clk_50(clk_50_tb),
          .start(start_tb),
          .data(data_tb),
          .reset_n(1'b1),
          .sda(sda_tb),
          .scl(scl_tb),
          .configured(configured_tb)
          );

   integer     ack_count = 0;
   always @(negedge scl_tb) begin
      if (ack_count==8) begin
         ack_count <= 0;
         sda_reg_tb <= 0;  // Assume connection with slave is fine - send ACK signals.
         we_tb <= 0;
      end
      else begin
         we_tb <= 1;
         ack_count <= ack_count + 1;
      end
   end

   always begin
      #2 clk_50_tb <= !clk_50_tb;
   end

   initial begin
      #0 start_tb <= 1;
      #510 start_tb <= 0;
   end
endmodule // i2c_tb
