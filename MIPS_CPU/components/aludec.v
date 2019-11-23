`include "simparams.vh"

module aludec(input      [5:0] funct,
              input [1:0]      aluop,
              output reg [2:0] alucontrol);

   always @(*)
     case(aluop)
       2'b00: alucontrol <= #`mydelay 3'b010;  // add
       2'b01: alucontrol <= #`mydelay 3'b110;  // sub
       2'b10: alucontrol <= #`mydelay 3'b001;  // or
       default: case(funct)          // RTYPE
                  6'b100000,
                  6'b100001: alucontrol <= #`mydelay 3'b010; // ADD, ADDU: only difference is exception
                  6'b100010,
                    6'b100011: alucontrol <= #`mydelay 3'b110; // SUB, SUBU: only difference is exception
                  6'b100100: alucontrol <= #`mydelay 3'b000; // AND
                  6'b100101: alucontrol <= #`mydelay 3'b001; // OR
                  6'b101010,
                    6'b101011: alucontrol <= #`mydelay 3'b111; // SLT, SLTU
                  default:   alucontrol <= #`mydelay 3'bxxx; // ???
                endcase
     endcase
endmodule
