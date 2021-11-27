/*
 
 
 
 */
module Execute
  import instructions_pkg::*;
  (
   input logic                       clk,
   input logic                       rstn,
   input logic [XLEN-1:0]            AluDataIn1,
   input logic [XLEN-1:0]            AluDataIn2,
   input logic [MSB_REG_FILE-1:0]    rd,   
   input e_alu_sel                   ctrl_sel_alu,
   input logic [XLEN-1:0]            pc,
   input logic                       sel_next_pc,
   input logic [XLEN-1:0]            pc_pls4,
   input logic                       ctrl_lui_inst,
   input logic [XLEN-1:0]            rs2_data,
   input logic                       ctrl_mem_wr,  
   input logic                       ctrl_reg_wr,  
   input logic [1:0]                 ctrl_mem_size,

   output logic [XLEN-1:0]           AluOut,
   output logic [MSB_REG_FILE-1:0]   rdOut,
   output logic                      sel_next_pc_out,
   output logic [XLEN-1:0]           pc_pls4_out,
   output logic                      ctrl_mem_wr_out  ,
   output logic                      ctrl_reg_wr_out  ,
   output logic [1:0]                ctrl_mem_size_out,
   output logic [XLEN-1:0]           rs2_data_out   

);

logic [XLEN-1:0] AluOut_nxt;
logic [XLEN-1:0] AluIn1;


always_comb begin
	case ({sel_next_pc,ctrl_lui_inst})
		2'b01 : AluIn1 = 32'b0;
		2'b10 : AluIn1 = pc;
		2'b00 : AluIn1 = AluDataIn1;
		2'b11 : AluIn1 = 32'bx; //can't happen!
	endcase

	case (ctrl_sel_alu)
		ADD : AluOut_nxt = AluIn1 +    AluDataIn2;
		SUB : AluOut_nxt = AluIn1 -    AluDataIn2;
		SLT : AluOut_nxt = $signed(AluIn1) < $signed(AluDataIn2) ? 32'd1 : 32'b0; 
		SLTU: AluOut_nxt = AluIn1 <    AluDataIn2                ? 32'd1 : 32'b0; 
		OR  : AluOut_nxt = AluIn1 |    AluDataIn2;
		AND : AluOut_nxt = AluIn1 &    AluDataIn2;
		XOR : AluOut_nxt = AluIn1 ^    AluDataIn2;
		SLL : AluOut_nxt = AluIn1 <<   AluDataIn2[4:0];
		SRL : AluOut_nxt = AluIn1 >>   AluDataIn2[4:0];
		SRA : AluOut_nxt = $signed(AluIn1) >>>  AluDataIn2[4:0]; //TODO check
	endcase 
end

//######### REGISTERS EXE1 ##############

always_ff @(posedge clk)
	AluOut <= AluOut_nxt;

always_ff @(posedge clk)
	rdOut <= rd;

always_ff @(posedge clk)
	pc_pls4_out <= pc_pls4;

always_ff @(posedge clk or negedge rstn)
	if(!rstn)
	sel_next_pc_out <= 1'b0;
	else
	sel_next_pc_out <= sel_next_pc;

always_ff @(posedge clk)
	rs2_data_out <= rs2_data;
always_ff @(posedge clk)
	ctrl_mem_wr_out   <= ctrl_mem_wr;  
always_ff @(posedge clk)
	ctrl_reg_wr_out   <= ctrl_reg_wr; 
always_ff @(posedge clk)       	
	ctrl_mem_size_out <= ctrl_mem_size;

endmodule 
   
