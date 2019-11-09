module LFE5UM5G_85F_EVN (
   input        CLOCK_50,
   input [7:0]  switch,
   input        rst_n,
   output [7:0] led);

   // Glue module between Altera board and Lattice ECP5 EVN

   wire [2:0]    BUTTON;
   wire [9:0]    SW;
   wire [6:0]    HEX3_D;
   wire [6:0]    HEX2_D;
   wire [6:0]    HEX1_D;
   wire [6:0]    HEX0_D;
   wire [9:0]    LEDG;

   assign SW[7:0] = switch;
   assign SW[9:8] = 2'b00;
   assign LEDG[7:0] = led;
   assign BUTTON[0] = rst_n;
   assign BUTTON[2:1] = 2'b00;

   MIPS_System mipscore(.CLOCK_50(CLOCK_50),
                        .BUTTON(BUTTON),
                        .SW(SW),
                        .HEX3_D(HEX3_D),
                        .HEX2_D(HEX2_D),
                        .HEX1_D(HEX1_D),
                        .HEX0_D(HEX0_D),
                        .LEDG(LEDG));

endmodule
