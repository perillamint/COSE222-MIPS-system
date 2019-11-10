module lcd(input        clk, // 4MHz clk
           input        rst_n,
           output       fb_clk,
           input [7:0]  fb_data,
           input [31:0] fb_addr,
           output [3:0] data,
           output       flm,
           output       lp,
           output       dclk,
           output       m);
`include "lcd_params.vh"

   reg [3:0]            data;
   reg                  flm;
   reg                  lp;
   reg                  dclk;
   reg                  m;

   reg [7:0]            state;
   reg [15:0]           row;
   reg [15:0]           coloff; // col / 4
   reg                  tmp;

   wire [7:0]           fb_bitswap;
   wire [7:0]           fb_data;
   wire [31:0]          fb_addr;

   genvar               i;

   generate
      for (i = 0; i < 8; i = i + 1)
        begin
           assign fb_bitswap[i] = fb_data[7 - i];
        end
   endgenerate

   assign fb_clk = clk;
   assign fb_addr = row * (res_x / 8) + coloff[15:1];

   always @ (negedge clk, negedge rst_n)
     begin
        if (!rst_n)
          begin
             data <= 0;
             flm <= 0;
             lp <= 0;
             dclk <= 0;
             m <= 0;
             state <= 0;
             row <= 0;
             coloff <= 0;
             tmp <= 0;
          end
        else
          begin
             case(state)
               8'h00:
                 begin
                    if (row == 0)
                      begin
                         flm <= 1;
                         m <= ~m;
                      end
                    else
                      begin
                         flm <= 0;
                      end

                    lp <= 1;
                    state <= state + 1;
                 end // case: 8'h01
               8'h01:
                 begin
                    lp <= 0; // Clock down
                    if (coloff >= 8'd80)
                      begin
                         coloff <= 0;
                         state <= state + 1;
                         dclk <= 0;
                      end
                    else
                      begin
                         tmp <= ~tmp;
                         if (!tmp)
                           begin
                              data <= coloff[0] ? fb_bitswap[3:0] : fb_bitswap[7:4];
                              dclk <= 1;
                           end
                         else
                           begin
                              dclk <= 0;
                              coloff <= coloff + 1;
                           end
                      end // else: !if(coloff >= 8'd80)
                 end
               8'h02:
                 begin
                    if (row >= res_y - 1)
                      begin
                         row <= 0;
                      end
                    else
                      begin
                         row <= row + 1;
                      end
                    state <= 0;
                 end
             endcase // case (state)
          end
     end
endmodule // lcd
