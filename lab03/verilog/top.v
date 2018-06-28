/* top.v
 *
 * Instantiates the other submodules and controls their operation.
 */

module top (
            // Clocks
            input  CLOCK_50, /* 50MHz reference clock. */
            // I2C Interface
            output FPGA_I2C_SCLK, /* Serial clock for I2C. */
            inout  FPGA_I2C_SDAT, /* Serial data line for I2C. It must be bidirectional to receive
                                   ACK/NACK signal from the audio codec. */
            // I2S Interface
            output AUD_XCK, /* Master 12.288MHz clock to drive the MCLK pin of the audio codec. */
            output AUD_BCLK, /* 2.592MHz bit clock to synchronize the data transfer. */
            output AUD_DACLRCK, /* 48kHz clock that synchronizes a full sample of data. */
            output AUD_DACDAT /* Serialized data to drive the DAC at the bit clock. */
            );

   // Internal signals.
   reg             reset=1; /* Reset is active low. */
   wire [23:0]     data; /* Data to output to both channels of the audio DAC. */
   wire [0:87]     config_data; /* Data that configures the operation of the audio DAC. */
   wire            daclrck; /* Sampling frequency of the DAC. All combinational logic must be
                             completed in one clock cycle. */
   reg             start=0; /* High signal triggers audio DAC configuration to start. */
   wire            configured; /* Pulled high by I2C when configuration is complete. */

   assign config_data = {8'b0011_0100,                 // Address frame.
                         8'b0000_1010, 8'b0000_0110,   // 48kHz sampling frequency.
                         8'b0000_1000, 8'b0001_0000,   // DAC for line out.
                         8'b0000_0101, 8'b0111_1001,   // Sound volume.
                         8'b0000_1110, 8'b0000_1010,   // Data transfer interface.
                         8'b0001_0000, 8'b0000_0000};  // DAC sampling rate.

   // Assign outputs.
   assign AUD_DACLRCK = daclrck;

   // Computation module instantiation.
   comp comp_inst (
                   .clk_fast(CLOCK_50),
                   .clk_sample(daclrck),
                   .data(data)
                   );

   // I2C instantiation.
   i2c i2c_inst (
                 .clk_50(CLOCK_50),
                 .start(start),
                 .data(config_data),
                 .sda(FPGA_I2C_SDAT),
                 .scl(FPGA_I2C_SCLK),
                 .configured(configured)
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
                 .reset(reset)
                 );
endmodule // top
