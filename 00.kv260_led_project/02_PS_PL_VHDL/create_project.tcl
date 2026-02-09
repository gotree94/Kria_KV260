#==============================================================================
# KV260 LED Project - Create Project TCL (PS+PL - VHDL)
# Vivado 2022.2
#==============================================================================

set project_name "kv260_led_ps_pl"
set project_dir  [file dirname [info script]]
set src_dir      "$project_dir/src"
set part_number  "xck26-sfvc784-2LV-c"

#------------------------------------------------------------------------------
# 1. Create Project
#------------------------------------------------------------------------------
puts "======================================"
puts " Creating Project: $project_name (PS+PL VHDL)"
puts "======================================"

if {[file exists $project_dir/$project_name]} {
    file delete -force $project_dir/$project_name
}

create_project $project_name $project_dir/$project_name -part $part_number
set_property board_part xilinx.com:kv260_som:part0:1.4 [current_project]
set_property target_language VHDL [current_project]

#------------------------------------------------------------------------------
# 2. Add Source Files
#------------------------------------------------------------------------------
puts "Adding source files..."

add_files -norecurse $src_dir/led_top.vhd
# Note: Do NOT use VHDL 2008 - it cannot be used as module reference in Block Design
# set_property file_type {VHDL 2008} [get_files *.vhd]
add_files -fileset constrs_1 -norecurse $src_dir/kv260_led.xdc

#------------------------------------------------------------------------------
# 3. Create Block Design (PS + AXI GPIO)
#------------------------------------------------------------------------------
puts "Creating Block Design..."

create_bd_design "design_1"

# Add Zynq PS
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.4 zynq_ultra_ps_e_0

# Apply board preset
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e \
    -config {apply_board_preset "1"} [get_bd_cells zynq_ultra_ps_e_0]

# Configure PS
set_property -dict [list \
    CONFIG.PSU__USE__M_AXI_GP0 {0} \
    CONFIG.PSU__USE__M_AXI_GP1 {0} \
    CONFIG.PSU__USE__M_AXI_GP2 {1} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
] [get_bd_cells zynq_ultra_ps_e_0]

# Add AXI GPIO for mode control
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {2} \
    CONFIG.C_ALL_OUTPUTS {1} \
] [get_bd_cells axi_gpio_0]

# Add LED module
create_bd_cell -type module -reference led_top led_top_0

# Connect AXI GPIO using automation
apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
    -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD" Clk "Auto"} \
    [get_bd_intf_pins axi_gpio_0/S_AXI]

# Connect clock and reset to LED module
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins led_top_0/clk]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins led_top_0/rst_n]

# Connect GPIO output to LED module sw input
connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins led_top_0/sw]

# Create external port for LED
create_bd_port -dir O -from 7 -to 0 led
connect_bd_net [get_bd_pins led_top_0/led] [get_bd_ports led]

# Assign address
assign_bd_address

# Validate and save
validate_bd_design
regenerate_bd_layout
save_bd_design

#------------------------------------------------------------------------------
# 4. Create Wrapper
#------------------------------------------------------------------------------
puts "Creating HDL wrapper..."

make_wrapper -files [get_files $project_dir/$project_name/$project_name.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $project_dir/$project_name/$project_name.gen/sources_1/bd/design_1/hdl/design_1_wrapper.vhd
set_property top design_1_wrapper [current_fileset]

update_compile_order -fileset sources_1

#------------------------------------------------------------------------------
# 5. Done
#------------------------------------------------------------------------------
puts "======================================"
puts " Project created successfully!"
puts " Next: source build_all.tcl"
puts "======================================"
