`include "simparams.vh"

module pipe_id2ex(input clk, reset,
                  input [31:0]  id_instr,
                  input [31:0]  id_pcplus4,
                  input         id_shiftl16,
                  input         id_jumptoreg,
                  input         id_jump,
                  input         id_alusrc,
                  input         id_nez,
                  input         id_regdst,
                  input         id_link,
                  input [31:0]  id_regdataa,
                  input [31:0]  id_regdatab,
                  input [31:0]  id_signimm,
                  input [5:0]   id_funct,
                  input [4:0]   id_rt,
                  input [4:0]   id_rd,
                  input [1:0]   id_aluop,
                  input         id_branch,
                  input         id_memtoreg,
                  input         id_regwriteen,
                  input         id_memwrite,
                  output [31:0] ex_instr,
                  output [31:0] ex_pcplus4,
                  output        ex_shiftl16,
                  output        ex_jumptoreg,
                  output        ex_jump,
                  output        ex_alusrc,
                  output        ex_nez,
                  output        ex_regdst,
                  output        ex_link,
                  output [31:0] ex_regdataa,
                  output [31:0] ex_regdatab,
                  output [31:0] ex_signimm,
                  output [5:0]  ex_funct,
                  output [4:0]  ex_rt,
                  output [4:0]  ex_rd,
                  output [1:0]  ex_aluop,
                  output        ex_branch,
                  output        ex_memtoreg,
                  output        ex_regwriteen,
                  output        ex_memwrite);

   assign ex_instr = id_instr;
   assign ex_pcplus4 = id_pcplus4;
   assign ex_shiftl16 = id_shiftl16;
   assign ex_jumptoreg = id_jumptoreg;
   assign ex_jump = id_jump;
   assign ex_alusrc = id_alusrc;
   assign ex_nez = id_nez;
   assign ex_regdst = id_regdst;
   assign ex_link = id_link;
   assign ex_regdataa = id_regdataa;
   assign ex_regdatab = id_regdatab;
   assign ex_signimm = id_signimm;
   assign ex_funct = id_funct;
   assign ex_rt = id_rt;
   assign ex_rd = id_rd;
   assign ex_aluop = id_aluop;
   assign ex_branch = id_branch;
   assign ex_memtoreg = id_memtoreg;
   assign ex_regwriteen = id_regwriteen;
   assign ex_memwrite = id_memwrite;
endmodule // pipe_id2ex

