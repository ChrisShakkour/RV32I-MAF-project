module inst_pipe_tracker 
  import instructions_pkg::*;
  import control_pkg::*;
  import memory_pkg::*;
(input clk);

   e_all_inst    inst_tb;
   e_all_inst    inst_tb_exe;
   e_all_inst    inst_tb_mem;
   e_all_inst    inst_tb_wb ;
   logic [31:0] instruction;
   logic [6:0]  opcode;
   logic [2:0]  funct3;
   logic [6:0]  funct7;   
   logic [31:0] immediate_nxt;
   logic [4:0] rs1;   
   logic [4:0] rs2; 
   logic [4:0] rd;

   assign instruction  = CoreTop_TB.TaiLung.Core_inst.Decode_inst.instruction;
   assign opcode       = CoreTop_TB.TaiLung.Core_inst.Decode_inst.instruction[6:0];
   assign funct3       = CoreTop_TB.TaiLung.Core_inst.Decode_inst.instruction[14:12];
   assign funct7       = CoreTop_TB.TaiLung.Core_inst.Decode_inst.instruction[31:25];   
   assign rs1          = instruction[19:15];
   assign rs2          = instruction[24:20];
   assign rd           = instruction[11: 7];

   always_comb
   begin
	if(instruction == 32'h13) begin
	   inst_tb = INS_NOP;
	 end else begin // not NOP op
      unique case(opcode)
	
	//R TYPE
	      
	MUL_AND_INT: begin
	   unique case(funct7)
	     R_NORMAL: begin
		unique case(funct3)		  
		  ADD_SUB : inst_tb = INS_ADD;
		  SLL     : inst_tb = INS_SLL;
		  SLT     : inst_tb = INS_SLT;
		  SLTU    : inst_tb = INS_ADD;
		  XOR     : inst_tb = INS_XOR;
		  SRL_SRA : inst_tb = INS_SRL;		    
		  OR      : inst_tb = INS_OR ;
		  AND     : inst_tb = INS_AND;
		endcase 
	     end 

	     R_SPECIALS: begin
		unique case(funct3)
		  ADD_SUB : inst_tb = INS_SUB;
		  SRL_SRA : inst_tb = INS_SRA;
		  default:;
		endcase 
	     end
	     
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
	     end 
	   endcase 
	end // case: MUL_AND_INT
 	   
	ATOMIC: begin
	end

	
	//I TYPE
	
	LOAD: begin
	   immediate_nxt            = {{20{instruction[31]}},instruction[31:20]};

	   unique case(funct3)
	     LW : inst_tb = INS_LW;
	     LH : inst_tb = INS_LH;
	     LB : inst_tb = INS_LB;
	     LHU: inst_tb = INS_LHU;
	     LBU: inst_tb = INS_LBU;
	     default:;
	   endcase 
	end // case: LOAD
	
	IMM: begin
	   immediate_nxt      = {{20{instruction[31]}},instruction[31:20]};
	   unique case(funct3)
	     ADDI      : inst_tb = INS_ADDI ;
	     SLTI      : inst_tb = INS_SLTI ;
	     SLTIU     : inst_tb = INS_SLTIU;
	     XORI      : inst_tb = INS_XORI ;
	     ORI       : inst_tb = INS_ORI  ;
	     ANDI      : inst_tb = INS_ANDI ;
	     SLLI      : inst_tb = INS_SLLI ;
	     SRLI_SRAI : inst_tb = (funct7==7'b0100000) ? INS_SRAI : INS_SRLI;		   
	   endcase 
	end // case: IMM
	
	JALR: begin
	        inst_tb =  INS_JALR;
		immediate_nxt            = {{20{instruction[31]}},instruction[31:20]};
	end
	
	// U TYPE
	
	LUI: begin
	   	inst_tb =  INS_LUI;
		immediate_nxt = {instruction[31:12],12'b0};
	end

	AUIPC: begin
	   	inst_tb =  INS_AUIPC;
		immediate_nxt = {instruction[31:12],12'b0};
	end
	 	
	
	// J TYPE
	
	JAL: begin
	        inst_tb =  INS_JAL;	   	
		immediate_nxt         = {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0};
	end

	// B TYPE
	
	BRANCH: begin
	   unique case(funct3)
	     BEQ : inst_tb =  INS_BEQ;
	     BNE : inst_tb =  INS_BNE;
	     BGE : inst_tb =  INS_BGE;
	     BLTU: inst_tb =  INS_BLTU;
	     BGEU: inst_tb =  INS_BGEU;
	     default:;
	   endcase     
	end
	 
 	// S TYPE
	
	STORE: begin
	   immediate_nxt       = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
	   unique case(funct3)
	     SW: inst_tb =  INS_SW ;
	     SH: inst_tb =  INS_SH ;
	     SB: inst_tb =  INS_SB ;
	     default: ;
	   endcase 
	end 
	
	default: ;
      endcase // unique case (opcode)

 	end  // not NOP op
   end 
  
   always_ff @(posedge clk) begin
      inst_tb_exe <= inst_tb;
      inst_tb_mem <= inst_tb_exe;
      inst_tb_wb  <= inst_tb_mem;
   end 

   always_comb begin
   $display(" #############################################################");
   $display(" ### Decode  #     Exe     # Load Store # Write back ####");
   $display(" #############################################################");
   $display("    %00000s  #  %s  #  %s  #  %s",inst_tb,inst_tb_exe,inst_tb_mem,inst_tb_wb);  
   $display(" _____________________________________________________________");   
   end  
   
   always_comb begin   
   end

endmodule
