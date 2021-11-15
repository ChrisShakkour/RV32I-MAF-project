/*
 
 
 
 */

`include "../../../packages/defines.sv"
module Execute
  import instructions_pkg::*;
  (
   input logic                       clk,
   input logic                       rstn,
   input logic [INST_WIDTH-1:0]      ir,
   input logic [XLEN-1:0]            AluDataIn1,
   input logic [XLEN-1:0]            AluDataIn2,
   input logic [MSB_REG_FILE-1:0]    rd,   

   output logic [XLEN-1:0]           AluOut,
   output logic [MSB_REG_FILE-1:0]   rdOut,   
   output logic [INST_WIDTH-1:0]     irOut

);

logic [XLEN-1:0] AluOut_nxt;

always_comb begin
	case (ir[`ALU_SEL_BITS])
		ADD : AluOut_nxt = (ir[3] == 1'b1) ? AluDataIn1 - AluDataIn2 : AluDataIn1 + AluDataIn2;           // bit 3 of ir will be the mux sel
		SLT : AluOut_nxt = $signed(AluDataIn1) < $signed(AluDataIn2) ? 32'd1 : 32'b0; 
		SLTU: AluOut_nxt = AluDataIn1 <    AluDataIn2                ? 32'd1 : 32'b0; 
		OR  : AluOut_nxt = AluDataIn1 |    AluDataIn2;
		AND : AluOut_nxt = AluDataIn1 &    AluDataIn2;
		XOR : AluOut_nxt = AluDataIn1 ^    AluDataIn2;
		SLL : AluOut_nxt = AluDataIn1 <<   AluDataIn2[4:0];
		SRL : AluOut_nxt = (ir[3] == 1'b1) ? AluDataIn1 >>  AluDataIn2[4:0] : AluDataIn1 >>> AluDataIn2;
	endcase 
end

//######### REGISTERS EXE1 ##############

always_ff @(posedge clk)
	AluOut <= AluOut_nxt;

always_ff @(posedge clk)
	rdOut <= rd;

always_ff @(posedge clk)
	irOut <= ir;


endmodule 
   
