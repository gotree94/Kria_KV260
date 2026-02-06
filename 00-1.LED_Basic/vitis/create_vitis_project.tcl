#==============================================================================
# KV260 LED Control - Vitis Project Creation Script
#
# Description:
#   Vitis 프로젝트 자동 생성 스크립트
#   - 플랫폼 프로젝트 생성
#   - 애플리케이션 프로젝트 생성
#   - 소스 파일 추가
#
# Usage:
#   Vitis IDE의 XSCT Console에서:
#   cd C:/work/kv260_projects/00.LED_Basic/vitis
#   source create_vitis_project.tcl
#
# Prerequisites:
#   - Vivado에서 생성한 XSA 파일 필요
#   - ../vivado/kv260_led_basic.xsa
#
# Target: Xilinx KRIA KV260
# Tool: Vitis 2022.2
#==============================================================================

#------------------------------------------------------------------------------
# 설정
#------------------------------------------------------------------------------

set project_dir [file dirname [info script]]
set workspace "$project_dir/workspace"
set platform_name "kv260_led_platform"
set app_name "led_control"

# XSA 파일 경로
set xsa_file "$project_dir/../vivado/kv260_led_basic.xsa"

# 소스 디렉토리
set src_dir "$project_dir/src"

#------------------------------------------------------------------------------
# 워크스페이스 설정
#------------------------------------------------------------------------------

puts "=============================================="
puts " Creating Vitis Project for KV260 LED Control"
puts "=============================================="

# 기존 워크스페이스 정리
if {[file exists $workspace]} {
    puts "Removing existing workspace..."
    file delete -force $workspace
}

# 워크스페이스 설정
setws $workspace

#------------------------------------------------------------------------------
# XSA 파일 확인
#------------------------------------------------------------------------------

if {![file exists $xsa_file]} {
    puts ""
    puts "ERROR: XSA file not found!"
    puts "  Expected: $xsa_file"
    puts ""
    puts "Please run Vivado build first:"
    puts "  cd ../vivado"
    puts "  source create_project.tcl"
    puts "  source build_all.tcl"
    puts ""
    return -code error "XSA file not found"
}

puts "XSA file found: $xsa_file"

#------------------------------------------------------------------------------
# 플랫폼 프로젝트 생성
#------------------------------------------------------------------------------

puts ""
puts "Creating platform project..."

platform create -name $platform_name \
    -hw $xsa_file \
    -proc psu_cortexa53_0 \
    -os standalone

# 플랫폼 빌드
platform generate

puts "Platform created successfully."

#------------------------------------------------------------------------------
# 애플리케이션 프로젝트 생성
#------------------------------------------------------------------------------

puts ""
puts "Creating application project..."

# 애플리케이션 생성 (Empty Application)
app create -name $app_name \
    -platform $platform_name \
    -domain standalone_domain \
    -template "Empty Application"

#------------------------------------------------------------------------------
# 소스 파일 추가
#------------------------------------------------------------------------------

puts ""
puts "Adding source files..."

# main.c 복사
set src_file "$src_dir/main.c"
set app_src_dir "$workspace/$app_name/src"

if {[file exists $src_file]} {
    file copy -force $src_file $app_src_dir/
    puts "  Copied: main.c"
} else {
    puts "WARNING: main.c not found in $src_dir"
}

#------------------------------------------------------------------------------
# 빌드 설정
#------------------------------------------------------------------------------

puts ""
puts "Configuring build settings..."

# 최적화 설정
# app config -name $app_name -set build-config Release
# app config -name $app_name -set compiler-optimization "Optimize most (-O3)"

#------------------------------------------------------------------------------
# 프로젝트 빌드
#------------------------------------------------------------------------------

puts ""
puts "Building application..."

app build -name $app_name

#------------------------------------------------------------------------------
# 완료 메시지
#------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Vitis Project Created Successfully!"
puts "=============================================="
puts ""
puts " Workspace: $workspace"
puts " Platform:  $platform_name"
puts " Application: $app_name"
puts ""
puts " Output files:"
puts "   ELF: $workspace/$app_name/Debug/$app_name.elf"
puts ""
puts " Next steps:"
puts "   1. Vivado Hardware Manager에서 FPGA 프로그래밍"
puts "   2. Vitis에서 Run > Run Configurations"
puts "   3. Single Application Debug 선택"
puts "   4. Run 클릭"
puts ""
puts " UART 설정:"
puts "   - Baud Rate: 115200"
puts "   - Data Bits: 8"
puts "   - Parity: None"
puts "   - Stop Bits: 1"
puts "=============================================="
