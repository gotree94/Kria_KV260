#==============================================================================
# KV260 BRAM AXI ILA Project - Vivado TCL Script
# Vivado Version: 2022.2
# Target Board: Xilinx Kria KV260 Vision AI Starter Kit
# Description: BRAM connected via AXI with ILA for debugging
#==============================================================================

# 프로젝트 설정
set project_name "kv260_bram_ila"
set project_dir  [file dirname [info script]]
set bd_name      "design_1"

# KV260 Part Number (Zynq UltraScale+ MPSoC)
set part_number "xck26-sfvc784-2LV-c"

#------------------------------------------------------------------------------
# 1. 프로젝트 생성
#------------------------------------------------------------------------------
puts "=============================================="
puts "Creating Vivado Project: $project_name"
puts "=============================================="

# 기존 프로젝트 삭제
if {[file exists $project_dir/$project_name]} {
    file delete -force $project_dir/$project_name
}

# 새 프로젝트 생성
create_project $project_name $project_dir/$project_name -part $part_number

# Board 설정 (KV260)
set_property board_part xilinx.com:kv260_som:part0:1.4 [current_project]

#------------------------------------------------------------------------------
# 2. Block Design 생성
#------------------------------------------------------------------------------
puts "Creating Block Design..."

create_bd_design $bd_name

#------------------------------------------------------------------------------
# 3. Zynq UltraScale+ MPSoC 추가 및 설정
#------------------------------------------------------------------------------
puts "Adding Zynq UltraScale+ MPSoC..."

# Zynq MPSoC IP 추가
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.4 zynq_ultra_ps_e_0

# KV260 프리셋 적용
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {
    apply_board_preset "1"
} [get_bd_cells zynq_ultra_ps_e_0]

# PS 설정 - AXI HPM0 LPD 활성화 (Low Power Domain)
set_property -dict [list \
    CONFIG.PSU__USE__M_AXI_GP0 {0} \
    CONFIG.PSU__USE__M_AXI_GP1 {0} \
    CONFIG.PSU__USE__M_AXI_GP2 {1} \
    CONFIG.PSU__FPGA_PL0_ENABLE {1} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
] [get_bd_cells zynq_ultra_ps_e_0]

#------------------------------------------------------------------------------
# 4. AXI BRAM Controller 추가
#------------------------------------------------------------------------------
puts "Adding AXI BRAM Controller..."

# AXI BRAM Controller IP 추가
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0

# BRAM Controller 설정
# - 32bit 데이터 폭
# - 단일 포트 BRAM
# - 8KB 메모리 (2K x 32bit)
set_property -dict [list \
    CONFIG.SINGLE_PORT_BRAM {1} \
    CONFIG.DATA_WIDTH {32} \
    CONFIG.ECC_TYPE {0} \
] [get_bd_cells axi_bram_ctrl_0]

#------------------------------------------------------------------------------
# 5. Block Memory Generator 추가
#------------------------------------------------------------------------------
puts "Adding Block Memory Generator..."

# BRAM IP 추가
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0

# BRAM 설정 - True Dual Port 대신 Single Port 사용
set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Enable_32bit_Address {false} \
    CONFIG.Use_Byte_Write_Enable {true} \
    CONFIG.Byte_Size {8} \
    CONFIG.Write_Width_A {32} \
    CONFIG.Read_Width_A {32} \
    CONFIG.Write_Depth_A {2048} \
    CONFIG.Read_Depth_A {2048} \
    CONFIG.Write_Width_B {32} \
    CONFIG.Read_Width_B {32} \
    CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
    CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
] [get_bd_cells blk_mem_gen_0]

#------------------------------------------------------------------------------
# 6. AXI Interconnect 추가
#------------------------------------------------------------------------------
puts "Adding AXI Interconnect..."

# AXI Interconnect IP 추가
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0

# 1 Master, 1 Slave 설정
set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
] [get_bd_cells axi_interconnect_0]

#------------------------------------------------------------------------------
# 7. Processor System Reset 추가
#------------------------------------------------------------------------------
puts "Adding Processor System Reset..."

create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0

#------------------------------------------------------------------------------
# 8. ILA (Integrated Logic Analyzer) 추가
#------------------------------------------------------------------------------
puts "Adding ILA for AXI debugging..."

# System ILA IP 추가 (AXI 인터페이스 모니터링용)
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0

