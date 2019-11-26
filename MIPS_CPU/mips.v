`include "simparams.vh"

//--------------------------------------------------------------
// mips.v
// David_Harris@hmc.edu and Sarah_Harris@hmc.edu 23 October 2005
// Single-cycle MIPS processor
//--------------------------------------------------------------

// Pipelined MIPS processor
module mips(input         clk, reset,
            output [31:0] pc,
            input [31:0]  instr,
            output        memwrite,
            output [31:0] memaddr,
            output [31:0] memwritedata,
            input [31:0]  memreaddata);

   wire [31:0]            pcplus4;
   wire                   pcsrc;
   wire [31:0]            pcnext;
   // pc omitted

   pipeline_if ifstage(.clk(clk),
                       .reset(reset),
                       .pcsrc(pcsrc),
                       .hazard(1'b0),
                       .branchaddr(pcnext),
                       .pcplus4(pcplus4),
                       .pc(pc));

   // Signal to EX
   wire                   shiftl16;
   wire                   jumptoreg;
   wire                   jump;
   wire                   alusrc;
   wire                   nez;
   wire                   regdst;
   wire                   link;
   wire [31:0]            regdataa;
   wire [31:0]            regdatab;
   wire [31:0]            signimm;
   wire [5:0]             funct;
   wire [4:0]             rt;
   wire [4:0]             rd;
   wire [1:0]             aluop;

   // Signal to MEM
   wire                   branch;
   // memwrite omitted;

   // Signal to WB
   wire                   memtoreg;
   wire                   regwrite;

   // tmp
   wire [31:0]            regwritedata;
   wire [4:0]             writereg;
   wire                   writeen;

   pipeline_id idstage(.clk(clk),
                       .pc(pc),
                       .instr(instr),
                       .writeen(writeen),
                       .writedata(regwritedata),
                       .writereg(writereg),
                       .shiftl16(shiftl16),
                       .jumptoreg(jumptoreg),
                       .jump(jump),
                       .alusrc(alusrc),
                       .nez(nez),
                       .regdst(regdst),
                       .link(link),
                       .regdataa(regdataa),
                       .regdatab(regdatab),
                       .regwrite(writeen), // todo: wire it to WB
                       .memtoreg(memtoreg),
                       .signimm(signimm),
                       .funct(funct),
                       .rt(rt),
                       .rd(rd),
                       .aluop(aluop),
                       .memwrite(memwrite),
                       .branch(branch));

   wire                   zero;
   //wire [31:0]            pcnext;

   // TO WB
   wire [31:0]            aluout;

   // TO ID through WB
   //wire [4:0]             writereg;

   pipeline_ex exstage(.shiftl16(shiftl16),
                       .jumptoreg(jumptoreg),
                       .jump(jump),
                       .alusrc(alusrc),
                       .nez(nez),
                       .regdst(regdst),
                       .link(link),
                       .regdataa(regdataa),
                       .regdatab(regdatab),
                       .instr(instr),
                       .pcplus4(pcplus4),
                       .signimm(signimm),
                       .funct(funct),
                       .rt(rt),
                       .rd(rd),
                       .pcnext(pcnext),
                       .aluop(aluop),
                       .zero(zero),
                       .aluout(aluout),
                       .writereg(writereg),
                       .memwritedata(memwritedata));

   assign memaddr = aluout;

   //wire                   pcsrc;
   // readdata omitted

   pipeline_mem memstage(.branch(branch),
                         .jump(jump),
                         .jumptoreg(jumptoreg),
                         .zero(zero),
                         .pcsrc(pcsrc));

   pipeline_wb wbstage(.memtoreg(memtoreg),
                       .link(link),
                       .aluout(aluout),
                       .readdata(memreaddata),
                       .pcplus4(pcplus4),
                       .result(regwritedata));

endmodule // mips

// single-cycle MIPS processor
//module mips(input         clk, reset,
//            output [31:0] pc,
//            input  [31:0] instr,
//            output        memwrite,
//            output [31:0] memaddr,
//            output [31:0] memwritedata,
//            input  [31:0] memreaddata);
//
//  wire        signext, shiftl16, memtoreg, branch;
//  wire        pcsrc, zero;
//  wire        alusrc, regdst, regwrite, nez, jump, link, jumptoreg;
//  wire [2:0]  alucontrol;
//
//  // Instantiate Controller
//  controller c(
//    .op         (instr[31:26]),
//		.funct      (instr[5:0]),
//		.signext    (signext),
//		.shiftl16   (shiftl16),
//		.memtoreg   (memtoreg),
//		.memwrite   (memwrite),
//    .branch     (branch),
//		.alusrc     (alusrc),
//		.regdst     (regdst),
//		.regwrite   (regwrite),
//		.jump       (jump),
//    .nez        (nez),
//    .link       (link),
//    .jumptoreg  (jumptoreg),
//		.alucontrol (alucontrol));
//
//   assign pcsrc = branch & zero;
//
//  // Instantiate Datapath
//  datapath dp(
//    .clk        (clk),
//    .reset      (reset),
//    .signext    (signext),
//    .shiftl16   (shiftl16),
//    .memtoreg   (memtoreg),
//    .pcsrc      (pcsrc),
//    .alusrc     (alusrc),
//    .regdst     (regdst),
//    .regwrite   (regwrite),
//    .jump       (jump),
//    .nez        (nez),
//    .link       (link),
//    .jumptoreg  (jumptoreg),
//    .alucontrol (alucontrol),
//    .zero       (zero),
//    .pc         (pc),
//    .instr      (instr),
//    .aluout     (memaddr),
//    .writedata  (memwritedata),
//    .readdata   (memreaddata));
//
//endmodule

module datapath(input         clk, reset,
                input         signext,
                input         shiftl16,
                input         memtoreg, pcsrc,
                input         alusrc, regdst,
                input         regwrite, jump,
                input         nez,
                input         link,
                input         jumptoreg,
                input [2:0]   alucontrol,
                output        zero,
                output [31:0] pc,
                input [31:0]  instr,
                output [31:0] aluout, writedata,
                input [31:0]  readdata);

  wire [4:0]  writereg;
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  wire [31:0] signimm, signimmsh, shiftedimm;
  wire [31:0] srca, srcb;
  wire [31:0] aluordata;
  wire [31:0] result;
  wire [31:0] jraddr;
  wire        shift;

  // next PC logic
   // IF stage
  flopr #(32) pcreg(
    .clk   (clk),
    .reset (reset),
    .d     (pcnext),
    .q     (pc));

   // IF stage
  adder pcadd1(
    .a (pc),
    .b (32'b100),
    .y (pcplus4));

   // EX stage
  sl2 immsh(
    .a (signimm),
    .y (signimmsh));

   //EX stage
  adder pcadd2(
    .a (pcplus4),
    .b (signimmsh),
    .y (pcbranch));

   // IF stage
  mux2 #(32) pcbrmux(
    .d0  (pcplus4),
    .d1  (pcbranch),
    .s   (pcsrc),
    .y   (pcnextbr));

   // EX stage
  mux2 #(32) jrmux(
    .d0  (pcnextbr),
    .d1  (srca),
    .s   (jumptoreg),
    .y   (jraddr));

   // EX stage
  mux2 #(32) pcmux(
    .d0   (jraddr),
    .d1   ({pcplus4[31:28], instr[25:0], 2'b00}),
    .s    (jump),
    .y    (pcnext));

  // register file logic
   // ID stage
  regfile rf(
    .clk     (clk),
    .we      (regwrite),
    .ra1     (instr[25:21]),
    .ra2     (instr[20:16]),
    .wa      (link ? 5'd31 : writereg),
    .wd      (result),
    .rd1     (srca),
    .rd2     (writedata));

   // EX stage
  mux2 #(5) wrmux(
    .d0  (instr[20:16]),
    .d1  (instr[15:11]),
    .s   (regdst),
    .y   (writereg));

  mux2 #(32) resmux(
    .d0 (aluout),
    .d1 (readdata),
    .s  (memtoreg),
    .y  (aluordata));

   mux2 #(32) linkmux(
    .d0 (aluordata),
    .d1 (pcplus4),
    .s  (link),
    .y  (result));

   // ID stage
  sign_zero_ext sze(
    .a       (instr[15:0]),
    .signext (signext),
    .y       (signimm[31:0]));

   // EX stage
  shift_left_16 sl16(
    .a         (signimm[31:0]),
    .shiftl16  (shiftl16),
    .y         (shiftedimm[31:0]));

  // ALU logic
   // EX stage
  mux2 #(32) srcbmux(
    .d0 (writedata),
    .d1 (shiftedimm[31:0]),
    .s  (alusrc),
    .y  (srcb));

   // EX stage
  alu alu(
    .a       (srca),
    .b       (srcb),
    .alucont (alucontrol),
    .result  (aluout),
    .nez     (nez),
    .zero    (zero));

endmodule
