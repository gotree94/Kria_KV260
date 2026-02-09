#==============================================================================
# KV260 LED Control - Vitis Project Creation
# 
# Prerequisites: XSA file from 02_PS_PL_Verilog or 02_PS_PL_VHDL
#==============================================================================

set project_dir [file dirname [info script]]
set workspace   "$project_dir/workspace"
set platform    "kv260_led_platform"
set app_name    "led_control"
set src_dir     "$project_dir/src"

# Find XSA file (check Verilog first, then VHDL)
set xsa_verilog "$project_dir/../02_PS_PL_Verilog/kv260_led_ps_pl.xsa"
set xsa_vhdl    "$project_dir/../02_PS_PL_VHDL/kv260_led_ps_pl.xsa"

if {[file exists $xsa_verilog]} {
    set xsa_file $xsa_verilog
    puts "Using XSA from Verilog project"
} elseif {[file exists $xsa_vhdl]} {
    set xsa_file $xsa_vhdl
    puts "Using XSA from VHDL project"
} else {
    puts ""
    puts "ERROR: XSA file not found!"
    puts ""
    puts "Please build one of these first:"
    puts "  1. 02_PS_PL_Verilog (run build.bat option 1)"
    puts "  2. 02_PS_PL_VHDL (run build.bat option 1)"
    puts ""
    return -code error "XSA not found"
}

#------------------------------------------------------------------------------
# Create Workspace
#------------------------------------------------------------------------------
puts "======================================"
puts " Creating Vitis Project"
puts "======================================"

if {[file exists $workspace]} {
    file delete -force $workspace
}

setws $workspace

#------------------------------------------------------------------------------
# Create Platform
#------------------------------------------------------------------------------
puts "Creating platform..."

platform create -name $platform \
    -hw $xsa_file \
    -proc psu_cortexa53_0 \
    -os standalone

platform generate

#------------------------------------------------------------------------------
# Create Application
#------------------------------------------------------------------------------
puts "Creating application..."

app create -name $app_name \
    -platform $platform \
    -domain standalone_domain \
    -template "Empty Application"

# Copy source file
set app_src "$workspace/$app_name/src"
file copy -force $src_dir/main.c $app_src/

#------------------------------------------------------------------------------
# Build Application
#------------------------------------------------------------------------------
puts "Building application..."

app build -name $app_name

#------------------------------------------------------------------------------
# Done
#------------------------------------------------------------------------------
puts ""
puts "======================================"
puts " Vitis Project Created!"
puts "======================================"
puts ""
puts " Workspace: $workspace"
puts " ELF File:  $workspace/$app_name/Debug/$app_name.elf"
puts ""
puts " To run:"
puts "   1. Program FPGA with bitstream"
puts "   2. Open Vitis IDE"
puts "   3. Run -> Run Configurations"
puts "   4. Select $app_name"
puts ""
puts " UART: 115200 baud, 8N1"
puts "======================================"
