#==============================================================================
# KV260 LED Basic Project - Vivado TCL Script
#
# Description:
#   LED 기본 제어 프로젝트 자동 생성 스크립트
#   - Verilog 또는 VHDL 선택 가능
#   - ILA 디버그 코어 자동 삽입
#   - PS 연동 Block Design 생성
#
# Usage:
#   Vivado TCL Console:
#   cd C:/work/kv260_projects/00.LED_Basic/vivado
#   source create_project.tcl
#
# Target: Xilinx KRIA KV260 Vision AI Starter Kit
# Tool: Vivado 2022.2
#==============================================================================

#------------------------------------------------------------------------------
# 사용자 설정
#------------------------------------------------------------------------------

# HDL 언어 선택 (verilog 또는 vhdl)
set USE_VHDL 0           ;# 0: Verilog, 1: VHDL

# ILA 코어 삽입 여부
set USE_ILA 1            ;# 0: No ILA, 1: Add ILA

# Block Design 사용 (PS 클럭 및 리셋 사용)
set USE_BLOCK_DESIGN 1   ;# 0: Standalone PL, 1: PS + PL

#------------------------------------------------------------------------------
# 프로젝트 설정
#------------------------------------------------------------------------------

set project_name "kv260_led_basic"
set project_dir  [file dirname [info script]]
set bd_name      "design_1"
set top_name     "led_wrapper"

# KV260 Part Number
set part_number "xck26-sfvc784-2LV-c"

# 소스 디렉토리
set src_dir "$project_dir/../src"
set constraint_dir "$project_dir/constraints"

#------------------------------------------------------------------------------
# 1. 프로젝트 생성
#------------------------------------------------------------------------------

puts "=============================================="
puts " KV260 LED Basic Project"
puts " HDL: [expr {$USE_VHDL ? "VHDL" : "Verilog"}]"
puts " ILA: [expr {$USE_ILA ? "Enabled" : "Disabled"}]"
puts "=============================================="

# 기존 프로젝트 삭제
if {[file exists $project_dir/$project_name]} {
    puts "Removing existing project..."
    file delete -force $project_dir/$project_name
}

# 새 프로젝트 생성
create_project $project_name $project_dir/$project_name -part $part_number

# Board 설정
set_property board_part xilinx.com:kv260_som:part0:1.4 [current_project]

#------------------------------------------------------------------------------
# 2. 소스 파일 추가
#------------------------------------------------------------------------------

puts "Adding source files..."

if {$USE_VHDL} {
    # VHDL 소스 추가
    add_files -norecurse [glob $src_dir/vhdl/*.vhd]
    set_property file_type {VHDL 2008} [get_files *.vhd]
} else {
    # Verilog 소스 추가
    add_files -norecurse [glob $src_dir/verilog/*.v]
}

# 제약 조건 파일 추가
add_files -fileset constrs_1 -norecurse $constraint_dir/kv260_led.xdc

#------------------------------------------------------------------------------
# 3. Block Design 생성 (선택적)
#------------------------------------------------------------------------------

if {$USE_BLOCK_DESIGN} {
    puts "Creating Block Design with Zynq PS..."
    
    create_bd_design $bd_name
    
    # Zynq UltraScale+ MPSoC 추가
    create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.4 zynq_ultra_ps_e_0
    
    # PS 자동 설정
    apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e \
        -config {apply_board_preset "1"} [get_bd_cells zynq_ultra_ps_e_0]
    
    # PL 클럭 활성화 (pl_clk0: 100 MHz)
    set_property -dict [list \
        CONFIG.PSU__USE__M_AXI_GP0 {0} \
        CONFIG.PSU__USE__M_AXI_GP1 {0} \
        CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
        CONFIG.PSU__USE__FABRIC__RST {1} \
    ] [get_bd_cells zynq_ultra_ps_e_0]
    
    # AXI GPIO 추가 (스위치 입력용)
    create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
    set_property -dict [list \
        CONFIG.C_GPIO_WIDTH {2} \
        CONFIG.C_ALL_INPUTS {1} \
    ] [get_bd_cells axi_gpio_0]
    
    # LED RTL 모듈 추가
    if {$USE_VHDL} {
        set rtl_module "led_top"
    } else {
        set rtl_module "led_top"
    }
    
    create_bd_cell -type module -reference $rtl_module led_top_0
    
    # 연결
    # 클럭 연결
    connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
                   [get_bd_pins led_top_0/clk]
    
    # 리셋 연결 (Active-low)
    connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] \
                   [get_bd_pins led_top_0/rst_n]
    
    # AXI Interconnect 자동 연결
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
        -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD" Clk "Auto"} \
        [get_bd_intf_pins axi_gpio_0/S_AXI]
    
    # GPIO를 스위치 입력으로 연결
    connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_i] \
                   [get_bd_pins led_top_0/sw]
    
    # LED 외부 포트 생성
    create_bd_port -dir O -from 7 -to 0 led
    connect_bd_net [get_bd_pins led_top_0/led] [get_bd_ports led]
    
    # 주소 할당
    assign_bd_address
    
    # Block Design 검증
    validate_bd_design
    
    # Wrapper 생성
    make_wrapper -files [get_files $project_dir/$project_name/$project_name.srcs/sources_1/bd/$bd_name/$bd_name.bd] -top
    add_files -norecurse $project_dir/$project_name/$project_name.gen/sources_1/bd/$bd_name/hdl/${bd_name}_wrapper.v
    
    # Top 설정
    set_property top ${bd_name}_wrapper [current_fileset]
    
} else {
    # Standalone PL 설계
    puts "Creating Standalone PL design..."
    
    if {$USE_VHDL} {
        set_property top led_top [current_fileset]
    } else {
        set_property top led_top [current_fileset]
    }
}

#------------------------------------------------------------------------------
# 4. ILA 코어 삽입 (선택적)
#------------------------------------------------------------------------------

if {$USE_ILA} {
    puts "Adding ILA debug core..."
    
    # Synthesis 먼저 실행 (mark_debug 속성 인식)
    # synth_design -rtl -name rtl_1
    
    # 참고: mark_debug 속성이 HDL에 있으므로
    # 합성 후 Debug Hub가 자동으로 생성됨
    
    # 또는 수동으로 ILA 추가:
    # create_debug_core ila_0 ila
    # set_property C_DATA_DEPTH 4096 [get_debug_cores ila_0]
    # set_property C_TRIGIN_EN false [get_debug_cores ila_0]
    # set_property C_TRIGOUT_EN false [get_debug_cores ila_0]
    # set_property C_ADV_TRIGGER false [get_debug_cores ila_0]
    # set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores ila_0]
    # set_property C_EN_STRG_QUAL false [get_debug_cores ila_0]
    # set_property ALL_PROBE_SAME_MU true [get_debug_cores ila_0]
    # set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores ila_0]
    
    puts "ILA will be inserted during implementation (using mark_debug attributes)"
}

#------------------------------------------------------------------------------
# 5. 최종 설정
#------------------------------------------------------------------------------

puts "Finalizing project setup..."

# 업데이트
update_compile_order -fileset sources_1

# Block Design 저장
if {$USE_BLOCK_DESIGN} {
    regenerate_bd_layout
    save_bd_design
}

# 프로젝트 저장
close_project
open_project $project_dir/$project_name/$project_name.xpr

puts "=============================================="
puts " Project created successfully!"
puts " Project: $project_dir/$project_name"
puts ""
puts " Next steps:"
puts " 1. source build_all.tcl  (합성/구현/비트스트림)"
puts " 2. Hardware Manager에서 FPGA 프로그래밍"
puts "=============================================="
