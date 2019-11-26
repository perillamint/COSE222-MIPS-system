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
