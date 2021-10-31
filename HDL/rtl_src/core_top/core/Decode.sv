/*
 
 
 
 */

module Decode
  (
   input logic          clk,
   input logic          rstn,
   input t_instruction  InstructionPs2,
   input t_Waddr        Ctrl_rd_Ps6,
   input logic          Ctrl_WriteEn_Ps6,
   input t_xlen         Data_rd_Ps6,

   output t_xlen        Data_in2_Ps3,
   output t_xlen        Data_in1_Ps3,
   output logic [2 :0]  Ctrl_ALU_Ps3,
   output logic [4 :0]  Ctrl_rd_Ps3,
   output logic [4 :0]  Ctrl_func7_Ps3
   //output t_instType    instTypePs3,
   );

   RegisterFile Reg_file(                 //hazard handled inside reg file   
      .clk             (clk),  
      .rs0_write       (Ctrl_WriteEn_Ps6),     
      .rs0_data_in     (Data_rd_Ps6),       
      .rs0_addr        (Ctrl_rd_Ps6),       
      .rs0_addr_error  (), 
      .rs1_read        (rs1_read),     
      .rs1_data_out    (rs1_data_out),        
      .rs1_addr        (rs1_addr),         
      .rs1_addr_error  (),     
      .rs2_read        (rs2_read),        
      .rs2_data_out    (rs2_data_out),        
      .rs2_addr        (rs2_addr),        
      .rs2_addr_error  ()
    );

    // instraction decode
    always_comb begin
    	case(InstructionPs2[OPCODE_W:0])
		e_type_r_instruction    : instTypePs2 = R_TYPE;
		e_type_i_instruction    : instTypePs2 = I_TYPE;
		default                 : instTypePs2 = 1'bx; //TODO defult shuld be NOP
	endcase

	case(instTypePs2)
		I_TYPE :begin
		       	  rd_Ps2            = InstructionPs2[11:7];
			  func3Ps2          = InstructionPs2[14:12];
		       	  rs1_addr          = InstructionPs2[19:15];
			  rs1_read          = 1'b1;                 // TODO check if ok
			  Data_in2          = $signed(InstructionPs2[31:20]);
			  func7_Ps2         = 0;			  			  
			end
		R_TYPE :begin
		       	  rd_Ps2            = InstructionPs2[11:7];
			  func3Ps2          = InstructionPs2[14:12];
		       	  rs1_addr          = InstructionPs2[19:15];
			  rs1_read          = 1'b1;
			  rs2_addr          = InstructionPs2[24:20];
			  rs2_read          = 1'b1;
			  func7_Ps2         = InstructionPs2[31:25]; //TODO not take all 7 bits			  
			end

		//TODO default
	endcase





    end


//######## REGISTERS ########################

    //Immediate OR rs2
    always_ff @(posedge clk or negedge rstn)
	Data_in2_Ps3 <= Data_in2;
     
    //rs1 from reg file 
    always_ff @(posedge clk or negedge rstn)
	Data_in1_Ps3 <= rs1_data_out;

    // 
    always_ff @(posedge clk or negedge rstn)
	Ctrl_ALU_Ps3 <= func3Ps2;

    //Rd 
    always_ff @(posedge clk or negedge rstn)
	Ctrl_rd_Ps3 <= rd_Ps2;

    always_ff @(posedge clk or negedge rstn)
	Ctrl_func7_Ps3 <= func7_Ps2;  

endmodule // Decode
