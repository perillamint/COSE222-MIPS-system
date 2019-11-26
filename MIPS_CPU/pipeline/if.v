`include "simparams.vh"

// Pipeline instruction fetch stage

module pipeline_if(input         clk, reset,
                   input         pcsrc, // To branch or to not branch that is the question.
                   input         hazard,
                   input [31:0]  branchaddr,
                   output [31:0] pcplus4,
                   output [31:0] pc);

   wire [31:0]                   pcnext;

   flopr #(32) pcreg(.clk   (clk),
                     .reset (reset),
                     .d     (pcnext),
                     .q     (pc));

   adder pcadd1(.a (pc),
                .b (32'b100),
                .y (pcplus4));

   mux2 #(32) pcsrcmux(.d0  (pcplus4),
                       .d1  (branchaddr),
                       .s   (pcsrc),
                       .y   (pcnext));
endmodule // pipeline_if
