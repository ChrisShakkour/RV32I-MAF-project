module ForwardingUnit
  import instructions_pkg::*;
   import control_pkg::*;
   import memory_pkg::*;
   (
   input logic                    clk,
   input logic [MSB_REG_FILE-1:0] rs1,
   input logic [MSB_REG_FILE-1:0] rs2,
   input logic [MSB_REG_FILE-1:0] rd ,
   input logic                    rd_wr,
    
   output e_data_hazard            aluin1_hazard_sel,
   output e_data_hazard            aluin2_hazard_sel

   );

   logic [MSB_REG_FILE-1:0] rd_s1;
   logic [MSB_REG_FILE-1:0] rd_s2;
   logic                    rd_wr_s1;
   logic                    rd_wr_s2;

   always_comb begin
	if(rs1 == 0)
          aluin1_hazard_sel = NO_HAZARD;		
   	else if((rs1 == rd_s1) & rd_wr_s1)
	  aluin1_hazard_sel = FROM_EXE;
        else if ((rs1 == rd_s2) & rd_wr_s2)
	  aluin1_hazard_sel = FROM_LS;
        else
          aluin1_hazard_sel = NO_HAZARD;
   end   

   always_comb begin
	if(rs2 == 0)
          aluin2_hazard_sel = NO_HAZARD;			   
   	else if((rs2 == rd_s1) & rd_wr_s1)
	  aluin2_hazard_sel = FROM_EXE;
        else if ((rs2 == rd_s2) & rd_wr_s2)
	  aluin2_hazard_sel = FROM_LS;
        else
          aluin2_hazard_sel = NO_HAZARD;
   end   

   always_ff @(posedge clk) begin
   	rd_s1 <= rd;
	rd_s2 <= rd_s1;
	rd_wr_s1 <= rd_wr;
	rd_wr_s2 <= rd_wr_s1;
   end

  endmodule
