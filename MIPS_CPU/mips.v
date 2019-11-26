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

   wire [31:0]            if_pcplus4;
   wire [31:0]            if_instr;
   wire                   mem_pcsrc;
   wire [31:0]            mem_pcnext;

   assign if_instr = instr;

   pipeline_if ifstage(.clk(clk),
                       .reset(reset),
                       .pcsrc(mem_pcsrc),
                       .hazard(1'b0),
                       .branchaddr(mem_pcnext),
                       .pcplus4(if_pcplus4),
                       .pc(pc));

   wire [31:0]            id_pcplus4;
   wire [31:0]            id_instr;

   pipe_if2id if2id(.clk(clk),
                    .reset(reset),
                    .flush(1'b0),
                    .if_pcplus4(if_pcplus4),
                    .if_instr(if_instr),
                    .id_pcplus4(id_pcplus4),
                    .id_instr(id_instr));

   // Signal to EX
   wire                   id_shiftl16;
   wire                   id_jumptoreg;
   wire                   id_jump;
   wire                   id_alusrc;
   wire                   id_nez;
   wire                   id_regdst;
   wire                   id_link;
   wire [31:0]            id_regdataa;
   wire [31:0]            id_regdatab;
   wire [31:0]            id_signimm;
   wire [5:0]             id_funct;
   wire [4:0]             id_rt;
   wire [4:0]             id_rd;
   wire [1:0]             id_aluop;

   // Signal to MEM
   wire                   id_branch;
   wire                   id_memwrite;

   // Signal to WB
   wire                   id_memtoreg;
   wire                   id_regwriteen;

   wire [31:0]            wb_regwritedata;
   wire [4:0]             wb_writereg;
   wire                   wb_regwriteen;

   pipeline_id idstage(.clk(clk),
                       .instr(id_instr),
                       .writeen(wb_regwriteen),
                       .writedata(wb_regwritedata),
                       .writereg(wb_writereg),
                       .shiftl16(id_shiftl16),
                       .jumptoreg(id_jumptoreg),
                       .jump(id_jump),
                       .alusrc(id_alusrc),
                       .nez(id_nez),
                       .regdst(id_regdst),
                       .link(id_link),
                       .regdataa(id_regdataa),
                       .regdatab(id_regdatab),
                       .regwrite(id_regwriteen), // todo: wire it to WB
                       .memtoreg(id_memtoreg),
                       .signimm(id_signimm),
                       .funct(id_funct),
                       .rt(id_rt),
                       .rd(id_rd),
                       .aluop(id_aluop),
                       .memwrite(id_memwrite),
                       .branch(id_branch));

   wire [31:0]            ex_instr;
   wire [31:0]            ex_pcplus4;
   wire                   ex_shiftl16;
   wire                   ex_jumptoreg;
   wire                   ex_jump;
   wire                   ex_alusrc;
   wire                   ex_nez;
   wire                   ex_regdst;
   wire                   ex_link;
   wire [31:0]            ex_regdataa;
   wire [31:0]            ex_regdatab;
   wire [31:0]            ex_signimm;
   wire [5:0]             ex_funct;
   wire [4:0]             ex_rt;
   wire [4:0]             ex_rd;
   wire [1:0]             ex_aluop;

   // Signal to MEM
   wire                   ex_branch;
   wire                   ex_memwrite;

   // Signal to WB
   wire                   ex_memtoreg;
   wire                   ex_regwriteen;

   pipe_id2ex id2ex(.clk(clk),
                    .reset(reset),
                    .id_instr(id_instr),
                    .id_pcplus4(id_pcplus4),
                    .id_shiftl16(id_shiftl16),
                    .id_jumptoreg(id_jumptoreg),
                    .id_jump(id_jump),
                    .id_alusrc(id_alusrc),
                    .id_nez(id_nez),
                    .id_regdst(id_regdst),
                    .id_link(id_link),
                    .id_regdataa(id_regdataa),
                    .id_regdatab(id_regdatab),
                    .id_signimm(id_signimm),
                    .id_funct(id_funct),
                    .id_rt(id_rt),
                    .id_rd(id_rd),
                    .id_aluop(id_aluop),
                    .id_branch(id_branch),
                    .id_memtoreg(id_memtoreg),
                    .id_regwriteen(id_regwriteen),
                    .id_memwrite(id_memwrite),
                    .ex_instr(ex_instr),
                    .ex_pcplus4(ex_pcplus4),
                    .ex_shiftl16(ex_shiftl16),
                    .ex_jumptoreg(ex_jumptoreg),
                    .ex_jump(ex_jump),
                    .ex_alusrc(ex_alusrc),
                    .ex_nez(ex_nez),
                    .ex_regdst(ex_regdst),
                    .ex_link(ex_link),
                    .ex_regdataa(ex_regdataa),
                    .ex_regdatab(ex_regdatab),
                    .ex_signimm(ex_signimm),
                    .ex_funct(ex_funct),
                    .ex_rt(ex_rt),
                    .ex_rd(ex_rd),
                    .ex_aluop(ex_aluop),
                    .ex_branch(ex_branch),
                    .ex_memtoreg(ex_memtoreg),
                    .ex_regwriteen(ex_regwriteen),
                    .ex_memwrite(ex_memwrite));

   wire                   ex_zero;

   // TO WB
   wire [31:0]            ex_aluout;
   wire [31:0]            ex_memwritedata;
   wire [31:0]            ex_pcnext;

   // TO ID through WB
   wire [4:0]             ex_writereg;

   pipeline_ex exstage(.shiftl16(ex_shiftl16),
                       .jumptoreg(ex_jumptoreg),
                       .jump(ex_jump),
                       .alusrc(ex_alusrc),
                       .nez(ex_nez),
                       .regdst(ex_regdst),
                       .link(ex_link),
                       .regdataa(ex_regdataa),
                       .regdatab(ex_regdatab),
                       .instr(ex_instr),
                       .pcplus4(ex_pcplus4),
                       .signimm(ex_signimm),
                       .funct(ex_funct),
                       .rt(ex_rt),
                       .rd(ex_rd),
                       .pcnext(ex_pcnext),
                       .aluop(ex_aluop),
                       .zero(ex_zero),
                       .aluout(ex_aluout),
                       .writereg(ex_writereg),
                       .memwritedata(ex_memwritedata));

   wire                   mem_branch;
   wire                   mem_jump;
   wire                   mem_jumptoreg;
   wire                   mem_zero;
   wire                   mem_link;
   wire                   mem_memwrite;
   wire                   mem_memtoreg;
   wire                   mem_regwriteen;
   wire [31:0]            mem_aluout;
   wire [31:0]            mem_memwritedata;
   wire [4:0]             mem_writereg;
   wire [31:0]            mem_pcplus4;

   pipe_ex2mem ex2mem(.clk(clk),
                      .reset(reset),
                      .ex_branch(ex_branch),
                      .ex_jump(ex_jump),
                      .ex_jumptoreg(ex_jumptoreg),
                      .ex_zero(ex_zero),
                      .ex_link(ex_link),
                      .ex_memwrite(ex_memwrite),
                      .ex_memtoreg(ex_memtoreg),
                      .ex_regwriteen(ex_regwriteen),
                      .ex_aluout(ex_aluout),
                      .ex_memwritedata(ex_memwritedata),
                      .ex_writereg(ex_writereg),
                      .ex_pcplus4(ex_pcplus4),
                      .ex_pcnext(ex_pcnext),
                      .mem_branch(mem_branch),
                      .mem_jump(mem_jump),
                      .mem_jumptoreg(mem_jumptoreg),
                      .mem_zero(mem_zero),
                      .mem_link(mem_link),
                      .mem_memwrite(mem_memwrite),
                      .mem_memtoreg(mem_memtoreg),
                      .mem_regwriteen(mem_regwriteen),
                      .mem_aluout(mem_aluout),
                      .mem_memwritedata(mem_memwritedata),
                      .mem_writereg(mem_writereg),
                      .mem_pcplus4(mem_pcplus4),
                      .mem_pcnext(mem_pcnext));

   assign memaddr = mem_aluout;
   assign memwritedata = mem_memwritedata;
   assign memwrite = mem_memwrite;

   // readdata omitted

   pipeline_mem memstage(.branch(mem_branch),
                         .jump(mem_jump),
                         .jumptoreg(mem_jumptoreg),
                         .zero(mem_zero),
                         .pcsrc(mem_pcsrc));

   wire                   wb_memtoreg;
   wire                   wb_link;
   wire [31:0]            wb_aluout;
   wire [31:0]            wb_memreaddata;
   wire [31:0]            wb_pcplus4;

   pipe_mem2wb mem2wb(.clk(clk),
                      .reset(reset),
                      .mem_memtoreg(mem_memtoreg),
                      .mem_link(mem_link),
                      .mem_regwriteen(mem_regwriteen),
                      .mem_writereg(mem_writereg),
                      .mem_aluout(mem_aluout),
                      .mem_memreaddata(memreaddata), // From external port
                      .mem_pcplus4(mem_pcplus4),
                      .wb_memtoreg(wb_memtoreg),
                      .wb_link(wb_link),
                      .wb_regwriteen(wb_regwriteen),
                      .wb_writereg(wb_writereg),
                      .wb_aluout(wb_aluout),
                      .wb_memreaddata(wb_memreaddata),
                      .wb_pcplus4(wb_pcplus4));

   pipeline_wb wbstage(.memtoreg(wb_memtoreg),
                       .link(wb_link),
                       .aluout(wb_aluout),
                       .readdata(wb_memreaddata),
                       .pcplus4(wb_pcplus4),
                       .result(wb_regwritedata));

endmodule // mips
