/*
 
 
 
 */

`include "../../../packages/defines.sv"

module Decode
  import instructions_pkg::*;
  (
   input logic                       clk,
   input logic                       rstn,
   input logic [XLEN-1:0]            Instruction,
   input logic [MSB_REG_FILE-1:0]    rd_Ps6,
   input logic                       CtrlWriteEn, //from Ps6
   input logic [XLEN-1:0]            DataRd,      //from Ps6

   output logic [XLEN-1:0]           AluDataIn1,
   output logic [XLEN-1:0]           AluDataIn2,
   output logic [MSB_REG_FILE-1:0]   rd,   
   output logic [INST_WIDTH-1:0]     ir

   );

logic [XLEN-1:0]       rs1_data_out;
logic [XLEN-1:0]       rs2_data_out;
logic [INST_WIDTH-1:0] ir_nxt;
logic [XLEN-1:0]       rs1;
logic [XLEN-1:0]       rs2;
logic [XLEN-1:0]       imm_nxt;
logic [XLEN-1:0]       AluDataIn1_nxt;
logic [XLEN-1:0]       AluDataIn2_nxt;

   // TODO forwarding is disabled 1'b1
   // to be added accordingly
   RegisterFile Reg_file(                 //hazard handled inside reg file   
      .clk             (clk),  
      .rs0_write       (CtrlWriteEn),     
      .rs0_data_in     (DataRd),       
      .rs0_addr        (rd_Ps6),       
      .rs1_read        (1'b1),     
      .rs1_data_out    (rs1_data_out),        
      .rs1_addr        (rs1),         
      .rs1_forward     (1'b0),     
      .rs2_read        (1'b1),        
      .rs2_data_out    (rs2_data_out),        
      .rs2_addr        (rs2),        
      .rs2_forward     (1'b0)
    );


assign AluDataIn1_nxt = rs1_data_out;
assign AluDataIn2_nxt = ir_nxt[4] ? imm_nxt : rs2_data_out; // bit 4 of ir will be the sel of imm/reg mux

// instraction decode
    always_comb begin
	    if (Instruction[6:0] inside `F_OP)			                          //Integer instruction
	    begin
		    ir_nxt[6] = 1'b0;
		    case({Instruction[30],Instruction[25],Instruction[`FUNC3_BITS],Instruction[OPCODE_W-1:0]})
			    {1'b0,1'b0,3'b???,MUL_AND_INT} : ir_nxt[`TYPE_BITS] = R1_TYPE;
			    {1'b1,1'b0,3'b???,MUL_AND_INT} : ir_nxt[`TYPE_BITS] = R2_TYPE;			    
			    {1'b1,1'b?,3'b101,IMM        } : ir_nxt[`TYPE_BITS] = I1_TYPE;
			    {1'b?,1'b?,3'b???,IMM        } : ir_nxt[`TYPE_BITS] = I2_TYPE;			    
		    endcase

		    case(ir_nxt[`TYPE_BITS])
			    R1_TYPE :begin
				     ir_nxt[`ALU_SEL_BITS] = Instruction[`FUNC3_BITS];
				     rd                    = Instruction[`RD_BITS   ];
				     rs1                   = Instruction[`RS1_BITS  ];
				     rs2                   = Instruction[`RS2_BITS  ]; 
			             end
		            R2_TYPE :begin 
				     ir_nxt[`ALU_SEL_BITS] = Instruction[`FUNC3_BITS];       //practically will always be ADD or SRA
 				     rd                    = Instruction[`RD_BITS   ];
				     rs1                   = Instruction[`RS1_BITS  ];
				     rs2                   = Instruction[`RS2_BITS  ]; 
			             end
		            I1_TYPE :begin
			             ir_nxt[`ALU_SEL_BITS] = Instruction[`FUNC3_BITS];
 				     rd                    = Instruction[`RD_BITS   ];
				     rs1                   = Instruction[`RS1_BITS  ];
				     imm_nxt               = $sigend(Instruction[`IMM_BITS  ]); 
                                     end
			    I2_TYPE :begin
			             ir_nxt[`ALU_SEL_BITS] = Instruction[`FUNC3_BITS]; 	     //practically will always be SRA
				     rd                    = Instruction[`RD_BITS   ];
				     rs1                   = Instruction[`RS1_BITS  ];
				     imm_nxt               = $signed(Instruction[`SHAMT_BITS]); 
                                     end
		    endcase

	    end else begin //Flot point instruction
	    	ir_nxt = 7'b1111111;
	    end
    end




//######## REGISTERS ########################

    always_ff @(posedge clk)
	    ir <= ir_nxt;

    always_ff @(posedge clk)
	    AluDataIn1 <= AluDataIn1_nxt;

    always_ff @(posedge clk)
	    AluDataIn2 <= AluDataIn2_nxt;


endmodule // Decode
