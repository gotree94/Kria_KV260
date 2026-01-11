#==============================================================================
# KV260 BRAM AXI ILA Project - Build All Script
# Vivado Version: 2022.2
# Description: Automated synthesis, implementation, and bitstream generation
#==============================================================================

set project_name "kv260_bram_ila"
set project_dir  [file dirname [info script]]

#------------------------------------------------------------------------------
# 프로젝트 열기
#------------------------------------------------------------------------------
puts "Opening project..."
open_project $project_dir/$project_name/$project_name.xpr

#------------------------------------------------------------------------------
# Synthesis 실행
#------------------------------------------------------------------------------
puts "=============================================="
puts "Running Synthesis..."
puts "=============================================="

reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

# Synthesis 결과 확인
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    puts "ERROR: Synthesis failed!"
    exit 1
}
puts "Synthesis completed successfully!"

#------------------------------------------------------------------------------
# Implementation 실행
#------------------------------------------------------------------------------
puts "=============================================="
puts "Running Implementation..."
puts "=============================================="

launch_runs impl_1 -jobs 8
wait_on_run impl_1

# Implementation 결과 확인
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    puts "ERROR: Implementation failed!"
    exit 1
}
puts "Implementation completed successfully!"

#------------------------------------------------------------------------------
# Bitstream 생성
#------------------------------------------------------------------------------
puts "=============================================="
puts "Generating Bitstream..."
puts "=============================================="

launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

puts "Bitstream generation completed!"

#------------------------------------------------------------------------------
# Hardware Export (XSA 파일 생성)
#------------------------------------------------------------------------------
puts "=============================================="
puts "Exporting Hardware Platform (XSA)..."
puts "=============================================="

# XSA 파일 경로
set xsa_file "$project_dir/$project_name/${project_name}.xsa"

# 이전 XSA 파일 삭제
if {[file exists $xsa_file]} {
    file delete -force $xsa_file
}

# Implementation 결과 열기
open_run impl_1

# XSA 파일 생성 (bitstream 포함)
write_hw_platform -fixed -include_bit -force $xsa_file

puts "Hardware platform exported to: $xsa_file"

#------------------------------------------------------------------------------
# ILA 프로브 파일 생성
#------------------------------------------------------------------------------
puts "=============================================="
puts "Generating Debug Probes File..."
puts "=============================================="

set ltx_file "$project_dir/$project_name/${project_name}.ltx"
write_debug_probes -force $ltx_file

puts "Debug probes file: $ltx_file"

#------------------------------------------------------------------------------
# 빌드 완료
#------------------------------------------------------------------------------
puts "=============================================="
puts "BUILD COMPLETED SUCCESSFULLY!"
puts "=============================================="
puts ""
puts "Generated files:"
puts "- XSA: $xsa_file"
puts "- LTX: $ltx_file"
puts "- Bitstream: $project_dir/$project_name/$project_name.runs/impl_1/design_1_wrapper.bit"
puts ""
puts "Next steps:"
puts "1. Open Vitis: vitis -workspace ./vitis_workspace"
puts "2. Create Platform Project from XSA"
puts "3. Create Application Project"
puts "4. Program FPGA and debug with ILA"
puts "=============================================="
