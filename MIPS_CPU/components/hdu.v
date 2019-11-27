`include "simparams.vh"

// Hazard detection unit

module hdu(input [4:0] id_rs,
           input [4:0] id_rt,
           input [4:0] ex_rd,
           input       ex_regwriteen,
           input       ex_memtoreg,
           input       id_alusrc,
           output      hazard);

   wire                exe_hazard;

   //assign exe_hazard = ex_regwriteen && ((id_rs == ex_rd) || (id_rt == ex_rd));
   assign exe_hazard = ex_regwriteen;

   assign hazard = exe_hazard;

endmodule // hdu
