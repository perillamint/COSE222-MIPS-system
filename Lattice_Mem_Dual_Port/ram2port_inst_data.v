// Hand wired Altera-compatible RAM implementation
// Yosys will optimize this logic into bram... maybe...


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module ram2port_inst_data (
    address_a,
    address_b,
    byteena_b,
    clock_a,
    clock_b,
    data_a,
    data_b,
    enable_a,
    enable_b,
    wren_a,
    wren_b,
    q_a,
    q_b);

   parameter ramsz = 1024 * 8; // 8k RAM
   // Hand wired Altera-compatible RAM implementation
   // Yosys will optimize this logic into bram... maybe...


   input [10:0]      address_a;
   input [10:0]      address_b;
   input [3:0]       byteena_b;
   input             clock_a;
   input             clock_b;
   input [31:0]      data_a;
   input [31:0]      data_b;
   input             enable_a;
   input             enable_b;
   input             wren_a;
   input             wren_b;
   output reg [31:0] q_a;
   output reg [31:0] q_b;

   reg [31:0]         ram [0:ramsz / 4];

   initial $readmemh("rom.hex", ram);

   always @ (posedge clock_a)
     begin
        if (wren_a & enable_a)
          begin
             ram[address_a] <= data_a;
          end
        if (enable_a)
          begin
             q_a <= ram[address_a];
          end
     end

   always @ (posedge clock_b)
     begin
        if (wren_b & enable_b)
          begin
             ram[address_b] <= data_b;
          end
        if (enable_b)
          begin
             q_b <= ram[address_b];
          end
     end
endmodule
