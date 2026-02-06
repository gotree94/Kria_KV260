#==============================================================================
# KV260 LED Basic Project - XDC Constraints File
#
# Description:
#   KV260 캐리어 보드 PMOD 커넥터 핀 할당
#   - PMOD J2 커넥터 사용 (8핀)
#   - 외부 LED 모듈 연결용
#
# Target: Xilinx KRIA KV260 Vision AI Starter Kit
# Tool: Vivado 2022.2
#==============================================================================

#------------------------------------------------------------------------------
# 클럭 제약 조건
#------------------------------------------------------------------------------

# PL 클럭 (PS에서 공급, 100 MHz 기본값)
# Block Design에서 Zynq PS를 사용하는 경우 자동 생성됨
# Standalone PL 설계시 아래 제약 사용

# 외부 클럭 소스가 없으므로 PS 클럭 사용
# create_clock -period 10.000 -name clk [get_ports clk]

#------------------------------------------------------------------------------
# PMOD J2 커넥터 (LED 출력)
#------------------------------------------------------------------------------

# PMOD J2 핀 배치 (KV260 캐리어 보드 기준)
# 참고: KV260 User Guide (UG1089) 참조

# PMOD J2 Upper Row (핀 1-4)
set_property PACKAGE_PIN H12 [get_ports {led[0]}]
set_property PACKAGE_PIN E10 [get_ports {led[1]}]
set_property PACKAGE_PIN D10 [get_ports {led[2]}]
set_property PACKAGE_PIN C11 [get_ports {led[3]}]

# PMOD J2 Lower Row (핀 7-10)
set_property PACKAGE_PIN B10 [get_ports {led[4]}]
set_property PACKAGE_PIN E12 [get_ports {led[5]}]
set_property PACKAGE_PIN D11 [get_ports {led[6]}]
set_property PACKAGE_PIN B11 [get_ports {led[7]}]

# IOSTANDARD 설정 (3.3V LVCMOS)
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# 출력 드라이브 강도
set_property DRIVE 12 [get_ports {led[*]}]

# 슬루율
set_property SLEW SLOW [get_ports {led[*]}]

#------------------------------------------------------------------------------
# 모드 선택 스위치 (PMOD J5 사용 - 옵션)
#------------------------------------------------------------------------------

# PMOD J5 Upper Row (핀 1-2)를 스위치 입력으로 사용
# 실제 보드에 스위치가 없으면 Vitis/PS에서 GPIO로 제어
# 또는 점퍼 와이어로 GND/VCC 연결

# set_property PACKAGE_PIN J11 [get_ports {sw[0]}]
# set_property PACKAGE_PIN J10 [get_ports {sw[1]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]
# set_property PULLDOWN true [get_ports {sw[*]}]

#------------------------------------------------------------------------------
# 리셋 (옵션 - PS GPIO 또는 외부 버튼 사용)
#------------------------------------------------------------------------------

# PS GPIO를 리셋으로 사용하는 경우 Block Design에서 연결
# 외부 리셋 버튼 사용시 아래 제약 활성화

# set_property PACKAGE_PIN K12 [get_ports rst_n]
# set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
# set_property PULLUP true [get_ports rst_n]

#------------------------------------------------------------------------------
# ILA 디버깅 제약 (옵션)
#------------------------------------------------------------------------------

# ILA 코어 사용시 Vivado에서 자동으로 제약 생성
# 수동 설정이 필요한 경우 아래 사용

# Debug Hub 클럭
# set_property C_CLK_INPUT_FREQ_HZ 100000000 [get_debug_cores dbg_hub]
# set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]

#------------------------------------------------------------------------------
# 타이밍 제약 (Standalone PL 설계용)
#------------------------------------------------------------------------------

# 입력 지연 (스위치)
# set_input_delay -clock clk -max 2.0 [get_ports {sw[*]}]
# set_input_delay -clock clk -min 0.5 [get_ports {sw[*]}]

# 출력 지연 (LED)
# set_output_delay -clock clk -max 1.0 [get_ports {led[*]}]
# set_output_delay -clock clk -min 0.2 [get_ports {led[*]}]

#------------------------------------------------------------------------------
# 물리적 제약 (옵션)
#------------------------------------------------------------------------------

# Pblock for LED logic (특정 영역에 배치)
# create_pblock pblock_led
# resize_pblock pblock_led -add {SLICE_X0Y0:SLICE_X10Y10}
# add_cells_to_pblock pblock_led [get_cells -hierarchical -filter {NAME =~ *led*}]

#------------------------------------------------------------------------------
# 비트스트림 설정
#------------------------------------------------------------------------------

# 압축 활성화
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

# 설정 전압
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

#------------------------------------------------------------------------------
# 디버그용 주석
#------------------------------------------------------------------------------

# KV260 PMOD 커넥터 J2 핀아웃:
#
#   ┌─────────────────────────────┐
#   │  J2 PMOD Connector (Top)    │
#   ├─────────────────────────────┤
#   │  Pin 6 (VCC)    Pin 5 (GND) │
#   │  Pin 4 (D11)    Pin 3 (D10) │  ← led[3:2]
#   │  Pin 2 (E10)    Pin 1 (H12) │  ← led[1:0]
#   ├─────────────────────────────┤
#   │  Pin 12 (VCC)   Pin 11 (GND)│
#   │  Pin 10 (B11)   Pin 9 (D11) │  ← led[7:6]
#   │  Pin 8 (E12)    Pin 7 (B10) │  ← led[5:4]
#   └─────────────────────────────┘

#==============================================================================
# End of Constraints File
#==============================================================================
