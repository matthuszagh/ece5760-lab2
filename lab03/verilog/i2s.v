/* i2s.v
 *
 * Controls how data from the FPGA is written to the audio codec.
 *
 * The I2S module receives 24-bit data (the left and right channels will be the same, so the data
 * will simply be duplicated) from a top-level module in parallel at a frequency of 48kHz. It then
 * serializes this data and transmits it out at the requisite frequency, clocked by BCLK.
 */

module i2s (
            // Clocks
            input        clk_50, /* 50MHz reference clock. */
            output       mclk, /* Master 12.288MHz clock to drive the MCLK pin of the audio codec. */
            output       bclk, /* 2.592MHz bit clock to synchronize the data transfer. */
            output       daclrck, /* 48kHz clock that synchronizes a full sample of data. */
            // Data
            input [23:0] data, /* Parallel data from top level module to be serialized. */
            output       dacdat, /* Serialized data to drive the DAC at the bit clock. */
            // Reset
            input        reset /* Asynchronous reset from top level module. */
            );

   // Internal signals.
   wire                  mclk_;
   wire                  bclk_;
   reg                   daclrck_=1; /* Start high and pull low to signal left channel data. */
   reg [23:0]            data_;
   reg                   dacdat_;

   // Assign outputs.
   assign mclk = mclk_;
   assign bclk = bclk_;
   assign daclrck = daclrck_;
   assign dacdat = dacdat_;

   // Generate 48kHz clock.
   integer               count=0; /* 54 2.592MHz clock signals fit into 1 48kHz clock */
   always @(negedge bclk_) begin
      if (count==27) begin
         count <= 0;
         daclrck_ <= !daclrck_;
      end
      else begin
        count <= count + 1;
      end
   end

   // Generate a start condition for each sample.
   reg commence=0;
   always @(negedge daclrck_) begin
      commence <= 1;
   end

   // Serialize data to dacdat.
   integer bclk_count=0;
   always @(negedge bclk_) begin
      if (commence==1) begin
         if (bclk_count==27) begin
            bclk_count <= 0;
         end
         else if (bclk_count>=1 && bclk_count<=24) begin
            bclk_count <= bclk_count + 1;
            dacdat_ <= data_[bclk_count-1];
         end
      end
   end // always @ (negedge bclk_)


   // Instantiate the PLL.
   ip ip_pll (
              .clk_clk(clk_50),
              .pll_0_outclk12288mhz_clk(mclk_),
              .pll_0_outclk2592mhz_clk(bclk_),
              .reset_reset_n(reset)
              );
endmodule // i2s
