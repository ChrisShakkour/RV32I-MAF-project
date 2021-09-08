/*
 
 
 
 */


`timescale 1ps/1ps


module RegisterFile_TB ();

   parameter integer N_REGS=32;
   parameter integer R_WIDTH=32;
   localparam integer W_ADDR=$clog2(N_REGS);
   localparam integer HALF_CLK=5;
   localparam integer PERIOD=2*HALF_CLK;
   
   
   logic 	      clk;
   logic 	      clk_en;
   // Port 0 Write only:
   logic               rs0_write;
   logic [R_WIDTH-1:0] rs0_data_in;
   logic [W_ADDR-1:0]  rs0_addr;
   logic               rs0_addr_error;   
   // Port 1 Read only:
   logic               rs1_read;
   logic [R_WIDTH-1:0] rs1_data_out;
   logic [W_ADDR-1:0]  rs1_addr;
   logic 	       rs1_addr_error;
   // Port 2 Read only:
   logic 	       rs2_read;
   logic [R_WIDTH-1:0] rs2_data_out;
   logic [W_ADDR-1:0]  rs2_addr;
   logic 	       rs2_addr_error;

   
   RegisterFile #
     (.N_REGS(N_REGS),
      .R_WIDTH(R_WIDTH))
   DUT_RegisterFile
     (
      .clk            (clk),
      // Port 0 Write only:
      .rs0_write      (rs0_write),
      .rs0_data_in    (rs0_data_in),
      .rs0_addr       (rs0_addr),
      .rs0_addr_error (rs0_addr_error),
      // Port 1 Read only:
      .rs1_read       (rs1_read),
      .rs1_data_out   (rs1_data_out),
      .rs1_addr       (rs1_addr),
      .rs1_addr_error (rs1_addr_error),
      // Port 2 Read only:
      .rs2_read       (rs2_read),
      .rs2_data_out   (rs2_data_out),
      .rs2_addr       (rs2_addr),
      .rs2_addr_error (rs2_addr_error)
      );

   always #(HALF_CLK) clk = (clk_en) ? ~clk : clk;

   task reset();
      //
   endtask

   task init();
      clk=1;
      clk_en=0;
      
      rs0_write=0;
      rs0_data_in='0;
      rs0_addr='0;
      
      rs1_read=0;
      rs1_addr='0;
      
      rs2_read=0;
      rs2_addr='0;
   endtask

   task read_port1;
      input read;
      input [W_ADDR-1:0] addr;
      rs1_read=read;
      rs1_addr=addr;
   endtask // read_port1
   
   task read_port2;
      input read;
      input [W_ADDR-1:0] addr;
      rs2_read=read;
      rs2_addr=addr;
   endtask // read_port2
      
   task write_port0;
      input write;
      input [W_ADDR-1:0] addr;
      input [R_WIDTH-1:0] data;
      rs0_write=write;
      rs0_addr=addr;
      rs0_data_in=data;
   endtask // write_port0
      
   task set_rf_zeros();
      for(int i=0; i< N_REGS; i++) begin
	 write_port0(1'b1, i, '0);
	 #PERIOD;
      end
      rs0_write=0;
   endtask // set_rf_zeros
      
   task fill_rf;
      input [R_WIDTH-1:0] data;
      for(int i=0; i< N_REGS; i++) begin
	 write_port0(1'b1, i, data);
	 #PERIOD;
      end
      rs0_write=0;
   endtask // fill_rf

   task rf_read;
      input port;
      for(int i=0; i<N_REGS; i++) begin
	 if(port==1)
	   read_port1(1'b1, i);
	 else
	   read_port2(1'b1, i);
	 #PERIOD;
      end
      rs1_read=0;
      rs2_read=0;
   endtask // rf_read
   
      
   initial begin
      #(4*PERIOD) init();
      #(4*PERIOD);
      clk_en=1;
      set_rf_zeros();
      #(4*PERIOD) fill_rf(32'hDEADBEEF);
      #(4*PERIOD) rf_read(1);
      #(4*PERIOD) rf_read(2);
      #(4*PERIOD) $finish;
   end
   
endmodule // RegisterFile_TB
      
   
