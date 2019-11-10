module fbram(
             input        clk,
             input [31:0] wad,
             input [31:0] rad,
             input        wre,
             output [7:0] din,
             output [7:0] dout
             );

`include "lcd_params.vh"

   reg [7:0]              dout;
   reg [7:0]              ram [0:fbsize - 1];

   initial $readmemh("mogumo.hex", ram);

   always @ (posedge clk)
     begin
        if (wre)
          begin
             ram[wad] <= din;
          end

        dout <= ram[rad];
     end
endmodule // fbram
