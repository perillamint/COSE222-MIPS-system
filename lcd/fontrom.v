module fontrom(
               input        clk,
               input [31:0] rad,
               output [7:0] dout
               );

   reg [7:0]              data;
   reg [7:0]              rom [0:(128*16)];
   genvar                 i;

   initial $readmemh("./lcd/7SEG-CA.FNT.hex", rom);

   // Swap endian
   generate
      for (i = 0; i < 8; i = i + 1)
        begin
           //assign dout[i] = data[7 - i];
           assign dout[i] = data[i];
        end
   endgenerate

   always @ (posedge clk)
     begin
        data <= rom[rad];
     end
endmodule // fontrom
