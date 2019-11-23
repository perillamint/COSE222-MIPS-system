`include "simparams.vh"

//------------------------------------------------
// shifters from mipsparts.v
// David_Harris@hmc.edu 23 October 2005
// Components used in MIPS processor
//------------------------------------------------


module sl2(input  [31:0] a,
           output [31:0] y);

   // shift left by 2
   assign #`mydelay y = {a[29:0], 2'b00};
endmodule

module shift_left_16(input      [31:0] a,
		                 input             shiftl16,
                     output reg [31:0] y);

   always @(*)
	   begin
	      if (shiftl16) y = {a[15:0],16'b0};
	      else          y = a[31:0];
	   end

endmodule
