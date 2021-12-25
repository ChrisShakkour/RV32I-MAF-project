/*
 fch_ - fetch
 dec_ - decode
 exe_ - execute
 lst_ - load-store 
 wrb_ - write back
 
 input control signals with "_in"
 output native clean.
 */
module Core
  import instructions_pkg::*;
   import control_pkg::*;
   import memory_pkg::*;
  (
   // inputs
   input logic clk,
   input logic rstn,
   
   input logic first_fetch_trigger,
   // mem interface
   mem_read_only.core_side inst_fetch_port,
   mem_read_write.core_side load_store_port
   );
   
   logic [MSB_REG_FILE-1:0] rdWb;
   logic                    EnWb; 
   logic [XLEN-1:0] 	    DataWb;
   logic [MSB_REG_FILE-1:0] rd_addr_ps3;
   logic [XLEN-1:0] 	    AluOut; 
   logic [MSB_REG_FILE-1:0] rd_Ps5;
   logic [XLEN-1:0] 	    AluOut_Ps6; 
   logic [MSB_REG_FILE-1:0] rd_Ps6;
   logic [XLEN-1:0] 	    pc_ps2;
   logic [XLEN-1:0] 	    pc_ps3;
   logic [XLEN-1:0] 	    pc_pls4_ps2;
   logic [XLEN-1:0] 	    pc_pls4_ps3;
   logic [XLEN-1:0] 	    pc_pls4_ps5;
   logic [XLEN-1:0] 	    pc_pls4_ps6; 
   logic                    sel_next_pc_ps3;
   logic                    sel_next_pc_ps5;
   logic                    sel_next_pc_ps6; 
   logic                    ctrl_lui_inst_ps3;
   logic                    ctrl_mem_wr_ps3;
   logic                    ctrl_reg_wr_ps3;
   logic [1:0] 		    ctrl_mem_size_ps3;
   
   logic [XLEN-1:0] 	    rs2_data_ps3;
   logic [XLEN-1:0] 	    rs1_data_ps3;
   logic [XLEN-1:0] 	    aluin_1_post;
   logic [XLEN-1:0] 	    aluin_2_post;
   
   logic                    ctrl_mem_wr_ps5;
   logic                    ctrl_reg_wr_ps5;
   logic [1:0] 		    ctrl_mem_size_ps5;
   logic [XLEN-1:0] 	    rs2_data_ps5;
   logic                    ctrl_reg_wr_ps6;

   logic [MSB_REG_FILE-1:0] rs1_addr;
   logic [MSB_REG_FILE-1:0] rs2_addr;

   ///////////////////////////////
   /*data memory control signals*/
   ///////////////////////////////   
   // out of decode stage into Execution stage
   logic 		    dec_ctrl_dmem_req;
   logic 		    dec_ctrl_dmem_write;   
   logic 		    dec_ctrl_dmem_l_unsigned;
   logic [1:0] 		    dec_ctrl_dmem_n_bytes;
   // out of Excecution into writeback
   logic 		    exe_ctrl_dmem_req;
   logic 		    exe_ctrl_dmem_write;   
   logic 		    exe_ctrl_dmem_l_unsigned;
   logic [1:0] 		    exe_ctrl_dmem_n_bytes;
   logic [MEM_WORD_WIDTH-1:0] dmem_load_data;
   
   
   // ALU control signals
   e_alu_operation_sel ctrl_alu_op_sel;
   e_alu_operand_a_sel ctrl_alu_a_sel;
   e_alu_operand_b_sel ctrl_alu_b_sel;

   // regfile writeback mux select
   e_regfile_wb_sel dec_ctrl_wb_to_rf_sel;
   e_regfile_wb_sel exe_ctrl_wb_to_rf_sel;
   e_regfile_wb_sel lst_ctrl_wb_to_rf_sel;
   
   // JALR set lsb bit to Zero
   logic 		    set_alu_lsb_bit_zero;

   // exe input data
   logic [XLEN-1:0] 	    immediate;

   
   // Instruction memory signals
   logic 		   inst_request;
   logic [XLEN-1:0] 	   inst_req_addr;
   logic 		   inst_addr_error;
   logic [XLEN-1:0] 	   instruction;   
   
   		    
