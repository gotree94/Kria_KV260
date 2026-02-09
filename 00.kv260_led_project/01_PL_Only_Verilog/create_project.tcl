#==============================================================================
# KV260 LED Project - Create Project TCL (PL Only - Verilog)
# Vivado 2022.2
#==============================================================================

set project_name "kv260_led_pl_only"
set project_dir  [file dirname [info script]]
set src_dir      "$project_dir/src"
set part_number  "xck26-sfvc784-2LV-c"

#------------------------------------------------------------------------------
# 1. Create Project
#------------------------------------------------------------------------------
puts "======================================"
puts " Creating Project: $project_name"
puts "======================================"

if {[file exists $project_dir/$project_name]} {
    file delete -force $project_dir/$project_name
}

create_project $project_name $project_dir/$project_name -part $part_number
set_property board_part xilinx.com:kv260_som:part0:1.4 [current_project]

#------------------------------------------------------------------------------
# 2. Add Source Files
#------------------------------------------------------------------------------
puts "Adding source files..."

add_files -norecurse $src_dir/led_top.v
add_files -fileset constrs_1 -norecurse $src_dir/kv260_led.xdc

#------------------------------------------------------------------------------
# 3. Create Block Design (Minimal PS for clock)
#------------------------------------------------------------------------------
puts "Creating Block Design..."

create_bd_design "design_1"

# Add Zynq PS (minimal config - clock only)
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.4 zynq_ultra_ps_e_0

# Apply board preset
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e \
    -config {apply_board_preset "1"} [get_bd_cells zynq_ultra_ps_e_0]

# Disable unused interfaces
set_property -dict [list \
    CONFIG.PSU__USE__M_AXI_GP0 {0} \
    CONFIG.PSU__USE__M_AXI_GP1 {0} \
    CONFIG.PSU__USE__M_AXI_GP2 {0} \
    CONFIG.PSU__USE__S_AXI_GP0 {0} \
    CONFIG.PSU__USE__S_AXI_GP1 {0} \
    CONFIG.PSU__USE__S_AXI_GP2 {0} \
    CONFIG.PSU__USE__S_AXI_GP3 {0} \
    CONFIG.PSU__USE__S_AXI_GP4 {0} \
    CONFIG.PSU__USE__S_AXI_GP5 {0} \
    CONFIG.PSU__USE__S_AXI_GP6 {0} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
] [get_bd_cells zynq_ultra_ps_e_0]

# Add LED module
create_bd_cell -type module -reference led_top led_top_0

# Connect clock and reset
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins led_top_0/clk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins led_top_0/rst_n]

# Create external port for LED
create_bd_port -dir O -from 7 -to 0 led
connect_bd_net [get_bd_pins led_top_0/led] [get_bd_ports led]

# Validate and save
validate_bd_design
save_bd_design

#------------------------------------------------------------------------------
# 4. Create Wrapper
#------------------------------------------------------------------------------
puts "Creating HDL wrapper..."

make_wrapper -files [get_files $project_dir/$project_name/$project_name.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $project_dir/$project_name/$project_name.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
set_property top design_1_wrapper [current_fileset]

update_compile_order -fileset sources_1

#------------------------------------------------------------------------------
# 5. Done
#------------------------------------------------------------------------------
puts "======================================"
puts " Project created successfully!"
puts " Next: source build_all.tcl"
puts "======================================"