# ILA 설정
set_property -dict [list \
    CONFIG.C_BRAM_CNT {6} \
    CONFIG.C_NUM_MONITOR_SLOTS {1} \
    CONFIG.C_MON_TYPE {MIX} \
    CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4} \
    CONFIG.C_SLOT_0_AXI_DATA_WIDTH {32} \
    CONFIG.C_SLOT_0_AXI_ADDR_WIDTH {32} \
    CONFIG.C_DATA_DEPTH {4096} \
    CONFIG.C_INPUT_PIPE_STAGES {0} \
] [get_bd_cells system_ila_0]

#------------------------------------------------------------------------------
# 9. 연결 설정
#------------------------------------------------------------------------------
puts "Connecting IPs..."

# 클럭 연결
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins axi_interconnect_0/ACLK]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins axi_interconnect_0/S00_ACLK]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins axi_interconnect_0/M00_ACLK]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins system_ila_0/clk]
# PS AXI Master 클럭 연결 (필수!)
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk]

# 리셋 연결
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] \
    [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] \
    [get_bd_pins axi_interconnect_0/ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
    [get_bd_pins axi_interconnect_0/S00_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
    [get_bd_pins axi_interconnect_0/M00_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
    [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
    [get_bd_pins system_ila_0/resetn]

# AXI 연결 - PS -> Interconnect -> BRAM Controller
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD] \
    [get_bd_intf_pins axi_interconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_interconnect_0/M00_AXI] \
    [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]

# BRAM Controller -> BRAM 연결
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] \
    [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]

# ILA를 BRAM Controller의 AXI 인터페이스에 연결 (모니터링)
connect_bd_intf_net [get_bd_intf_pins axi_interconnect_0/M00_AXI] \
    [get_bd_intf_pins system_ila_0/SLOT_0_AXI]

#------------------------------------------------------------------------------
# 10. 주소 매핑
#------------------------------------------------------------------------------
puts "Assigning addresses..."

# BRAM Controller 주소 할당 (0x8000_0000, 8KB)
assign_bd_address -target_address_space /zynq_ultra_ps_e_0/Data \
    [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
set_property offset 0x80000000 [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_axi_bram_ctrl_0_Mem0}]
set_property range 8K [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_axi_bram_ctrl_0_Mem0}]

#------------------------------------------------------------------------------
# 11. Block Design 검증 및 저장
#------------------------------------------------------------------------------
puts "Validating Block Design..."

# 블록 디자인 검증
validate_bd_design

# 블록 디자인 저장
save_bd_design

#------------------------------------------------------------------------------
# 12. HDL Wrapper 생성
#------------------------------------------------------------------------------
puts "Creating HDL Wrapper..."

make_wrapper -files [get_files $project_dir/$project_name/$project_name.srcs/sources_1/bd/$bd_name/$bd_name.bd] -top
add_files -norecurse $project_dir/$project_name/$project_name.gen/sources_1/bd/$bd_name/hdl/${bd_name}_wrapper.v

#------------------------------------------------------------------------------
# 13. Synthesis 및 Implementation 설정
#------------------------------------------------------------------------------
puts "Setting up Synthesis and Implementation..."

# Synthesis 설정
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]

# Implementation 설정
set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]

#------------------------------------------------------------------------------
# 14. Debug 설정
#------------------------------------------------------------------------------
puts "Setting up Debug..."

# ILA 디버그 코어 활성화
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {axi_interconnect_0_M00_AXI}]

#------------------------------------------------------------------------------
# 15. 합성 및 구현 실행 (선택사항)
#------------------------------------------------------------------------------
puts "=============================================="
puts "Project creation completed!"
puts "=============================================="
puts ""
puts "Next steps:"
puts "1. Run Synthesis: launch_runs synth_1 -jobs 8"
puts "2. Wait: wait_on_run synth_1"
puts "3. Run Implementation: launch_runs impl_1 -to_step write_bitstream -jobs 8"
puts "4. Wait: wait_on_run impl_1"
puts "5. Export Hardware: write_hw_platform -fixed -include_bit -force \\"
puts "   $project_dir/$project_name/${project_name}.xsa"
puts ""
puts "Or run the build_all.tcl script for automated build."
puts "=============================================="

# 프로젝트 정보 출력
puts ""
puts "Project Information:"
puts "- Project Name: $project_name"
puts "- Part: $part_number"
puts "- BRAM Base Address: 0x80000000"
puts "- BRAM Size: 8KB (2048 x 32-bit words)"
puts "- Clock: 100 MHz (PL0)"
puts "=============================================="
