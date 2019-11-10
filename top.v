// Glue module between Altera board and Lattice ECP5 EVN

module LFE5UM5G_85F_EVN (
   input        CLOCK_50,
   output       clk_en,
   input [7:0]  switch,
   input        rst_n,
   output [7:0] led,
   output       lcd_flm,
   output       lcd_cl1,
   output       lcd_cl2,
   output       lcd_m,
   output [3:0] lcd_data);

   assign clk_en = 1;

   reg [15:0]   clkdiv;
   reg          clk_lcd;

   wire [2:0]    BUTTON;
   wire [9:0]    SW;
   wire [6:0]    HEX_D[1:0];
   wire [9:0]    LEDG;

   assign SW[7:0] = switch;
   assign SW[9:8] = 2'b00;
   assign LEDG[7:0] = led;
   assign BUTTON[0] = rst_n;
   assign BUTTON[2:1] = 2'b00;
   wire          fb_clk;
   wire [31:0]   fb_addr;
   wire [7:0]    fb_data;

   wire          fb_wclk;
   reg [31:0]    fb_waddr;
   reg [7:0]     fb_wdata;
   wire [7:0]    fontdata;

   fbram fb(.clk(fb_clk),
            .wre(1'b1),
            .rad(fb_addr),
            .wad(fb_waddr),
            .dout(fb_data),
            .din(fontdata));

   lcd lcd1 (.clk(clk_lcd),
             .rst_n(rst_n),
             .fb_clk(fb_clk),
             .fb_data(fb_data),
             .fb_addr(fb_addr),
             .data(lcd_data),
             .flm(lcd_flm),
             .lp(lcd_cl1),
             .dclk(lcd_cl2),
             .m(lcd_m));

   reg [7:0]   digitoff;
   reg [31:0]  fontoff;

   fontrom fntrom(CLOCK_50, HEX_D[digitoff] * 16 + fontoff, fontdata);

   always @ (negedge CLOCK_50)
     begin
        if (clkdiv >= 8'd10)
          begin
             clkdiv <= 0;
             clk_lcd <= ~clk_lcd;
          end
        else
          begin
             clkdiv <= clkdiv + 1;
          end
     end // always @ (negedge clk, negedge rst_n)

   always @ (posedge CLOCK_50, negedge rst_n)
     begin
        if (!rst_n)
          begin
             fontoff <= 0;
             digitoff <= 0;
          end
        else
          begin
             if (fontoff >= 15)
               begin
                  fontoff <= 0;
                  if (digitoff >= 3)
                    begin
                       digitoff <= 0;
                    end
                  else
                    begin
                       digitoff <= digitoff + 1;
                    end
               end
             else
               begin
                  fontoff <= fontoff + 1;
               end

             fb_waddr <= digitoff * 2 + fontoff * 40;
          end
     end

   MIPS_System mipscore(.CLOCK_50(CLOCK_50),
                        .BUTTON(BUTTON),
                        .SW(SW),
                        .HEX3_D(HEX_D[2'd3]),
                        .HEX2_D(HEX_D[2'd2]),
                        .HEX1_D(HEX_D[2'd1]),
                        .HEX0_D(HEX_D[2'd0]),
                        .LEDG(LEDG));

endmodule
