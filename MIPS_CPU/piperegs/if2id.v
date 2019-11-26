`include "simparams.vh"

module pipe_if2id(input clk, reset,
             input         flush,
             input [31:0]  if_pcplus4,
             input [31:0]  if_instr,
             output [31:0] id_pcplus4,
             output [31:0] id_instr);

   reg [31:0]              pcplus4;
   reg [31:0]              instr;

   // Dummy if2id
   assign id_pcplus4 = if_pcplus4;
   assign id_instr = if_instr;

endmodule // pipe_if2id
