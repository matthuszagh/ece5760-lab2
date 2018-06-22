/* comp.v
 *
 * Performs the combinational logic to determine the data to be sent to the DAC.
 */

module comp (
             // Clocks
             input         clk_fast, /* Fast clock to perform serial computations. */
             input         clk_sample, /* Slow clock at which data is sampled. Everything must
                                        be completed in one cycle of this clock. */
             // Data
             output [23:0] data /* Data to drive the audio DAC. */
             );

   reg [23:0]              data_;


endmodule // comp
