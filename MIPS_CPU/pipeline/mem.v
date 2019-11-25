`include "simparams.vh"

// Pipeline data memory stage

module pipeline_mem(input clk, reset,
                    input  branch,
                    input  zero,
                    output pcsrc);

   assign pcsrc = branch & zero;

   // TODO: Wire it to memory... somehow...

endmodule // pipeline_mem
