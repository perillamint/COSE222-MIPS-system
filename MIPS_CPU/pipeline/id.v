`include "simparams.vh"

// Instruction decoding

module pipeline_id(input         clk,
                   input         writeen, // Signal from WB
                   input [31:0]  writedata, // Signal from WB
                   input [4:0]   writereg, // Signal from WB
                   input [31:0]  pc,
                   input [31:0]  instr,
                   output        regwrite, // Signal to WB
                   output        memtoreg, // Signal to WB
                   output        memwrite, // Signalt to MEM
                   output        branch, // Signal to MEM
                   output        alusrc, // Signal to EX
                   output        regdst, // Signal to EX
                   output        jump, // Signal to EX
                   output        link, // Signal to EX
                   output        nez, // Signal to EX
                   output        jumptoreg, // Signal to EX
                   output        shiftl16, // Signal to EX
                   output [5:0]  funct, // Signal to EX
                   output [4:0]  rt,
                   output [4:0]  rd,
                   output [1:0]  aluop,
                   output [31:0] signimm,
                   output [31:0] regdataa,
                   output [31:0] regdatab,
                   output [2:0]  alucontrol);

   wire                          signext;
   wire [5:0]                    op;
   wire [4:0]                    rs, rt, rd;

   assign op = instr[31:26];
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign rd = instr[15:11];
   assign funct = instr[5:0];

   // Big cthulu here.
   maindec md(.op       (op),
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

   regfile rf(.clk     (clk),
              .we      (writeen),
              .wa      (writereg),
              .wd      (writedata),
              .ra1     (rs),
              .ra2     (rt),
              .rd1     (regdataa),
              .rd2     (regdatab));

   sign_zero_ext sze(.a       (instr[15:0]),
                     .signext (signext),
                     .y       (signimm[31:0]));
endmodule // pipeline_id
