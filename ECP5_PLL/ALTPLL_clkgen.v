// Hand wired Altera-compatible PLL implementation
// It will not break lots of things... maybe...

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module ALTPLL_clkgen (
	                    inclk0,
	                    c0,
	                    c1,
	                    c2,
	                    locked);

	 input	  inclk0;
	 output	  c0;
	 output	  c1;
	 output	  c2;
	 output	  locked;

`ifdef __ICARUS__
 `define NOTECP5
`endif

`ifdef FORMAL
 `define NOTECP5
`endif

`ifdef NOTECP5
   reg [3:0] clkdiv;
   reg       c0;
   reg       c1;
   reg       c2;

   initial c0 = 0;
   initial c1 = 0;
   initial c2 = 0;
   initial clkdiv = 0;

   assign locked = 1;

   always @ (posedge inclk0)
     begin
        if (clkdiv > 4'd8)
          begin
             clkdiv <= 0;
          end
        else
          begin
             clkdiv <= clkdiv + 1;
             if (clkdiv == 4'd4)
               begin
                  c2 <= ~c2;
               end
             if (clkdiv == 4'd2)
               begin
                  c1 <= ~c1;
               end
             if (clkdiv == 4'd0)
               begin
                  c0 <= ~c0;
               end
          end // else: !if(clkdiv > 4'd8)
     end
`else
   (* FREQUENCY_PIN_CLKI="50" *)
   (* FREQUENCY_PIN_CLKOP="10" *)
   (* FREQUENCY_PIN_CLKOS="10" *)
   (* FREQUENCY_PIN_CLKOS2="10" *)
   (* ICP_CURRENT="12" *) (* LPF_RESISTOR="8" *) (* MFG_ENABLE_FILTEROPAMP="1" *) (* MFG_GMCREF_SEL="2" *)
   EHXPLLL #(
             .PLLRST_ENA("DISABLED"),
             .INTFB_WAKE("DISABLED"),
             .STDBY_ENABLE("DISABLED"),
             .DPHASE_SOURCE("DISABLED"),
             .OUTDIVIDER_MUXA("DIVA"),
             .OUTDIVIDER_MUXB("DIVB"),
             .OUTDIVIDER_MUXC("DIVC"),
             .OUTDIVIDER_MUXD("DIVD"),
             .CLKI_DIV(5),
             .CLKOP_ENABLE("ENABLED"),
             .CLKOP_DIV(60),
             .CLKOP_CPHASE(30),
             .CLKOP_FPHASE(0),
             .CLKOS_ENABLE("ENABLED"),
             .CLKOS_DIV(60),
             .CLKOS_CPHASE(45),
             .CLKOS_FPHASE(0),
             .CLKOS2_ENABLE("ENABLED"),
             .CLKOS2_DIV(60),
             .CLKOS2_CPHASE(60),
             .CLKOS2_FPHASE(0),
             .FEEDBK_PATH("CLKOP"),
             .CLKFB_DIV(1)
             ) pll_i (
                      .RST(1'b0),
                      .STDBY(1'b0),
                      .CLKI(inclk0),
                      .CLKOP(c0),
                      .CLKOS(c1),
                      .CLKOS2(c2),
                      .CLKFB(c0),
                      .CLKINTFB(),
                      .PHASESEL0(1'b0),
                      .PHASESEL1(1'b0),
                      .PHASEDIR(1'b1),
                      .PHASESTEP(1'b1),
                      .PHASELOADREG(1'b1),
                      .PLLWAKESYNC(1'b0),
                      .ENCLKOP(1'b0),
                      .LOCK(locked)
                      );
`endif // !`ifdef NOTECP5

endmodule
