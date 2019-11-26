`include "simparams.vh"

// Pipeline execution stage

module pipeline_ex(input         shiftl16,
                   input         jumptoreg,
                   input         jump,
                   input         alusrc,
                   input         nez,
                   input         regdst,
                   input         link,
                   input [31:0]  regdataa,
                   input [31:0]  regdatab,
                   input [31:0]  instr,
                   input [31:0]  pcplus4,
                   input [31:0]  signimm,
                   input [5:0]   funct,
                   input [4:0]   rt,
                   input [4:0]   rd,
                   input [1:0]   aluop,
                   output        zero,
                   output [4:0]  writereg,
                   output [31:0] pcnext, // Go back to IF
                   output [31:0] aluout,
                   output [31:0] memwritedata);

   wire [31:0]                   signimmsh, shiftedimm;
   wire [31:0]                   pcnext, pcbranch, jraddr;
   wire [31:0]                   srcb;
   wire [4:0]                    instrwritereg;
   wire [2:0]                    alucontrol;

   assign memwritedata = regdatab;

   shift_left_16 sl16(.a         (signimm[31:0]),
                      .shiftl16  (shiftl16),
                      .y         (shiftedimm[31:0]));

   // Jump/Branch logic
   sl2 immsh(.a (signimm),
             .y (signimmsh)); // signimm << 2

   adder pcadd2(.a (pcplus4),
                .b (signimmsh),
                .y (pcbranch));

   mux2 #(32) jrmux(.d0  (pcbranch),
                    .d1  (regdataa),
                    .s   (jumptoreg),
                    .y   (jraddr));

   mux2 #(32) pcmux(.d0   (jraddr),
                    .d1   ({pcplus4[31:28], instr[25:0], 2'b00}),
                    .s    (jump),
                    .y    (pcnext));

   // Decide register
   mux2 #(5) wrmux(.d0  (rt),
                   .d1  (rd),
                   .s   (regdst),
                   .y   (instrwritereg));

   mux2 #(5) linkdstmux(.d0 (instrwritereg),
                        .d1 (5'd31),
                        .s  (link),
                        .y  (writereg));

   // ALU stuff
   aludec ad(.funct      (funct),
             .aluop      (aluop),
             .alucontrol (alucontrol));

   mux2 #(32) srcbmux(.d0 (regdatab),
                      .d1 (shiftedimm[31:0]),
                      .s  (alusrc),
                      .y  (srcb));

   alu alu(.a       (regdataa),
           .b       (srcb),
           .alucont (alucontrol),
           .result  (aluout),
           .nez     (nez),
           .zero    (zero));
endmodule // pipeline_ex
