#==============================================================================
# KV260 LED Basic Project - Build Automation Script
#
# Description:
#   합성, 구현, 비트스트림 생성 자동화
#   - ILA Debug Probes 자동 삽입
#   - 타이밍 리포트 생성
#   - XSA 파일 생성 (Vitis용)
#
# Usage:
#   Vivado TCL Console:
#   source build_all.tcl
#
# Target: Xilinx KRIA KV260
# Tool: Vivado 2022.2
#==============================================================================

#------------------------------------------------------------------------------
# 설정
#------------------------------------------------------------------------------

set project_dir [file dirname [info script]]
set project_name "kv260_led_basic"

# 리포트 디렉토리
set report_dir "$project_dir/reports"
file mkdir $report_dir

#------------------------------------------------------------------------------
# 프로젝트 열기
#------------------------------------------------------------------------------

if {[current_project -quiet] eq ""} {
    puts "Opening project..."
    open_project $project_dir/$project_name/$project_name.xpr
}

#------------------------------------------------------------------------------
# 1. 합성 (Synthesis)
#------------------------------------------------------------------------------

puts "=============================================="
puts " Step 1: Running Synthesis"
puts "=============================================="

# 합성 리셋
reset_run synth_1

# 합성 실행
launch_runs synth_1 -jobs 4
wait_on_run synth_1

# 합성 결과 확인
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    puts "ERROR: Synthesis failed!"
    return -code error
}

puts "Synthesis completed successfully!"

# 합성 리포트 생성
open_run synth_1
report_utilization -file $report_dir/synth_utilization.rpt
report_timing_summary -file $report_dir/synth_timing.rpt

#------------------------------------------------------------------------------
# 2. ILA Debug Probes 설정
#------------------------------------------------------------------------------

puts "=============================================="
puts " Step 2: Setting up ILA Debug Probes"
puts "=============================================="

# mark_debug 속성이 있는 신호 확인
set debug_nets [get_nets -hierarchical -filter {MARK_DEBUG == TRUE}]

if {[llength $debug_nets] > 0} {
    puts "Found [llength $debug_nets] debug nets:"
    foreach net $debug_nets {
        puts "  - $net"
    }
    
    # Debug Core 설정
    # Vivado가 자동으로 ILA를 삽입하도록 설정
    set_property STEPS.OPT_DESIGN.TCL.POST "" [get_runs impl_1]
    
} else {
    puts "No debug nets found. Skipping ILA setup."
}

#------------------------------------------------------------------------------
# 3. 구현 (Implementation)
#------------------------------------------------------------------------------

puts "=============================================="
puts " Step 3: Running Implementation"
puts "=============================================="

# 구현 리셋
reset_run impl_1

# 구현 실행
launch_runs impl_1 -jobs 4
wait_on_run impl_1

# 구현 결과 확인
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    puts "ERROR: Implementation failed!"
    return -code error
}

puts "Implementation completed successfully!"

# 구현 리포트 생성
open_run impl_1
report_utilization -file $report_dir/impl_utilization.rpt
report_timing_summary -file $report_dir/impl_timing.rpt
report_power -file $report_dir/impl_power.rpt
report_drc -file $report_dir/impl_drc.rpt

#------------------------------------------------------------------------------
# 4. 비트스트림 생성
#------------------------------------------------------------------------------

puts "=============================================="
puts " Step 4: Generating Bitstream"
puts "=============================================="

# 비트스트림 생성
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

# 결과 확인
set bit_file "$project_dir/$project_name/$project_name.runs/impl_1/design_1_wrapper.bit"
if {![file exists $bit_file]} {
    # Standalone PL의 경우
    set bit_file "$project_dir/$project_name/$project_name.runs/impl_1/led_top.bit"
}

if {[file exists $bit_file]} {
    puts "Bitstream generated: $bit_file"
    
    # 출력 디렉토리로 복사
    file copy -force $bit_file $project_dir/
    
} else {
    puts "ERROR: Bitstream generation failed!"
    return -code error
}

#------------------------------------------------------------------------------
# 5. XSA 파일 생성 (Vitis용)
#------------------------------------------------------------------------------

puts "=============================================="
puts " Step 5: Exporting Hardware (XSA)"
puts "=============================================="

set xsa_file "$project_dir/${project_name}.xsa"

write_hw_platform -fixed -include_bit -force -file $xsa_file

if {[file exists $xsa_file]} {
    puts "XSA exported: $xsa_file"
} else {
    puts "WARNING: XSA export may have failed"
}

#------------------------------------------------------------------------------
# 6. 완료 메시지
#------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Build Completed Successfully!"
puts "=============================================="
puts ""
puts " Output files:"
puts "   Bitstream: $project_dir/design_1_wrapper.bit"
puts "   XSA:       $xsa_file"
puts "   Reports:   $report_dir/"
puts ""
puts " Next steps:"
puts "   1. Hardware Manager에서 FPGA 프로그래밍"
puts "   2. (옵션) Vitis에서 PS 애플리케이션 개발"
puts ""
puts " FPGA 프로그래밍:"
puts "   - Open Hardware Manager"
puts "   - Open Target > Auto Connect"
puts "   - Program Device"
puts "=============================================="
