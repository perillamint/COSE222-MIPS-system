`include "simparams.vh"

module controller(input [5:0]  op, funct,
                  input [31:0] instr,
                  output       signext,
                  output       shiftl16,
                  output       memtoreg, memwrite,
                  output       alusrc,
                  output       regdst, regwrite,
                  output       jump,
                  output       nez,
                  output       link,
                  output       branch,
                  output       jumptoreg,
                  output [2:0] alucontrol);

  wire [1:0] aluop;

   maindec md(
              .op       (op),
              .funct    (funct),
              .instr    (instr),
              .signext  (signext),
              .shiftl16 (shiftl16),
              .memtoreg (memtoreg),
              .memwrite (memwrite),
              .branch   (branch),
              .alusrc   (alusrc),
              .regdst   (regdst),
              .regwrite (regwrite),
              .jump     (jump),
              .link     (link),
              .nez      (nez),
              .jumptoreg(jumptoreg),
              .aluop    (aluop));

  aludec ad(
    .funct      (funct),
    .aluop      (aluop),
    .alucontrol (alucontrol));

endmodule
