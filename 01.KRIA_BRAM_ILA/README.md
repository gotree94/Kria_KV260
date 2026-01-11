# KV260 BRAM AXI ILA 테스트 프로젝트

## 📋 개요

이 프로젝트는 Xilinx Kria KV260 Vision AI Starter Kit에서 AXI BRAM Controller를 사용하여 BRAM에 데이터를 읽고 쓰는 테스트 애플리케이션입니다. System ILA를 통해 AXI 버스 트랜잭션을 실시간으로 디버깅할 수 있습니다.

## 🎯 주요 기능

- **BRAM 쓰기 테스트**
  - 단일 워드 쓰기
  - 다중 워드 쓰기
  - 전체 BRAM 채우기

- **BRAM 읽기 테스트**
  - 단일 워드 읽기
  - 다중 워드 읽기
  - 전체 BRAM 읽기

- **ILA 디버깅**
  - AXI 버스 모니터링
  - 버스트 테스트로 ILA 캡처
  - 실시간 파형 분석

## 📁 프로젝트 구조

```
kv260_bram_ila/
├── vivado/
│   ├── create_project.tcl    # Vivado 프로젝트 생성 TCL 스크립트
│   ├── build_all.tcl         # 합성/구현/비트스트림 자동화 스크립트
│   └── build.bat             # Windows 빌드 배치 파일
├── vitis/
│   └── src/
│       ├── main.c            # BRAM 테스트 애플리케이션 소스
│       └── lscript_template.ld
└── docs/
    └── workflow_guide.md     # 상세 워크플로우 가이드
```

## 🔧 개발 환경

- **Vivado:** 2022.2
- **Vitis:** 2022.2
- **Target Board:** Xilinx Kria KV260 Vision AI Starter Kit
- **Part:** xck26-sfvc784-2LV-c (Zynq UltraScale+ MPSoC)

## 📐 하드웨어 사양

| 항목 | 값 |
|------|-----|
| BRAM 베이스 주소 | 0x80000000 |
| BRAM 크기 | 8KB (2048 x 32-bit) |
| AXI 데이터 폭 | 32-bit |
| PL 클럭 | 100 MHz |
| ILA Capture Depth | 4096 samples |

## 🚀 빠른 시작

### 1. 프로젝트 생성 및 준비 작업

#### 🔧 권장 방법: Vivado GUI에서 직접 실행
##### 1단계: Vivado 실행
```
시작 메뉴 → Xilinx Design Tools → Vivado 2022.2
```

##### 2단계: TCL 스크립트 실행 : Wrapper 작업 등에 대해서 질문이 나오며 OK로 진행
```
Vivado 메뉴: Tools → Run Tcl Script...
→ create_project.tcl 선택 → OK
```

<img width="1719" height="459" alt="002" src="https://github.com/user-attachments/assets/e5f9c3f5-bfe5-45ed-9692-065aa6992f69" />


##### 3단계: 빌드
```
Flow Navigator (왼쪽 패널) → Generate Bitstream 클릭
→ 완료까지 대기 (10~30분)
```

##### 4단계: XSA 파일 생성
```
File → Export → Export Hardware...
→ ☑ Include bitstream 체크
→ Next → Finish
```

#### 🖥️ 또는 Vivado TCL Console에서 직접 실행
- Vivado 실행 후 하단 Tcl Console 창에서:
```tcl
cd C:/Users/Administrator/Desktop/kv260_bram_ila/01.KRIA_BRAM_ILA/vivado
source create_project.tcl
source build_all.tcl
```

#### ⚠️ build.bat 사용 시
- 배치 파일을 사용하려면 VIVADO_PATH를 실제 경로로 수정해야 합니다:
```batch
REM build.bat 파일의 7번째 줄 수정
set VIVADO_PATH=C:\Xilinx\Vivado\2022.2\bin\vivado.bat
```
- Vivado 설치 경로가 다르면 (예: D드라이브) 해당 경로로 변경하세요.

#### 🖥️ 또는 Vivado TCL Console에서 직접 실행(windows)
### 1. Vivado 프로젝트 빌드

**Windows:**
```batch
cd vivado
build.bat
:: 메뉴에서 3번 선택 (Create and Build)
```

**TCL:**
```tcl
# Vivado TCL Console
cd C:/path/to/kv260_bram_ila/vivado
source create_project.tcl
source build_all.tcl
```

### 2. Vitis 프로젝트 설정

1. Vitis 실행
2. Platform Project 생성 (XSA 파일 사용)
3. Application Project 생성
4. `vitis/src/main.c` 파일 import
5. Build

### 3. 디버깅

1. **Vivado Hardware Manager** 에서 FPGA 프로그래밍
2. ILA 트리거 설정 및 Arm
3. **Vitis** 에서 애플리케이션 실행
4. ILA에서 AXI 트랜잭션 캡처 확인

자세한 내용은 [워크플로우 가이드](docs/workflow_guide.md)를 참조하세요.

## 📺 테스트 메뉴

```
============================================================
                    MAIN MENU
------------------------------------------------------------
  [Write Operations]
    1. Write Single Word        - 단일 워드 쓰기
    2. Write Multiple Words     - 다중 워드 쓰기
    3. Fill All BRAM with Value - 전체 채우기

  [Read Operations]
    4. Read Single Word         - 단일 워드 읽기
    5. Read Multiple Words      - 다중 워드 읽기
    6. Read All BRAM            - 전체 읽기

  [Pattern Tests]
    7. Write Test Pattern       - 패턴 쓰기
    8. Verify Test Pattern      - 패턴 검증

  [ILA Debug]
    9. ILA Burst Test           - ILA 캡처용 버스트

  [Utilities]
   10. Hex Dump                 - 메모리 덤프
   11. Clear All BRAM           - 초기화
   12. Show BRAM Info           - 정보 표시

    0. Exit
------------------------------------------------------------
```

## 🔍 ILA 트리거 예시

### 쓰기 동작 캡처
```
SLOT_0_AXI:AWVALID = 1
```

### 읽기 동작 캡처
```
SLOT_0_AXI:ARVALID = 1
```

### 특정 주소 캡처
```
SLOT_0_AXI:AWADDR = 0x80000000
```

## ⚠️ 주의사항

1. **캐시 비활성화:** ILA에서 정확한 AXI 트랜잭션을 보려면 D-Cache를 비활성화해야 합니다 (코드에 이미 적용됨)

2. **FPGA 프로그래밍 순서:**
   - Vitis에서 FPGA 프로그래밍 후 ILA 연결이 끊길 수 있음
   - 권장: Vivado에서 먼저 프로그래밍 후 Vitis에서는 프로그래밍 옵션 해제

3. **UART 설정:**
   - Baud Rate: 115200
   - Data Bits: 8, Parity: None, Stop Bits: 1

## 📚 참고 문서

- [Vivado Design Suite User Guide: Programming and Debugging (UG908)](https://docs.xilinx.com/r/en-US/ug908-vivado-programming-debugging)
- [Vitis Embedded Software Development Flow (UG1400)](https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded)
- [Zynq UltraScale+ Device Technical Reference Manual (UG1085)](https://docs.xilinx.com/r/en-US/ug1085-zynq-ultrascale-trm)

## 📝 버전 이력

| 버전 | 날짜 | 변경사항 |
|------|------|----------|
| 1.0 | 2025-01 | 초기 릴리스 |

---
*Made with Claude AI for KV260 FPGA Development*
