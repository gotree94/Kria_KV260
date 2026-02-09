#==============================================================================
# KV260 LED Project - Build All TCL (PS+PL version)
# Synthesis + Implementation + Bitstream + XSA Export
#==============================================================================

set project_dir [file dirname [info script]]
set project_name "kv260_led_ps_pl"

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
# Export XSA (for Vitis)
#------------------------------------------------------------------------------
puts "======================================"
puts " Exporting XSA for Vitis..."
puts "======================================"

set xsa_file "$project_dir/${project_name}.xsa"
write_hw_platform -fixed -include_bit -force -file $xsa_file

if {[file exists $xsa_file]} {
    puts "XSA exported: $xsa_file"
} else {
    puts "WARNING: XSA export failed"
}

#------------------------------------------------------------------------------
# Done
#------------------------------------------------------------------------------
puts ""
puts "======================================"
puts " BUILD COMPLETED!"
puts "======================================"
puts " Output files:"
puts "   Bitstream: $project_dir/design_1_wrapper.bit"
puts "   XSA:       $xsa_file"
puts ""
puts " Next steps:"
puts "   1. Go to 03_Vitis_App folder"
puts "   2. Run build.bat to create Vitis project"
puts "======================================"
