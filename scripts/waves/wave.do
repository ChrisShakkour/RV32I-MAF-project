onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Branch cmp}
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/rs1_data
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/rs2_data
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/enable
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/operation
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/result_masked
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/operand_a
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/operand_b
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/subtraction
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/borrow
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/result
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/a_equals_b
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/a_less_than_b
add wave -noupdate -divider {Cycle counter}
add wave -noupdate -radix hexadecimal /CoreTop_TB/cycle_counter/clk
add wave -noupdate -radix hexadecimal /CoreTop_TB/cycle_counter/rstn
add wave -noupdate -radix hexadecimal /CoreTop_TB/cycle_counter/en
add wave -noupdate -radix hexadecimal /CoreTop_TB/cycle_counter/clear
add wave -noupdate -radix hexadecimal /CoreTop_TB/cycle_counter/overflow
add wave -noupdate -radix hexadecimal /CoreTop_TB/cycle_counter/count_val
add wave -noupdate -radix hexadecimal /CoreTop_TB/cycle_counter/next_value
add wave -noupdate -divider General
add wave -noupdate -radix decimal /CoreTop_TB/cycle_count
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/instruction
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/DataWb
add wave -noupdate -divider Writeback
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/clk
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/wrb_rd_write
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/wrb_rd_data
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/wrb_rd_addr
add wave -noupdate -divider {Data memory interface}
add wave -noupdate -radix hexadecimal /CoreTop_TB/cycle_counter/clk
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/load_store_port/REQ
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/load_store_port/WRITE_EN
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/load_store_port/ADDR_ERR
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/load_store_port/L_UNSIGNED
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/load_store_port/N_BYTES
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/load_store_port/ADDR
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/load_store_port/W_DATA
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/load_store_port/R_DATA
add wave -noupdate -divider {Data memory interface}
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/AluOut
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/AluData
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/pc_pls4
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/rdData
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/dmem_load_data
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/ctrl_reg_wr
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/ctrl_wb_to_rf_sel_in
add wave -noupdate /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/rdData
add wave -noupdate -divider {Data memory interface}
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/clk
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/req
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/write_en
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/l_unsigned
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/n_bytes
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/ADDR_W
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/addr
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/WORD_W
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/addr_err
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/store_data
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/load_data
add wave -noupdate -radix decimal -childformat {{{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[31]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[30]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[29]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[28]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[27]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[26]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[25]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[24]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[23]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[22]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[21]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[20]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[19]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[18]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[17]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[16]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[15]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[14]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[13]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[12]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[11]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[10]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[9]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[8]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[7]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[6]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[5]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[4]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[3]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[2]} -radix decimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[1]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[0]} -radix decimal}} -subitemconfig {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[31]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[30]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[29]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[28]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[27]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[26]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[25]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[24]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[23]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[22]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[21]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[20]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[19]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[18]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[17]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[16]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[15]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[14]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[13]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[12]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[11]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[10]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[9]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[8]} {-radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[7]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[6]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[5]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[4]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[3]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[2]} {-radix decimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[1]} {-radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[0]} {-radix decimal}} /CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5714 ns} 0} {{Cursor 2} {2090 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 468
configure wave -valuecolwidth 45
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {7103 ns} {7276 ns}
