`include "simparams.vh"

module pipe_if2id(input clk, reset,
                  input         flush,
                  input         freeze,
                  input [31:0]  if_pcplus4,
                  input [31:0]  if_instr,
                  output [31:0] id_pcplus4,
                  output [31:0] id_instr);

   reg [31:0]              id_pcplus4;
   reg [31:0]              id_instr;

   // Dummy if2id
   always @(posedge clk, posedge reset)
     begin
        if (reset)
          begin
             id_pcplus4 <= 0;
             id_instr <= 0;
          end
        else
          begin
             id_pcplus4 <= if_pcplus4;
             if (flush)
               begin
                  id_instr <= 32'h00000000; // Inject NOP bubble
               end
             else
               begin
                  if (!freeze)
                    begin
                       id_instr <= if_instr;
                    end
               end
          end
     end

endmodule // pipe_if2id
