/* Signed multiplier for 2s complement in 2.16 format.
 * 
 */
 
module signed_mult (
	output	signed	[17:0]	out	,	/* might be an  error to make this signed */
	input	signed	[17:0]	a	,
	input	signed	[17:0]	b
);
	
wire	signed	[35:0]	mult_out;

assign	mult_out = a * b;
assign	out = {mult_out[35], mult_out[32:16]};	/* bit 35 gives the sign bit. Then we want
						 * to take bits  that give us the 1s place and
						 * the most significant 16 bits after that.
						 * If this is confusing, think how the decimal
						 * moves in binary multiplication. */

endmodule