/*//////////////////////////////////////////////
    ___            _     ___      _        _    
   |_ _| _ _   ___| |_  | __|___ | |_  __ | |_  
    | | | ' \ (_-<|  _| | _|/ -_)|  _|/ _|| ' \ 
   |___||_||_|/__/ \__| |_| \___| \__|\__||_||_|
 
   Pipe stage #1
 *//////////////////////////////////////////////
    
   InstructionFetch 
     InstructionFetch_inst
       (
	.clk           (clk),
	.rstn          (rstn),
	
	// cpu GO signal.
	.pc_stall(1'b0),
	.first_fetch_trigger(first_fetch_trigger),
	
	// going to instruction memory
	.inst_request  (inst_request),
	.pc            (inst_req_addr),
	
	// to Decode stage
	.pc_out        (pc_ps2),
	.pc_pls4_out   (pc_pls4_ps2),
	
	// comming from Write back stage
	.sel_next_pc   (sel_next_pc_ps6),
	.alu_pc        (AluOut_Ps6)
        );
   
   assign inst_fetch_port.REQ  = inst_request;
   assign inst_fetch_port.ADDR = inst_req_addr;

   
/*/////////////////////////////////////////////////////
   ___            _     ___                    _      
  |_ _| _ _   ___| |_  |   \  ___  __  ___  __| | ___ 
   | | | ' \ (_-<|  _| | |) |/ -_)/ _|/ _ \/ _` |/ -_)
  |___||_||_|/__/ \__| |___/ \___|\__|\___/\__,_|\___|
 
  Pipe stage #2
 */////////////////////////////////////////////////////
   
   Decode
     Decode_inst
       (
	.clk               (clk),
	.rstn              (rstn),
	// comming from inst Fetch
	.instruction_in    (instruction),
	.pc_in             (pc_ps2),
	.pc_pls4_in        (pc_pls4_ps2),	 
	// comming from pipestage 6
	// Write Back signals, addr,
	// data, and write enable
	.wrb_rd_write      (EnWb),        //from ps6
	.wrb_rd_addr       (rdWb),        //from ps6
	.wrb_rd_data       (DataWb),      //from ps6
	// signals to Execute stage
        .pc                (pc_ps3),
	.pc_pls4           (pc_pls4_ps3),
	.rs1_data          (rs1_data_ps3),
	.rs2_data          (rs2_data_ps3),
	.rd_addr           (rd_addr_ps3),
	.immediate         (immediate),
	// alu control select to exe stage
	.ctrl_alu_op_sel      (ctrl_alu_op_sel),
	.ctrl_alu_a_sel       (ctrl_alu_a_sel),
	.ctrl_alu_b_sel       (ctrl_alu_b_sel),
	//write back rf mux sel
	.ctrl_wb_to_rf_sel    (dec_ctrl_wb_to_rf_sel),
	// JALR sel last bit to zero
	.set_alu_lsb_bit_zero (set_alu_lsb_bit_zero),
	// write back control signals
	.sel_next_pc_out   (sel_next_pc_ps3),
        .ctrl_lui_inst     (ctrl_lui_inst_ps3),
        .ctrl_reg_wr       (ctrl_reg_wr_ps3),
	// data memory control signals
	.ctrl_dmem_req        (dec_ctrl_dmem_req),
	.ctrl_dmem_write      (dec_ctrl_dmem_write),   
	.ctrl_dmem_l_unsigned (dec_ctrl_dmem_l_unsigned),
	.ctrl_dmem_n_bytes    (dec_ctrl_dmem_n_bytes),

	.rs1_addr  (rs1_addr),
	.rs2_addr  (rs2_addr)
	);

   // instruction comming from memory
   // and addr error signal in case of
   // unvalid address requested
   assign instruction     = inst_fetch_port.DATA;
   assign inst_addr_error = inst_fetch_port.ADDR_ERR;

			
/*/////////////////////////////////////////////////////////
   ___            _     ___                      _        
  |_ _| _ _   ___| |_  | __|__ __ ___  __  _  _ | |_  ___ 
   | | | ' \ (_-<|  _| | _| \ \ // -_)/ _|| || ||  _|/ -_)
  |___||_||_|/__/ \__| |___|/_\_\\___|\__| \_,_| \__|\___|
                                                          
  Pipe stage #3+4 
 */////////////////////////////////////////////////////////

   
   Execute
     ExecuteOne_Ps3
       (
	.clk                  (clk),
	.rstn                 (rstn),        
	.sel_next_pc          (sel_next_pc_ps3),
	.ctrl_lui_inst        (ctrl_lui_inst_ps3),
        .ctrl_reg_wr          (ctrl_reg_wr_ps3),  
	// comming from decode stage
	.pc                   (pc_ps3),   	
	.pc_pls4              (pc_pls4_ps3),
	.rs1_data             (aluin_1_post),
	.rs2_data             (aluin_2_post),
	.rd_addr              (rd_addr_ps3),   
	.immediate            (immediate),
	// alu control select
	.ctrl_alu_op_sel      (ctrl_alu_op_sel),
	.ctrl_alu_a_sel       (ctrl_alu_a_sel),
	.ctrl_alu_b_sel       (ctrl_alu_b_sel),
	//
	.ctrl_wb_to_rf_sel_in (dec_ctrl_wb_to_rf_sel),
	.ctrl_wb_to_rf_sel    (exe_ctrl_wb_to_rf_sel),
	//
	.set_alu_lsb_bit_zero (set_alu_lsb_bit_zero),
        //
	//
	//
	.AluOut               (AluOut),
        .rdOut                (rd_Ps5),
	.sel_next_pc_out      (sel_next_pc_ps5),
	.pc_pls4_out          (pc_pls4_ps5),
        .ctrl_reg_wr_out      (ctrl_reg_wr_ps5),  
        .rs2_data_out         (rs2_data_ps5),
	/*data memory control signals*/
	// in from decode stage
	.ctrl_dmem_req_in        (dec_ctrl_dmem_req),
	.ctrl_dmem_write_in      (dec_ctrl_dmem_write),   
	.ctrl_dmem_l_unsigned_in (dec_ctrl_dmem_l_unsigned),
	.ctrl_dmem_n_bytes_in    (dec_ctrl_dmem_n_bytes),
	// out to load-store stage
	.ctrl_dmem_req           (exe_ctrl_dmem_req),
	.ctrl_dmem_write         (exe_ctrl_dmem_write),   
	.ctrl_dmem_l_unsigned    (exe_ctrl_dmem_l_unsigned),
	.ctrl_dmem_n_bytes       (exe_ctrl_dmem_n_bytes)
	);


/*//////////////////////////////////////////////////////////////////////
   ___            _     _                   _  ___  _                  
  |_ _| _ _   ___| |_  | |    ___  __ _  __| |/ __|| |_  ___  _ _  ___ 
   | | | ' \ (_-<|  _| | |__ / _ \/ _` |/ _` |\__ \|  _|/ _ \| '_|/ -_)
  |___||_||_|/__/ \__| |____|\___/\__,_|\__,_||___/ \__|\___/|_|  \___|
                                                                       
  Pipe stage #5
 *//////////////////////////////////////////////////////////////////////

   LoadStore
     LoadStore_Ps5
       (
	.clk               (clk),
	.rstn              (rstn),
	// data memory port
	.load_store_port   (load_store_port),
	.AluData           (AluOut),
   	.rd                (rd_Ps5),   
	.sel_next_pc       (sel_next_pc_ps5),	 
	.pc_pls4           (pc_pls4_ps5),
        .ctrl_reg_wr       (ctrl_reg_wr_ps5),  
        .rs2_data          (rs2_data_ps5),	 	 
   	.AluOut            (AluOut_Ps6),
   	.rdOut             (rd_Ps6),
	.sel_next_pc_out   (sel_next_pc_ps6),
	.pc_pls4_out       (pc_pls4_ps6),
        .ctrl_reg_wr_out   (ctrl_reg_wr_ps6), 
	//
	.ctrl_wb_to_rf_sel_in (exe_ctrl_wb_to_rf_sel),
	.ctrl_wb_to_rf_sel    (lst_ctrl_wb_to_rf_sel),
	//
	.ctrl_dmem_req_in        (exe_ctrl_dmem_req),
	.ctrl_dmem_write_in      (exe_ctrl_dmem_write),   
	.ctrl_dmem_l_unsigned_in (exe_ctrl_dmem_l_unsigned),
	.ctrl_dmem_n_bytes_in    (exe_ctrl_dmem_n_bytes),
	.dmem_load_data          (dmem_load_data)
	);
   
   
/*/////////////////////////////////////////////////////////////////////
   ___            _    __      __     _  _         ___            _   
  |_ _| _ _   ___| |_  \ \    / /_ _ (_)| |_  ___ | _ ) __ _  __ | |__
   | | | ' \ (_-<|  _|  \ \/\/ /| '_|| ||  _|/ -_)| _ \/ _` |/ _|| / /
  |___||_||_|/__/ \__|   \_/\_/ |_|  |_| \__|\___||___/\__,_|\__||_\_\
                                                                      
  Pipe stage #6
 */////////////////////////////////////////////////////////////////////
   
   WriteBack
     WriteBack_Ps6
       (
	.clk                  (clk),
	.rstn                 (rstn),
        //
	.AluData              (AluOut_Ps6),
        .rd                   (rd_Ps6),
	.sel_next_pc          (sel_next_pc_ps6),	 
	.pc_pls4              (pc_pls4_ps6),	
        .ctrl_reg_wr          (ctrl_reg_wr_ps6),  	 
        .rdData               (DataWb),
        .rdOut                (rdWb),
	.writeEn              (EnWb),
	//
	.dmem_load_data       (dmem_load_data),
	.ctrl_wb_to_rf_sel_in (lst_ctrl_wb_to_rf_sel)

	);
   


	Forwarding_unit
	  i_forwarding_unit
	  (
	     .clk	          (clk),
             .rs1_addr            (rs1_addr),
             .rs2_addr            (rs2_addr ),
             .rd_Ps5              (rd_Ps5),
             .rs2_data_ps3        (rs2_data_ps3),
             .rs1_data_ps3        (rs1_data_ps3),
             .AluOut              (AluOut),
             .rd_Ps6              (rd_Ps6),
             .DataWb              (DataWb),
                                                   
             .aluin_1_post        (aluin_1_post),
             .aluin_2_post        (aluin_2_post)
	  );



	
endmodule // Core
