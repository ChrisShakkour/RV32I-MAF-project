onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/clk
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/instruction_in
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/instruction
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc
add wave -noupdate -radix hexadecimal -childformat {{{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[31]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[30]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[29]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[28]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[27]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[26]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[25]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[24]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[23]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[22]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[21]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[20]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[19]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[18]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[17]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[16]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[15]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[14]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[13]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[12]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[11]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[10]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[9]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[8]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[7]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[6]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[5]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[4]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[3]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[2]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[1]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[0]} -radix hexadecimal}} -subitemconfig {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[31]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[30]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[29]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[28]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[27]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[26]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[25]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[24]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[23]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[22]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[21]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[20]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[19]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[18]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[17]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[16]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[15]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[14]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[13]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[12]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[11]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[10]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[9]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[8]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[7]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[6]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[5]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[4]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[3]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[2]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[1]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs[0]} {-height 15 -radix hexadecimal}} /CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/internal_regs
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_write
add wave -noupdate -radix hexadecimal -childformat {{{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[31]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[30]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[29]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[28]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[27]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[26]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[25]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[24]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[23]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[22]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[21]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[20]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[19]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[18]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[17]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[16]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[15]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[14]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[13]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[12]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[11]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[10]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[9]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[8]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[7]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[6]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[5]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[4]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[3]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[2]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[1]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[0]} -radix hexadecimal}} -subitemconfig {{/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[31]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[30]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[29]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[28]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[27]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[26]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[25]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[24]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[23]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[22]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[21]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[20]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[19]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[18]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[17]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[16]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[15]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[14]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[13]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[12]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[11]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[10]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[9]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[8]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[7]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[6]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[5]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[4]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[3]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[2]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[1]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in[0]} {-height 15 -radix hexadecimal}} /CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_data_in
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/Decode_inst/RegisterFile_inst/rs0_addr
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/rdWb
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/EnWb
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/DataWb
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/AluOut
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/AluData
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/pc_pls4
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/WriteBack_Ps6/dmem_load_data
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/clk
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/req
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/write_en
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/l_unsigned
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/n_bytes
add wave -noupdate -radix hexadecimal -childformat {{{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[31]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[30]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[29]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[28]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[27]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[26]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[25]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[24]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[23]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[22]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[21]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[20]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[19]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[18]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[17]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[16]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[15]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[14]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[13]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[12]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[11]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[10]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[9]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[8]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[7]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[6]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[5]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[4]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[3]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[2]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[1]} -radix hexadecimal} {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[0]} -radix hexadecimal}} -subitemconfig {{/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[31]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[30]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[29]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[28]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[27]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[26]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[25]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[24]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[23]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[22]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[21]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[20]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[19]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[18]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[17]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[16]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[15]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[14]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[13]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[12]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[11]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[10]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[9]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[8]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[7]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[6]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[5]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[4]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[3]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[2]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[1]} {-height 15 -radix hexadecimal} {/CoreTop_TB/TaiLung/Memory_inst/data_memory/addr[0]} {-height 15 -radix hexadecimal}} /CoreTop_TB/TaiLung/Memory_inst/data_memory/addr
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/store_data
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/addr_err
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Memory_inst/data_memory/load_data
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/clk
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/rstn
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/first_fetch_trigger
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc_stall_set
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc_stall_count
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/branch_result
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/jump_request
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/calculated_pc
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/inst_request
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/inst_addr
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc_out
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc_pls4_out
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc_select
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc_nxt
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc_pls4
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc_stall
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/fetch_enable
add wave -noupdate -radix hexadecimal /CoreTop_TB/TaiLung/Core_inst/InstructionFetch_inst/pc_enable
add wave -noupdate /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/enable
add wave -noupdate /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/operation
add wave -noupdate /CoreTop_TB/TaiLung/Core_inst/ExecuteOne_Ps3/BranchComparator_inst/result_masked
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1400 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 570
configure wave -valuecolwidth 220
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
WaveRestoreZoom {0 ns} {1920 ns}
