#==============================================================================
# KV260 LED Project - Build All TCL
# Synthesis + Implementation + Bitstream
#==============================================================================

set project_dir [file dirname [info script]]
set project_name "kv260_led_pl_only"

#------------------------------------------------------------------------------
# Open Project
#------------------------------------------------------------------------------
if {[current_project -quiet] eq ""} {
    open_project $project_dir/$project_name/$project_name.xpr
}

#------------------------------------------------------------------------------
# Synthesis
#------------------------------------------------------------------------------
puts "======================================"
puts " Running Synthesis..."
puts "======================================"

reset_run synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1

if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    puts "ERROR: Synthesis failed!"
    return -code error
}
puts "Synthesis completed."

#------------------------------------------------------------------------------
# Implementation
#------------------------------------------------------------------------------
puts "======================================"
puts " Running Implementation..."
puts "======================================"

reset_run impl_1
launch_runs impl_1 -jobs 4
wait_on_run impl_1

if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    puts "ERROR: Implementation failed!"
    return -code error
}
puts "Implementation completed."

#------------------------------------------------------------------------------
# Bitstream
#------------------------------------------------------------------------------
puts "======================================"
puts " Generating Bitstream..."
puts "======================================"

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

# Copy bitstream
set bit_file "$project_dir/$project_name/$project_name.runs/impl_1/design_1_wrapper.bit"
if {[file exists $bit_file]} {
    file copy -force $bit_file $project_dir/
    puts "Bitstream copied to: $project_dir/design_1_wrapper.bit"
}

#------------------------------------------------------------------------------
# Done
#------------------------------------------------------------------------------
puts ""
puts "======================================"
puts " BUILD COMPLETED!"
puts "======================================"
puts " Bitstream: $project_dir/design_1_wrapper.bit"
puts ""
puts " To program FPGA:"
puts "   1. Open Hardware Manager"
puts "   2. Connect to KV260"
puts "   3. Program device with bitstream"
puts "======================================"
