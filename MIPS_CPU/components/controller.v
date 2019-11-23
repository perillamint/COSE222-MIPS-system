`include "simparams.vh"

module controller(input  [5:0] op, funct,
                  input        zero,
                  output       signext,
                  output       shiftl16,
                  output       memtoreg, memwrite,
                  output       pcsrc, alusrc,
                  output       regdst, regwrite,
                  output       jump,
                  output       nez,
                  output       link,
                  output       jumptoreg,
                  output [2:0] alucontrol);

  wire [1:0] aluop;
  wire       branch;

  maindec md(
    .op       (op),
    .funct    (funct),
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

  assign pcsrc = branch & zero;

endmodule
