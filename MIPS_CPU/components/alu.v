`include "simparams.vh"

//------------------------------------------------
// ALU from mipsparts.v
// David_Harris@hmc.edu 23 October 2005
// Components used in MIPS processor
//------------------------------------------------

module alu(input      [31:0] a, b,
           input [2:0]       alucont,
           input             nez,
           output reg [31:0] result,
           output            zero);

  wire [31:0] b2, sum, slt, sltu;
  wire        N, Z, C, V;

  assign b2 = alucont[2] ? ~b:b;

  adder_32bit iadder32 (.a   (a),
			     				.b   (b2),
								.cin (alucont[2]),
								.sum (sum),
								.N   (N),
								.Z   (Z),
								.C   (C),
								.V   (V));

  // signed less than ("N set and V clear" OR "N clear and V set")
  assign slt  = N ^ V ;

  // unsigned lower (C clear)
  assign sltu = ~C ;

  always@(*)
    case(alucont[1:0])
      2'b00: result <= #`mydelay a & b;
      2'b01: result <= #`mydelay a | b;
      2'b10: result <= #`mydelay sum;
      2'b11: result <= #`mydelay slt;
    endcase

  assign #`mydelay zero = nez ? (result != 32'b0) : (result == 32'b0);

endmodule
