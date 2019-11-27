`include "simparams.vh"

//------------------------------------------------
// misc components from mipsparts.v
// David_Harris@hmc.edu 23 October 2005
// Components used in MIPS processor
//------------------------------------------------

module sign_zero_ext(input      [15:0] a,
                     input             signext,
                     output reg [31:0] y);

   always @(*)
	begin
	   if (signext)  y <= {{16{a[15]}}, a[15:0]};
	   else          y <= {16'b0, a[15:0]};
	end

endmodule

module flopr #(parameter WIDTH = 8)
              (input                  clk, reset,
               input                  enable,
               input [WIDTH-1:0]      d,
               output reg [WIDTH-1:0] q);

   always @(posedge clk, posedge reset)
     if (reset) q <= #`mydelay 0;
     else
       begin
          if (enable) q <= #`mydelay d;
       end

endmodule

module flopenr #(parameter WIDTH = 8)
                (input                  clk, reset,
                 input                  en,
                 input      [WIDTH-1:0] d,
                 output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if      (reset) q <= #`mydelay 0;
    else if (en)    q <= #`mydelay d;

endmodule

module mux2 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1,
              input              s,
              output [WIDTH-1:0] y);

  assign #`mydelay y = s ? d1 : d0;

endmodule
