`include "simparams.vh"

// Pipeline data memory stage

module pipeline_mem(input  branch,
                    input  jump,
                    input  jumptoreg,
                    input  zero,
                    output pcsrc);

   assign pcsrc = (branch & zero) | jump | jumptoreg;

   // TODO: Wire it to memory... somehow...

endmodule // pipeline_mem
