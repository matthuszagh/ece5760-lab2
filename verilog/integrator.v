/* Performs a basic Euler numerical integration.
 *
 * x(n+1) = x(n) + dt*(dx(n)/dt)
 */

module integrator (
	output	signed	[17:0]	xnew	,
	input			reset	,
	input			clock	,
	input		[3:0]	dt	,	/* this is in units of shift right. We only
						 * need to shift right 9 bits typically so
						 * 2^4 = 16 is plenty, but 2^3 = 8 is insufficient */
	input	signed	[17:0]	x	,
	input	signed	[17:0]	func		/* dx(n)/dt 
						 * func>>>dt = dt*func = dt*(dx(n)/dt) since
						 * we set dt to the number of shift rights (i.e. 9) */
);


//=======================================================
//  Internals
//=======================================================
//reg	signed	[17:0]	xreg_				;
//wire	signed	[17:0]	xnew_ = xreg_ + (func>>>dt)	;
//reg			start_ = 1			;

assign xnew = x + (func>>>dt);

//=======================================================
//  Behavioral Modelling
//=======================================================
/*always @ (posedge clock)
begin
	/*if (reset/* | (start_ && x)''') begin
		start_ <= 0	;
		xreg_ <= x	;
	end
	else begin
		xreg_ <= xnew_;
	end*/
//	xreg_ = x + (func>>>dt);
//end

//assign xnew = xreg_;
		

endmodule
