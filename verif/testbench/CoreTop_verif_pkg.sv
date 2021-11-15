


package CoreTop_verif_pkg;

   parameter HIGH=55;
   parameter LOW=23;
   parameter VERBOSITY=LOW;

   
   task load_instruction_mem;
      input string mem_file;
      input string start_addr;
      $display("time=%0t[ns]: Loading instruction memory from file: %s\n", $time, mem_file);
      $readmemh(mem_file, TaiLung.Memory_inst.instruction_memory.imem_ram, start_addr);
   endtask; // load_instruction_mem

   
   task load_data_mem;
      input string mem_file;
      input string start_addr;
      $display("time=%0t[ns]: Loading data memory from file: %s\n", $time, mem_file);
      $readmemh(mem_file, TaiLung.Memory_inst.data_memory.dmem_ram, start_addr);
   endtask; // load_instruction_mem

   
   task dump_data_memory;
      input string dump_file;
      input string start_addr;
      $display("time=%0t[ns]: dumping data memory from Dmem into file: %s\n", $time, dump_file);
      $writememh(dump_file, TaiLung.Memory_inst.data_memory.dmem_ram, start_addr);
   endtask // dump_data_memory
   
   
   task display_pipeline();
   endtask // display

   
   task start_of_test();
      $display("\n #############################");
      $display(" Starting testbench\n");
   endtask // start_of_test
     
   
   task end_of_test();
      $display("\n #############################");
      $display(" End of testbench\n");
   endtask // end_of_test
   
 
endpackage // CoreTop_verif_pkg
   
