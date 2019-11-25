`include "simparams.vh"

// To branch, or not to branch, that is the question.

module pipeline_bp(input clk, reset,
                   input  pcsrc, // Branch flag
                   output prediction);

   // Implement naive strategy: It will ALWAYS branch
   assign prediction = ~pcsrc;
endmodule // pipeline_bp
