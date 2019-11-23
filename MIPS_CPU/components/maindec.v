`include "simparams.vh"

module maindec(input  [5:0] op,
               input [5:0]  funct,
               output       signext,
               output       shiftl16,
               output       memtoreg, memwrite,
               output       branch, alusrc,
               output       regdst, regwrite,
               output       jump,
               output       jumptoreg,
               output       link,
               output       nez,
               output [1:0] aluop);

  reg [13:0] controls;

  assign {signext, shiftl16, regwrite, regdst, alusrc, branch, memwrite,
          memtoreg, jump, link, jumptoreg, nez, aluop} = controls;

  always @(*)
    case(op)
      6'b000000:
        begin
           case (funct)
             6'b001000: controls <= #`mydelay 14'b00000000001000; // JR
             default:   controls <= #`mydelay 14'b00110000000011; // Rtype
           endcase // case (funct)
        end
      6'b100011: controls <= #`mydelay 14'b10101001000000; // LW
      6'b101011: controls <= #`mydelay 14'b10001010000000; // SW
      6'b000100: controls <= #`mydelay 14'b10000100000001; // BEQ
      6'b000101: controls <= #`mydelay 14'b10000100000101; // BNE
      6'b001000,
      6'b001001: controls <= #`mydelay 14'b10101000000000; // ADDI, ADDIU: only difference is exception
      6'b001010,
      //6'b001011: controls <= #`mydelay 14'b10110000000000; // SLTI, SLTIU
      6'b001101: controls <= #`mydelay 14'b00101000000010; // ORI
      6'b001111: controls <= #`mydelay 14'b01101000000000; // LUI
      6'b000010: controls <= #`mydelay 14'b00000000100000; // J
      6'b000011: controls <= #`mydelay 14'b00100000110000; // JAL
      default:   controls <= #`mydelay 14'bxxxxxxxxxxxxxx; // ???
    endcase

endmodule
