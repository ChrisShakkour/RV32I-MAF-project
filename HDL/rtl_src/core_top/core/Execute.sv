/*
 
 
 
 */

module Execute 
  (
   input logic          clk,
   input logic          rstn,
   input logic  [11:0]  Date_in2_Ps3,
   input t_xlen         Data_in1_Ps3,
   input logic  [2 :0]  Ctrl_ALU_Ps3, //func3 for now
   input logic  [4 :0]  Ctrl_rd_Ps3,
   
   output logic [6 :0]  Ctrl_func7_Ps4,   
   
);

wire ALU_out;

always_comb begin

	case (Ctrl_ALU_Ps3)
		ADD : ALU_out = (Ctrl_func7_Ps3[5] == 1'b1) ? Data_in1_Ps3 - Date_in2_Ps3 : Data_in1_Ps3 + Date_in2_Ps3;
		SLT : ALU_out = $signed(Data_in1_Ps3) < $signed(Date_in2_Ps3); 
		SLTU: ALU_out = Data_in1_Ps3 <   Date_in2_Ps3 ? 32'd1 : 32'b0; 
		OR  : ALU_out = Data_in1_Ps3 |   Date_in2_Ps3;
		AND : ALU_out = Data_in1_Ps3 &   Date_in2_Ps3;
		XOR : ALU_out = Data_in1_Ps3 ^   Date_in2_Ps3;
		SLL : ALU_out = Data_in1_Ps3 <<  Date_in2_Ps3[4:0];
		SRL : ALU_out = Data_in1_Ps3 >>  Date_in2_Ps3[4:0];
		SRA : ALU_out = Data_in1_Ps3 >>> Date_in2_Ps3;
	endcase // TODO add defult 
end

//######### REGISTERS ##############

always_ff @(posedge clk)
	Date_ALU_out_Ps4 <= ALU_out;



endmodule 
   
