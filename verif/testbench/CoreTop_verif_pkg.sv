


package CoreTop_verif_pkg;

   task load_instruction_mem();
      input string memory_file;
      input string start_addr;
   endtask; // load_instruction_mem

   
   task load_data_mem();
      input string memory_file;
      input string start_addr;
   endtask; // load_instruction_mem

   
   task display();
   endtask // display

   
   task start_of_test();
   endtask // start_of_test
     
   
   task end_of_test();
   endtask // end_of_test
   
 
endpackage // CoreTop_verif_pkg
   
