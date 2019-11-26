`include "simparams.vh"

module pipe_ex2mem(input clk, reset,
                   input         ex_branch,
                   input         ex_jump,
                   input         ex_jumptoreg,
                   input         ex_zero,
                   input         ex_link,
                   input         ex_memwrite,
                   input         ex_memtoreg,
                   input         ex_regwriteen,
                   input [31:0]  ex_aluout,
                   input [31:0]  ex_memwritedata,
                   input [4:0]   ex_writereg,
                   input [31:0]  ex_pcplus4,
                   input [31:0]  ex_pcnext,
                   output        mem_branch,
                   output        mem_jump,
                   output        mem_jumptoreg,
                   output        mem_zero,
                   output        mem_link,
                   output        mem_memwrite,
                   output        mem_memtoreg,
                   output        mem_regwriteen,
                   output [31:0] mem_aluout,
                   output [31:0] mem_memwritedata,
                   output [4:0]  mem_writereg,
                   output [31:0] mem_pcplus4,
                   output [31:0] mem_pcnext);

   assign mem_branch = ex_branch;
   assign mem_jump = ex_jump;
   assign mem_jumptoreg = ex_jumptoreg;
   assign mem_zero = ex_zero;
   assign mem_link = ex_link;
   assign mem_memwrite = ex_memwrite;
   assign mem_memtoreg = ex_memtoreg;
   assign mem_regwriteen = ex_regwriteen;
   assign mem_aluout = ex_aluout;
   assign mem_memwritedata = ex_memwritedata;
   assign mem_writereg = ex_writereg;
   assign mem_pcplus4 = ex_pcplus4;
   assign mem_pcnext = ex_pcnext;

endmodule // pipe_ex2mem
