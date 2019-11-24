`include "simparams.vh"

// Pipeline instruction fetch stage

module pipeline_if(input clk, reset,
                   input         pcsrc, // To branch or to not branch that is the question.
                   input         hazard,
                   input  [31:0] offset,
                   output [31:0] pc);

   wire [31:0]                   pcnext;
   wire [31:0]           srca, srcb;
   wire [31:0]           jraddr;

   // next PC logic
   flopr #(32) pcreg(.clk   (clk),
                     .reset (reset),
                     .d     (pcnext),
                     .q     (pc));

   mux2 #(32) pcnextmux(.d0  (32'b100),
                        .d1  (offset),
                        .s   (pcsrc),
                        .y   (pcnextoff));

   mux2 #(32) pchazardmux(.d0  (nextoff),
                          .d1  (32'b0),
                          .s   (hazard),
                          .y   (pcadd));

   adder pcadd1(.a (pc),
                .b (pcadd),
                .y (pcnext));
endmodule // pipeline_if
