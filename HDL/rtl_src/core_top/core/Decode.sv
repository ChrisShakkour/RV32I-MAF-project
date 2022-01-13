/*///////////////////////////////////////////////////////////////////
 
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 -> Contributers:
 
 -> Description: instruction decode state machine.
 
 -> Features:
 
 -> module:
   ___                    _      
  |   \  ___  __  ___  __| | ___ 
  | |) |/ -_)/ _|/ _ \/ _` |/ -_)
  |___/ \___|\__|\___/\__,_|\___|
                                 
 *////////////////////////////////////////////////////////////////////

module Decode
  import instructions_pkg::*;
   import memory_pkg::*;
   import control_pkg::*;
   (
    input logic 		     clk,
    input logic 		     rstn,
    
    // comming from inst fetch
    input logic [XLEN-1:0] 	     instruction_in,
    input logic [XLEN-1:0] 	     pc_in,
    input logic [XLEN-1:0] 	     pc_pls4_in,
    
    //###########################################
    //### DATA signals
    //###########################################
    // pc out to exe stage
    output logic [XLEN-1:0] 	     pc,
    output logic [XLEN-1:0] 	     pc_pls4, 

    output logic 		     ctrl_pc_stall_set,

    // going to exe stage.
    output logic [XLEN-1:0] 	     rs1_data,
    output logic [XLEN-1:0] 	     rs2_data,
    output logic [MSB_REG_FILE-1:0]  rd_addr,
    output logic [XLEN-1:0] 	     immediate,
   
    //###########################################
    //### feedback signals
    //###########################################
    // comming from writeback stage.
    input logic [MSB_REG_FILE-1:0]   wrb_rd_addr, //from Ps6
    input logic 		     wrb_rd_write, //from Ps6
    input logic [XLEN-1:0] 	     wrb_rd_data, //from Ps6
    
    //###########################################
    //### control signals
    //###########################################
    // data mem control
    output logic 		     ctrl_dmem_req, 
    output logic 		     ctrl_dmem_write, 
    output logic 		     ctrl_dmem_l_unsigned, 
    output logic [1:0] 		     ctrl_dmem_n_bytes,
    // alu control
    output 			     e_alu_operation_sel ctrl_alu_op_sel,
    output 			     e_alu_operand_a_sel ctrl_alu_a_sel, 
    output 			     e_alu_operand_b_sel ctrl_alu_b_sel, 
    // write back to rf mux select
    output 			     e_regfile_wb_sel ctrl_wb_to_rf_sel,
    // JALR set last bit to zero
    output logic 		     set_alu_lsb_bit_zero,
    // branch compare signals
    output logic 		     ctrl_branch_enable,
    output 			     e_branch_operation_sel ctrl_branch_operation,
    // jump request sent to Fetch stage
    output logic 		     ctrl_jump_request,
    
    output logic 		     ctrl_reg_wr,

    output                           e_data_hazard aluin1_hazard_sel_o,
    output 	   	             e_data_hazard aluin2_hazard_sel_o    
    );


   logic [INST_W-1:0] 		    instruction;
   logic [OPCODE_W-1:0] 	    opcode;
   logic [FUNCT3_W-1:0] 	    funct3;
   logic [FUNCT5_W-1:0] 	    funct5;
   logic [FUNCT7_W-1:0] 	    funct7;
   
   logic [XLEN-1:0] 		    rs1_data_nxt;
   logic [XLEN-1:0] 		    rs2_data_nxt;
   logic [MSB_REG_FILE-1:0] 	    rd_addr_nxt;
   logic [XLEN-1:0] 		    immediate_nxt; 

   logic [MSB_REG_FILE-1:0] 	    rs1_addr;
   logic [MSB_REG_FILE-1:0] 	    rs2_addr;
   
   // alu  control control
   e_alu_operation_sel              ctrl_alu_op_sel_nxt;
   e_alu_operand_a_sel              ctrl_alu_a_sel_nxt; 
   e_alu_operand_b_sel		    ctrl_alu_b_sel_nxt; 

   // writeback control
   e_regfile_wb_sel                 ctrl_wb_to_rf_sel_nxt;
   
   
   logic 			    set_alu_lsb_bit_zero_nxt;
   logic 			    sel_next_pc;
   logic 			    ctrl_lui_inst_nxt;
   logic 			    ctrl_reg_wr_nxt;  
   // dmem control logic
   logic 			    ctrl_dmem_req_nxt;
   logic 			    ctrl_dmem_write_nxt;
   logic 			    ctrl_dmem_l_unsigned_nxt; 
   logic [1:0] 			    ctrl_dmem_n_bytes_nxt;

   
   logic 			    ctrl_branch_enable_nxt;
   e_branch_operation_sel           ctrl_branch_operation_nxt;

   logic 			    ctrl_jump_request_nxt;
   
   logic 			    nop_sel;
   logic 			    nop_set;
   logic [NOP_CNT_WIDTH-1:0] 	    nop_count;
    
   logic 			    ctrl_pc_stall_set_nxt;
   
   //data hazard
   e_data_hazard              	    aluin1_hazard_sel;
   e_data_hazard   		    aluin2_hazard_sel;   
   
   assign opcode   = instruction[ 6: 0];
   assign funct3   = instruction[14:12];
   assign funct5   = instruction[31:27];
   assign funct7   = instruction[31:25];

   assign rs1_addr    = instruction[19:15];
   assign rs2_addr    = instruction[24:20];
   assign rd_addr_nxt = instruction[11: 7];
      

 /*//////////////////////////////////////////////////////
   ___            _                   _              _ 
  |_ _| _ _   ___| |_   __  ___  _ _ | |_  _ _  ___ | |
   | | | ' \ (_-<|  _| / _|/ _ \| ' \|  _|| '_|/ _ \| |
  |___||_||_|/__/ \__| \__|\___/|_||_|\__||_|  \___/|_|
                                                          
  *//////////////////////////////////////////////////////

   DownCounter
     #(.WIDTH(NOP_CNT_WIDTH))
   DownCounter_inst
     (
      .clk    (clk),
      .rstn   (rstn),
      .enable (1'b1),
      .set    (nop_set),
      .count  (nop_count),
      .status (nop_sel)
      );

   always_comb
     if(nop_sel) instruction = NOP;
     else        instruction = instruction_in;
   
   
/*///////////////////////////////////////////////////////
   ___             _      _              ___  _  _      
  | _ \ ___  __ _ (_) ___| |_  ___  _ _ | __|(_)| | ___ 
  |   // -_)/ _` || |(_-<|  _|/ -_)| '_|| _| | || |/ -_)
  |_|_\\___|\__, ||_|/__/ \__|\___||_|  |_|  |_||_|\___|
            |___/                                       
 *///////////////////////////////////////////////////////
   
   RegisterFile
     RegisterFile_inst
       (
	.clk             (clk),
	// rs1 write port
	.rs0_write       (wrb_rd_write),     
	.rs0_data_in     (wrb_rd_data),       
	.rs0_addr        (wrb_rd_addr),       
	// rs1 read port
	.rs1_data_out    (rs1_data_nxt),        
	.rs1_addr        (rs1_addr),         
	// rs2 read port
	.rs2_data_out    (rs2_data_nxt),        
	.rs2_addr        (rs2_addr)        
	);



//Forwarding
    ForwardingUnit
	ForwardingUnit_inst
	(
	.clk               (clk),
        .rs1               (rs1_addr),
        .rs2               (rs2_addr),
        .rd                (rd_addr_nxt),
	.rd_wr             (ctrl_reg_wr_nxt),
                                            
	.aluin1_hazard_sel (aluin1_hazard_sel),	
        .aluin2_hazard_sel (aluin2_hazard_sel)
	);

/*/////////////////////////////////////////////////////////
   ___                    _              ___  ___  __  __ 
  |   \  ___  __  ___  __| | ___   ___  | __|/ __||  \/  |
  | |) |/ -_)/ _|/ _ \/ _` |/ -_) |___| | _| \__ \| |\/| |
  |___/ \___|\__|\___/\__,_|\___|       |_|  |___/|_|  |_|
                                                          
 *////////////////////////////////////////////////////////
   
   always_comb begin
      // default case here

      // nop injection paramters
      nop_set   = 1'b0;
      nop_count =   '0;

      // branch comparator signals
      ctrl_branch_enable_nxt    = 1'b0;
      ctrl_branch_operation_nxt = CMP_BEQ;

      // control jump request
      ctrl_jump_request_nxt = 1'b0;
            
      // ALU function and operands select
      ctrl_alu_op_sel_nxt  = ALU_ADD;
      ctrl_alu_a_sel_nxt   = ALU_ZERO;
      ctrl_alu_b_sel_nxt   = ALU_RS2; 
      
      // immediate value
      immediate_nxt = '0;
            
      // goes to pc mux, select 
      // pc+4 or alu data out.
      sel_next_pc       = 1'b0; 
      ctrl_wb_to_rf_sel_nxt    = WB_ALU_OUT;
      
      // registerfile write enable
      ctrl_reg_wr_nxt   = 1'b0;
      
      // dmem load store control signals
      ctrl_dmem_req_nxt        = 1'b0; //no request by default.
      ctrl_dmem_write_nxt      = 1'b0; //0 for read, 1 for write.
      ctrl_dmem_l_unsigned_nxt = 1'b0; //used for LBU and LHU.
      ctrl_dmem_n_bytes_nxt    = WORD; //Byte, Halfword, Word.

      // mask
      set_alu_lsb_bit_zero_nxt = 1'b0;

      // pc stall control signals
      ctrl_pc_stall_set_nxt = 1'b0;
      
      
      unique case(opcode)
	
/*/////////////////////////////////////
   ___         _____ __   __ ___  ___ 
  | _ \  ___  |_   _|\ \ / /| _ \| __|
  |   / |___|   | |   \ V / |  _/| _| 
  |_|_\         |_|    |_|  |_|  |___|
                                      
 */////////////////////////////////////
	
	MUL_AND_INT: begin
	   ctrl_wb_to_rf_sel_nxt = WB_ALU_OUT;
	   ctrl_alu_a_sel_nxt    = ALU_RS1;
	   ctrl_alu_b_sel_nxt    = ALU_RS2;  
	   ctrl_reg_wr_nxt       = 1'b1;	   
	   unique case(funct7)
	     /*ADD, SLL, SLT 
	      SLTU, XOR, SRL,
	      OR, AND*/ 
	     R_NORMAL: begin
		unique case(funct3)		  
		  ADD_SUB:
		    ctrl_alu_op_sel_nxt = ALU_ADD;
		  SLL:
		    ctrl_alu_op_sel_nxt = ALU_SLL;
		  SLT:
		    ctrl_alu_op_sel_nxt = ALU_SLT;
		  SLTU:
		    ctrl_alu_op_sel_nxt = ALU_ADD;
		  XOR:
		    ctrl_alu_op_sel_nxt = ALU_XOR;
		  SRL_SRA:
		    ctrl_alu_op_sel_nxt = ALU_SRL;		    
		  OR:
		    ctrl_alu_op_sel_nxt = ALU_OR;
		  AND:
		    ctrl_alu_op_sel_nxt = ALU_AND;
		endcase // unique case (funct3)
	     end // case: R_NORMAL

	     
	     /*SUB, SRA*/
	     R_SPECIALS: begin
		unique case(funct3)
		  ADD_SUB:
		    ctrl_alu_op_sel_nxt = ALU_SUB;
		  SRL_SRA:
		    ctrl_alu_op_sel_nxt = ALU_SRA;
		  default:;
		endcase // unique case (funct3)
	     end
	     
	     
	     /*MUL, MULH, MULHSU
	      MULHU, DIV, DIVU
	      REM, REMU*/	     
	     M_EXTENSION: begin
		unique case(funct3)
		  MUL:;		    
		  MULH:;
		  MULHSU:;
		  MULHU:;
		  DIV:;
		  DIVU:;
		  REM:;
		  REMU:;
		endcase	 
	     end // case: M_EXTENSION
	   endcase // unique case (funct7)
	end // case: MUL_AND_INT
	
 	   
	ATOMIC: begin
	end

	
/*////////////////////////////////////
   ___         _____ __   __ ___  ___ 
  |_ _|  ___  |_   _|\ \ / /| _ \| __|
   | |  |___|   | |   \ V / |  _/| _| 
  |___|         |_|    |_|  |_|  |___|
                                      
 *////////////////////////////////////

	/*LW, LH, LB, 
	 LHU, LBU*/
	/*addr = rs1 + immediate*/
	/*store data of addr into rd*/
	LOAD: begin
	   ctrl_reg_wr_nxt          = 1'b1;	   
	   ctrl_alu_op_sel_nxt      = ALU_ADD;
	   ctrl_alu_a_sel_nxt       = ALU_RS1;
	   ctrl_alu_b_sel_nxt       = ALU_IMM;
	   ctrl_wb_to_rf_sel_nxt    = WB_MEM_LOAD;
	   ctrl_dmem_req_nxt        = 1'b1; 
	   ctrl_dmem_write_nxt      = 1'b0;
	   ctrl_dmem_l_unsigned_nxt = 1'b0; 
	   immediate_nxt            = {{20{instruction[31]}},
				       instruction[31:20]};
	   unique case(funct3)
	     LW:
	       ctrl_dmem_n_bytes_nxt = WORD;
	     LH:
	       ctrl_dmem_n_bytes_nxt = HALFWORD;
	     LB:
	       ctrl_dmem_n_bytes_nxt = BYTE;
	     LHU: begin
		ctrl_dmem_n_bytes_nxt    = HALFWORD;
		ctrl_dmem_l_unsigned_nxt = 1'b1; 
	     end
	     LBU: begin
		ctrl_dmem_n_bytes_nxt    = BYTE;
		ctrl_dmem_l_unsigned_nxt = 1'b1; 
	     end
	     default:;
	   endcase // unique case (funct3)
	end // case: LOAD
	

	/*ADDI, SLTI, SLTIU
	 ANDI, ORI, XORI, 
	 SLLI, SRLI, SRAI*/
	/* rs1 {op} imm stored in rd*/
	IMM: begin
	   ctrl_wb_to_rf_sel_nxt = WB_ALU_OUT;
	   sel_next_pc        = 1'b0; 
	   ctrl_reg_wr_nxt    = 1'b1;
	   ctrl_alu_a_sel_nxt = ALU_RS1;
	   ctrl_alu_b_sel_nxt = ALU_IMM; 
	   immediate_nxt      = {{20{instruction[31]}},
				 instruction[31:20]};
	   unique case(funct3)
	     ADDI:
	       ctrl_alu_op_sel_nxt = ALU_ADD;
	     SLTI:
	       ctrl_alu_op_sel_nxt = ALU_SLT;
	     SLTIU:
	       ctrl_alu_op_sel_nxt = ALU_SLTU;
	     XORI:
	       ctrl_alu_op_sel_nxt = ALU_XOR;
	     ORI:
	       ctrl_alu_op_sel_nxt = ALU_OR;
	     ANDI:
	       ctrl_alu_op_sel_nxt = ALU_AND;
	     SLLI:
	       ctrl_alu_op_sel_nxt = ALU_SLL;
	     SRLI_SRAI: begin
		//SRAI
		if(funct7==7'b0100000) begin
		   ctrl_alu_op_sel_nxt = ALU_SRA;
		end
		//SRLI
		else begin
		   ctrl_alu_op_sel_nxt = ALU_SRL;		   
		end
	     end
	   endcase // unique case (funct3)
	end // case: IMM
	
	/*JALR*/
	/*pc = (rs1+imm) & 0xFFFFFFFE*/
	/*rd data = pc+4 */
	JALR: begin
	   if(funct3 == 3'b000) begin
	      nop_set                  = 1'b1;
	      nop_count                = 2;
	      ctrl_jump_request_nxt    = 1'b1;
	      ctrl_wb_to_rf_sel_nxt    = WB_PC_PLS4;
	      ctrl_reg_wr_nxt          = 1'b1;
	      ctrl_alu_op_sel_nxt      = ALU_ADD;
	      ctrl_alu_a_sel_nxt       = ALU_RS1;
	      ctrl_alu_b_sel_nxt       = ALU_IMM; 
	      set_alu_lsb_bit_zero_nxt = 1'b1;
	      immediate_nxt            = {{20{instruction[31]}},
					  instruction[31:20]};
	   end
	end
	
/*///////////////////////////////////////
   _   _         _____ __   __ ___  ___ 
  | | | |  ___  |_   _|\ \ / /| _ \| __|
  | |_| | |___|   | |   \ V / |  _/| _| 
   \___/          |_|    |_|  |_|  |___|
                                        
 *//////////////////////////////////////

	/*LUI*/
	/*Loads upper immediate value 
	 paded with zeros into rd*/
	LUI: begin
	   ctrl_reg_wr_nxt       = 1'b1;
	   ctrl_wb_to_rf_sel_nxt = WB_ALU_OUT;
	   ctrl_alu_op_sel_nxt   = ALU_ADD;
	   ctrl_alu_a_sel_nxt    = ALU_ZERO;
	   ctrl_alu_b_sel_nxt    = ALU_IMM; 
	   immediate_nxt         = {instruction[31:12],12'b0};
	end

	
	/*AUIPC*/
	/*Adds upper immediate value 
	 paded with zeros with PC 
	 stored into rd register*/
	AUIPC: begin
	   ctrl_reg_wr_nxt       = 1'b1;
	   ctrl_wb_to_rf_sel_nxt = WB_ALU_OUT;
	   ctrl_alu_op_sel_nxt   = ALU_ADD;
	   ctrl_alu_a_sel_nxt    = ALU_PC;
	   ctrl_alu_b_sel_nxt    = ALU_IMM; 
	   immediate_nxt         = {instruction[31:12],12'b0};
	end
	
/*//////////////////////////////////////
      _         _____ __   __ ___  ___ 
   _ | |  ___  |_   _|\ \ / /| _ \| __|
  | || | |___|   | |   \ V / |  _/| _| 
   \__/          |_|    |_|  |_|  |___|
 
 *//////////////////////////////////////

	/*JAL*/
	/*stores pc+4 in rd register*/
	/*updates pc to pc + (sign extended immediate)*/
	JAL: begin
	   nop_set                 = 1'b1;
	   nop_count               = 2;   
	   ctrl_jump_request_nxt   = 1'b1;
	   ctrl_reg_wr_nxt         = 1'b1;
	   ctrl_wb_to_rf_sel_nxt   = WB_PC_PLS4;
	   ctrl_alu_op_sel_nxt     = ALU_ADD;
	   ctrl_alu_a_sel_nxt      = ALU_PC;
	   ctrl_alu_b_sel_nxt      = ALU_IMM; 
	   immediate_nxt           = {{12{instruction[31]}},
				      instruction[19:12],
				      instruction[20],
				      instruction[30:21],1'b0};
	end

/*/////////////////////////////////////
   ___         _____ __   __ ___  ___ 
  | _ )  ___  |_   _|\ \ / /| _ \| __|
  | _ \ |___|   | |   \ V / |  _/| _| 
  |___/         |_|    |_|  |_|  |___|
                                      
 */////////////////////////////////////
	
	/*BEQ, BNE, BLT,
	 BLTU, BGE, BGEU*/
	BRANCH: begin
	   nop_set                 = 1'b1;
	   nop_count               = 2;   
	   ctrl_pc_stall_set_nxt   = 1'b1;
	   ctrl_branch_enable_nxt  = 1'b1;
	   ctrl_wb_to_rf_sel_nxt   = WB_ALU_OUT;
	   ctrl_alu_op_sel_nxt     = ALU_ADD;
	   ctrl_alu_a_sel_nxt      = ALU_PC;
	   ctrl_alu_b_sel_nxt      = ALU_IMM; 	   
	   immediate_nxt           = {{20{instruction[31]}},
	                              instruction[7],
	                              instruction[30:25],
	                              instruction[11:8],1'b0};
	   unique case(funct3)
	     BEQ:
	       ctrl_branch_operation_nxt = CMP_BEQ;
	     BNE:
	       ctrl_branch_operation_nxt = CMP_BNE;
	     BLT: 
	       ctrl_branch_operation_nxt = CMP_BLT;
	     BLTU:
	       ctrl_branch_operation_nxt = CMP_BLTU;
	     BGE:
	       ctrl_branch_operation_nxt = CMP_BGE;
	     BGEU:
	       ctrl_branch_operation_nxt = CMP_BGEU;
	     default:;
	   endcase // unique case (funct3)    
	end
	 
/*/////////////////////////////////////
   ___         _____ __   __ ___  ___ 
  / __|  ___  |_   _|\ \ / /| _ \| __|
  \__ \ |___|   | |   \ V / |  _/| _| 
  |___/         |_|    |_|  |_|  |___|
                                       
 */////////////////////////////////////
	
	/*SW, SH, SB*/
	/*store addr = rs1 + immediate*/
	/*store rs2 data into calculated addr*/
	STORE: begin
	   ctrl_alu_op_sel_nxt = ALU_ADD;
	   ctrl_alu_a_sel_nxt  = ALU_RS1;
	   ctrl_alu_b_sel_nxt  = ALU_IMM; 
	   ctrl_dmem_req_nxt        = 1'b1; 
	   ctrl_dmem_write_nxt      = 1'b1;
	   ctrl_dmem_l_unsigned_nxt = 1'b0; 
	   immediate_nxt       = {{20{instruction[31]}},
				  instruction[31:25],
				  instruction[11:7]};
	   unique case(funct3)
	     SW: 
	       ctrl_dmem_n_bytes_nxt = WORD;
	     SH:
	       ctrl_dmem_n_bytes_nxt = HALFWORD;
	     SB:
	       ctrl_dmem_n_bytes_nxt = BYTE;
	     default: ;
	   endcase // unique case (funct3)
	end // case: STORE
	
	default: ;
      endcase // unique case (opcode)
   end // always_comb   
   

/*////////////////////////////////////////////
    ___  ___   _  _  _____  ___   ___   _    
   / __|/ _ \ | \| ||_   _|| _ \ / _ \ | |   
  | (__| (_) || .` |  | |  |   /| (_) || |__ 
   \___|\___/ |_|\_|  |_|  |_|_\ \___/ |____|
                                             
   Async Reset registers
 *////////////////////////////////////////////
   
   // data memory control signals
   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) begin
	 ctrl_dmem_req        <= '0;
	 ctrl_dmem_write      <= '0;
	 ctrl_dmem_l_unsigned <= '0;
	 ctrl_dmem_n_bytes    <= WORD;
      end
      else begin
	 ctrl_dmem_req        <= ctrl_dmem_req_nxt;
	 ctrl_dmem_write      <= ctrl_dmem_write_nxt;
	 ctrl_dmem_l_unsigned <= ctrl_dmem_l_unsigned_nxt;
	 ctrl_dmem_n_bytes    <= ctrl_dmem_n_bytes_nxt;
      end
   end

   
   // ALU control signals
   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) begin
	 ctrl_alu_op_sel  <= ALU_ADD;
	 ctrl_alu_a_sel <= ALU_RS1; 
	 ctrl_alu_b_sel <= ALU_RS2;
      end
      else begin
	 ctrl_alu_op_sel <= ctrl_alu_op_sel_nxt;
	 ctrl_alu_a_sel  <= ctrl_alu_a_sel_nxt; 
	 ctrl_alu_b_sel  <= ctrl_alu_b_sel_nxt;   
      end
   end

   always_ff @(posedge clk or negedge rstn)
     if(~rstn) ctrl_wb_to_rf_sel <= WB_ALU_OUT;
     else      ctrl_wb_to_rf_sel <= ctrl_wb_to_rf_sel_nxt;   

   
   always_ff @(posedge clk or negedge rstn)
     if(~rstn) ctrl_reg_wr <= '0;
     else      ctrl_reg_wr <= ctrl_reg_wr_nxt;

   
   always_ff @(posedge clk or negedge rstn)
     if(~rstn) set_alu_lsb_bit_zero <= 1'b0;
     else      set_alu_lsb_bit_zero <= set_alu_lsb_bit_zero_nxt;

   always_ff @(posedge clk or negedge rstn)
     if(~rstn) begin
	ctrl_branch_enable    <= 1'b0;
	ctrl_branch_operation <= CMP_BEQ; //'0
     end
     else begin
	ctrl_branch_enable    <= ctrl_branch_enable_nxt;
	ctrl_branch_operation <= ctrl_branch_operation_nxt;
     end
   
   always_ff @(posedge clk or negedge rstn)
     if(~rstn) ctrl_pc_stall_set   <= 1'b0;
     else      ctrl_pc_stall_set   <= ctrl_pc_stall_set_nxt;

   always_ff @(posedge clk or negedge rstn)
     if(~rstn) ctrl_jump_request <= 1'b0;
     else      ctrl_jump_request <= ctrl_jump_request_nxt;

   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) begin
            aluin1_hazard_sel_o <= NO_HAZARD;
            aluin2_hazard_sel_o <= NO_HAZARD;
      end
      else begin
            aluin1_hazard_sel_o <= aluin1_hazard_sel;
            aluin2_hazard_sel_o <= aluin2_hazard_sel;	      
      end
   end

   
/*///////////////////////
   ___    _  _____  _                        
  |   \  /_\|_   _|/_\                       
  | |) |/ _ \ | | / _ \                      
  |___//_/ \_\|_|/_/ \_\                     
                         
   Ressetless registers                    
 *///////////////////////

   // pc and pc+4
   always_ff @(posedge clk) begin
      pc      <= pc_in;
      pc_pls4 <= pc_pls4_in;
   end    


   // rs1 data+addr
   always_ff @(posedge clk) begin
      rs1_data <= rs1_data_nxt;
   end

   
   // rs2 data+addr
   always_ff @(posedge clk) begin
      rs2_data <= rs2_data_nxt;
   end
   
   
   // rs1 data+addr
   always_ff @(posedge clk)
     rd_addr <= rd_addr_nxt;

   
   // immediate 
   always_ff @(posedge clk)
     immediate <= immediate_nxt;
      
endmodule // Decode

