`include "simparams.vh"

// Pipeline instruction fetch stage

module pipeline_if(input         clk, reset,
                   input         pcsrc, // To branch or to not branch that is the question.
                   input         hazard,
                   input [31:0]  branchaddr,
                   output [31:0] pcplus4,
                   output [31:0] pc);

   wire [31:0]                   pcnext;
   wire [31:0]                   pcnextnext;
   wire [31:0]                   hazardmid;

   reg [1:0]                     hazardflag;

   always @ (posedge reset, posedge clk) begin
      if (reset) hazardflag <= 0;
      else
        begin
           if (hazard && hazardflag == 2'b00)
             begin
                hazardflag = 2'b11;
             end
           else
             begin
                hazardflag = {1'b0, hazardflag[1]};
             end
        end
   end

   flopr #(32) pcnextreg(.clk   (clk),
                         .reset (reset),
                         .enable(hazard & (!hazardflag[0])),
                         .d     (pcnext),
                         .q     (hazardmid));

   assign pcnextnext = hazardflag[0] ? hazardmid : pcnext;

   flopr #(32) pcreg(.clk   (clk),
                     .reset (reset),
                     .enable(~hazard),
                     .d     (pcnextnext),
                     .q     (pc));

   adder pcadd1(.a (pc),
                .b (32'b100),
                .y (pcplus4));

   mux2 #(32) pcsrcmux(.d0  (pcplus4),
                       .d1  (branchaddr),
                       .s   (pcsrc),
                       .y   (pcnext));
endmodule // pipeline_if
