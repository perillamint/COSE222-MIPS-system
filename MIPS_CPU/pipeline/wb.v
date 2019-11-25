`include "simparams.vh"

// Pipeline writeback stage

module pipeline_wb(input clk, reset,
                   input         memtoreg,
                   input         link,
                   input [31:0]  aluout,
                   input [31:0]  readdata,
                   input [31:0]  pcplus4,
                   output [31:0] result);

   wire [31:0]                  aluordata;

   mux2 #(32) resmux(.d0 (aluout),
                     .d1 (readdata),
                     .s  (memtoreg),
                     .y  (aluordata));

   mux2 #(32) linkmux(
                      .d0 (aluordata),
                      .d1 (pcplus4),
                      .s  (link),
                      .y  (result));
endmodule // pipeline_wb
