`include "simparams.vh"

module pipe_id2ex(input clk, reset,
                  input         hazard,
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

   reg [31:0]                   ex_instr;
   reg [31:0]                   ex_pcplus4;
   reg                          ex_shiftl16;
   reg                          ex_jumptoreg;
   reg                          ex_jump;
   reg                          ex_alusrc;
   reg                          ex_nez;
   reg                          ex_regdst;
   reg                          ex_link;
   reg [31:0]                   ex_regdataa;
   reg [31:0]                   ex_regdatab;
   reg [31:0]                   ex_signimm;
   reg [5:0]                    ex_funct;
   reg [4:0]                    ex_rt;
   reg [4:0]                    ex_rd;
   reg [1:0]                    ex_aluop;
   reg                          ex_branch;
   reg                          ex_memtoreg;
   reg                          ex_regwriteen;
   reg                          ex_memwrite;


   always @(posedge clk, posedge reset)
     begin
        if (reset)
          begin
             ex_instr <= 0;
             ex_pcplus4 <= 0;
             ex_shiftl16 <= 0;
             ex_jumptoreg <= 0;
             ex_jump <= 0;
             ex_alusrc <= 0;
             ex_nez <= 0;
             ex_regdst <= 0;
             ex_link <= 0;
             ex_regdataa <= 0;
             ex_regdatab <= 0;
             ex_signimm <= 0;
             ex_funct <= 0;
             ex_rt <= 0;
             ex_rd <= 0;
             ex_aluop <= 0;
             ex_branch <= 0;
             ex_memtoreg <= 0;
             ex_regwriteen <= 0;
             ex_memwrite <= 0;
          end
        else
          begin
             ex_pcplus4 <= id_pcplus4;
             if (hazard && (!id_link))
               begin
                  ex_instr <= 0;
                  ex_shiftl16 <= 0;
                  ex_jumptoreg <= 0;
                  ex_jump <= 0;
                  ex_alusrc <= 0;
                  ex_nez <= 0;
                  ex_regdst <= 0;
                  ex_link <= 0;
                  ex_regdataa <= 0;
                  ex_regdatab <= 0;
                  ex_signimm <= 0;
                  ex_funct <= 0;
                  ex_rt <= 0;
                  ex_rd <= 0;
                  ex_aluop <= 0;
                  ex_branch <= 0;
                  ex_memtoreg <= 0;
                  ex_regwriteen <= 0;
                  ex_memwrite <= 0;
               end
             else
               begin
                  ex_instr <= id_instr;
                  ex_shiftl16 <= id_shiftl16;
                  ex_jumptoreg <= id_jumptoreg;
                  ex_jump <= id_jump;
                  ex_alusrc <= id_alusrc;
                  ex_nez <= id_nez;
                  ex_regdst <= id_regdst;
                  ex_link <= id_link;
                  ex_regdataa <= id_regdataa;
                  ex_regdatab <= id_regdatab;
                  ex_signimm <= id_signimm;
                  ex_funct <= id_funct;
                  ex_rt <= id_rt;
                  ex_rd <= id_rd;
                  ex_aluop <= id_aluop;
                  ex_branch <= id_branch;
                  ex_memtoreg <= id_memtoreg;
                  ex_regwriteen <= id_regwriteen;
                  ex_memwrite <= id_memwrite;
               end
          end
     end
endmodule // pipe_id2ex

