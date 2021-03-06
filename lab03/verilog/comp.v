/* comp.v
 *
 * Performs the combinational logic to determine the data to be sent to the DAC.
 */

module comp (
             // Clocks
             input             clk_fast, /* Fast clock to perform serial computations. */
             input             clk_sample, /* Slow clock at which data is sampled. Everything must
                                        be completed in one cycle of this clock. */
             input             configured,
             // Data
             output reg [23:0] data /* Data to drive the audio DAC. */
             );

   reg [23:0]                  data_ [0:99];
   initial begin
      $readmemb("../cpp/sin.mem", data_);
   end

   integer                 count = 0;

   always @(posedge clk_sample && configured) begin
      if (count==99) begin
         count <= 0;
      end
      else begin
         count <= count + 1;
      end
      data <= data_[count];
   end

endmodule // comp
