`include "simparams.vh"

module pipe_mem2wb(input clk, reset,
                   input         mem_memtoreg,
                   input         mem_link,
                   input         mem_regwriteen,
                   input [4:0]   mem_writereg,
                   input [31:0]  mem_aluout,
                   input [31:0]  mem_memreaddata,
                   input [31:0]  mem_pcplus4,
                   output        wb_memtoreg,
                   output        wb_link,
                   output        wb_regwriteen,
                   output [4:0]  wb_writereg,
                   output [31:0] wb_aluout,
                   output [31:0] wb_memreaddata,
                   output [31:0] wb_pcplus4);

   assign wb_memtoreg = mem_memtoreg;
   assign wb_link = mem_link;
   assign wb_writereg = mem_writereg;
   assign wb_regwriteen = mem_regwriteen;
   assign wb_aluout = mem_aluout;
   assign wb_memreaddata = mem_memreaddata;
   assign wb_pcplus4 = mem_pcplus4;

endmodule // pipe_mem2wb

