/* top.v
 *
 * Instantiates the other submodules and controls their operation.
 */

module top (
            // Clocks
            input       CLOCK_50, /* 50MHz reference clock. */
            // I2C Interface
            output      FPGA_I2C_SCLK, /* Serial clock for I2C. */
            inout       FPGA_I2C_SDAT, /* Serial data line for I2C. It must be bidirectional to receive
                                         the ACK/NACK signal from the audio codec. */
            // I2S Interface
            output      AUD_XCK, /* Master 12.288MHz clock to drive the MCLK pin of the audio codec. */
            output      AUD_BCLK, /* 2.592MHz bit clock to synchronize the data transfer. */
            output      AUD_DACLRCK, /* 48kHz clock that synchronizes a full sample of data. */
            output      AUD_DACDAT, /* Serialized data to drive the DAC at the bit clock. */
            // HEX
            output [6:0] HEX0,
            output [6:0] HEX1,
            output [6:0] HEX2,
            output [6:0] HEX3,
            // output [6:0] HEX4,
            // output [6:0] HEX5

            // KEY
            input [3:0] KEY
            );

   // Internal signals.
   wire                 reset_n = KEY[0]; /* reset_n is active low. */
   wire [23:0]          data; /* Data to output to both channels of the audio DAC. */
   wire [0:119]         config_data; /* Data that configures the operation of the audio DAC. */
   wire                 daclrck; /* Sampling frequency of the DAC. All combinational logic must be
                                  completed in one clock cycle. */
   wire                 configured; /* Pulled high by I2C when configuration is complete. */
   wire                 i2c_clk;

   assign config_data = {8'b0011_0100, 8'b0000_1010, 8'b0000_0110,   // 48kHz sampling frequency.
                         8'b0011_0100, 8'b0000_1000, 8'b0001_0000,   // DAC for line out.
                         8'b0011_0100, 8'b0000_0101, 8'b0101_1001,   // Sound volume.
                         8'b0011_0100, 8'b0000_1110, 8'b0000_1010,   // Data transfer interface.
                         8'b0011_0100, 8'b0001_0000, 8'b0000_0000};  // DAC sampling rate.

   // Assign outputs.
   assign AUD_DACLRCK = daclrck;

   /* Generate start signal
    *
    * This triggers I2C configuration. It also clears the configured flag.
    */
   reg                  start=1; /* High signal triggers audio DAC configuration to start. */
   reg                  start_bool=1;
   reg [1:0]            start_count=0;
   always @(negedge i2c_clk) begin
      if (!reset_n) begin
         start <= 1;
         start_bool <= 1;
         start_count <= 0;
      end
      else begin
         if (start_bool && start_count<3) begin
            start <= 1;
            start_bool <= 1;
            start_count <= start_count + 1;
         end
         else if (start_bool) begin
            start <= 1;
            start_bool <= 0;
            start_count <= 0;
         end
         else begin
            start <= 0;
            start_bool <= 0;
            start_count <= 0;
         end
      end // else: !if(!reset_n)
   end

   // Computation module instantiation.
   comp comp_inst (
                   .clk_fast(CLOCK_50),
                   .clk_sample(daclrck),
                   .configured(configured),
                   .data(data)
                   );

   // I2C instantiation.
   i2c i2c_inst (
                 .clk_50(CLOCK_50),
                 .start(start),
                 .data(config_data),
                 .reset_n(reset_n),
                 .sda(FPGA_I2C_SDAT),
                 .scl(FPGA_I2C_SCLK),
                 .configured(configured),
                 .i2c_sclk(i2c_clk)
                 );

   // I2S instantiation.
   i2s i2s_inst (
                 .clk_50(CLOCK_50),
                 .mclk(AUD_XCK),
                 .bclk(AUD_BCLK),
                 .daclrck(daclrck),
                 .data(data),
                 .dacdat(AUD_DACDAT),
                 .configured(configured),
                 .reset(reset_n)
                 );

   // HEX debug
   HexDigit hex0(HEX0, start);
   HexDigit hex1(HEX1, KEY[0]);
   HexDigit hex2(HEX2, start_bool);
   HexDigit hex3(HEX3, configured);
   // HexDigit hex4(HEX4, data[4]);
   // HexDigit hex5(HEX5, data[5]);

endmodule // top
