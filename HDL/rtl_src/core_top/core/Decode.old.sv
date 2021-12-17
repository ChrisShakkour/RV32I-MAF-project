/*
 
 
 
 */

module Decode
  import instructions_pkg::*;
  (
   input logic                       clk,
   input logic                       rstn,
   input logic [XLEN-1:0]            Instruction,
   input logic [MSB_REG_FILE-1:0]    rd_Ps6,
   input logic                       CtrlWriteEn, //from Ps6
   input logic [XLEN-1:0]            DataRd,      //from Ps6
   input logic [XLEN-1:0]            pc,
   input logic [XLEN-1:0]            pc_pls4,
  
   output logic [XLEN-1:0]           AluDataIn1,
   output logic [XLEN-1:0]           AluDataIn2,
   output logic [MSB_REG_FILE-1:0]   rd,
   output e_alu_sel                  ctrl_sel_alu,
   output logic                      sel_next_pc_out,
   output logic [XLEN-1:0]           pc_out,
   output logic [XLEN-1:0]           pc_pls4_out,
   output logic                      ctrl_lui_inst,
   output logic			     ctrl_mem_wr,  
   output logic                      ctrl_reg_wr,  
   output logic [1:0]                ctrl_mem_size,
   output logic [XLEN-1:0]           rs2_data_out   
   );

logic [XLEN-1:0]           rs1_data;
logic [XLEN-1:0]           rs2_data;
logic [MSB_REG_FILE-1:0]   rs1;
logic [MSB_REG_FILE-1:0]   rs2;
logic [XLEN-1:0]           imm;
logic [XLEN-1:0]           AluDataIn1_nxt;
logic [XLEN-1:0]           AluDataIn2_nxt;
logic [MSB_REG_FILE-1:0]   rd_nxt;

logic [2:0]         funct3;
logic [6:0]         funct7;
logic [6:0]         opcode;

//##### CONTROL SIGNALS ##############
logic               ctrl_sel_imm;
logic               sel_next_pc;
e_alu_sel           ctrl_sel_alu_nxt;
logic               ctrl_lui_inst_nxt;
logic               ctrl_mem_wr_nxt;  
logic               ctrl_reg_wr_nxt;  
logic [1:0]         ctrl_mem_size_nxt;

   // TODO forwarding is disabled 1'b1
   // to be added accordingly
   RegisterFile Reg_file(                 //hazard handled inside reg file   
      .clk             (clk),  
      .rs0_write       (CtrlWriteEn),     
      .rs0_data_in     (DataRd),       
      .rs0_addr        (rd_Ps6),       
      .rs1_read        (1'b1),     
      .rs1_data_out    (rs1_data),        
      .rs1_addr        (rs1),         
      .rs1_forward     (1'b0),     
      .rs2_read        (1'b1),        
      .rs2_data_out    (rs2_data),        
      .rs2_addr        (rs2),        
      .rs2_forward     (1'b0)
    );

assign opcode           = Instruction[ 6: 0];
assign funct3           = Instruction[14:12];
assign funct7           = Instruction[31:25];

// DATA
assign AluDataIn1_nxt = rs1_data;
assign AluDataIn2_nxt = ctrl_sel_imm ? imm : rs2_data; 


// instraction decode
always_comb begin
	ctrl_sel_imm      = !(opcode == MUL_AND_INT);
	ctrl_lui_inst_nxt =  (opcode == LUI);
	sel_next_pc       =  (opcode == JAL);
	ctrl_mem_wr_nxt   =  (opcode == STORE);
	ctrl_reg_wr_nxt   =  (opcode == LUI) || (opcode == JAL) || (opcode == MUL_AND_INT) || (opcode == IMM);
	ctrl_mem_size_nxt =  (funct3 == WORD    ) ? 2'b00 : 
			     (funct3 == HALFWORD) ? 2'b10 :
			     (funct3 == BYTE    ) ? 2'b01 : 2'bxx;
	rd_nxt            =  Instruction[11: 7];
	rs1               =  Instruction[19:15];
	rs2               =  Instruction[24:20]; 

	if ((opcode == MUL_AND_INT) & (funct7[1] == 1'b0)) begin
		case(funct3)
			F3_ADD  : ctrl_sel_alu_nxt = funct7[5] ? SUB : ADD;
                        F3_SLT  : ctrl_sel_alu_nxt = SLT;
                        F3_SLTU : ctrl_sel_alu_nxt = SLTU;
                        F3_XOR  : ctrl_sel_alu_nxt = XOR;
                        F3_OR   : ctrl_sel_alu_nxt = OR;
                        F3_AND  : ctrl_sel_alu_nxt = AND;
                        F3_SLL  : ctrl_sel_alu_nxt = SLL;
                        F3_SRLA : ctrl_sel_alu_nxt = funct7[5] ? SRL : SRA;
		endcase
	end else if(opcode == IMM) begin
		case(funct3)		
			F3_ADD  : ctrl_sel_alu_nxt = ADD;
                        F3_SLT  : ctrl_sel_alu_nxt = SLT;
                        F3_SLTU : ctrl_sel_alu_nxt = SLTU;
                        F3_XOR  : ctrl_sel_alu_nxt = XOR;
                        F3_OR   : ctrl_sel_alu_nxt = OR;
                        F3_AND  : ctrl_sel_alu_nxt = AND;
                        F3_SLL  : ctrl_sel_alu_nxt = SLL;
                        F3_SRLA : ctrl_sel_alu_nxt = funct7[5] ? SRL : SRA;	
		endcase	
	end else begin
				  ctrl_sel_alu_nxt = ADD;
	end

	case(opcode)
		IMM     : imm = {{20{Instruction[31]}},Instruction[31:20]};
		JAL     : imm = {{12{Instruction[31]}},Instruction[19:12],Instruction[20],Instruction[30:21],1'b0};
		LUI     : imm = {Instruction[31:12],12'b0};
		STORE   : imm = {{20{Instruction[31]}},Instruction[31:25],Instruction[11:7]}; 
		default : imm = 32'bx;
	endcase

end


//######## REGISTERS ########################

    always_ff @(posedge clk)
	    AluDataIn1 <= AluDataIn1_nxt;

    always_ff @(posedge clk)
	    AluDataIn2 <= AluDataIn2_nxt;

   always_ff @(posedge clk)
	    ctrl_sel_alu <= ctrl_sel_alu_nxt;

   always_ff @(posedge clk)
	    pc_out <= pc;
   
   always_ff @(posedge clk)
	    pc_pls4_out <= pc_pls4;

  always_ff @(posedge clk or negedge rstn)
  	  if(!rstn)
	  sel_next_pc_out <= 1'b0;
	  else
	  sel_next_pc_out <= sel_next_pc;

   always_ff @(posedge clk)
	    rd <= rd_nxt;

   always_ff @(posedge clk)
	    ctrl_lui_inst <= ctrl_lui_inst_nxt;

    always_ff @(posedge clk)
	    ctrl_mem_wr <= ctrl_mem_wr_nxt;

    always_ff @(posedge clk)
	    ctrl_reg_wr <= ctrl_reg_wr_nxt;

    always_ff @(posedge clk)
	    ctrl_mem_size <= ctrl_mem_size_nxt;
    always_ff @(posedge clk)
	    rs2_data_out <= rs2_data;
endmodule // Decode
