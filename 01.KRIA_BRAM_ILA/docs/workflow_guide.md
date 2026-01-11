# KV260 BRAM AXI ILA 프로젝트 - Vitis 워크플로우 가이드

## 📋 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [Vivado 프로젝트 빌드](#2-vivado-프로젝트-빌드)
3. [Vitis 플랫폼 생성](#3-vitis-플랫폼-생성)
4. [애플리케이션 프로젝트 생성](#4-애플리케이션-프로젝트-생성)
5. [ILA 디버깅 워크플로우](#5-ila-디버깅-워크플로우)
6. [테스트 메뉴 사용법](#6-테스트-메뉴-사용법)
7. [트러블슈팅](#7-트러블슈팅)

---

## 1. 프로젝트 개요

### 하드웨어 구성
```
┌─────────────────────────────────────────────────────────────┐
│                    Zynq UltraScale+ MPSoC                   │
│  ┌─────────────┐                                            │
│  │   PS (ARM)  │ ←─────── Vitis 애플리케이션 실행           │
│  │  Cortex-A53 │                                            │
│  └──────┬──────┘                                            │
│         │ M_AXI_HPM0_LPD                                    │
│         ↓                                                   │
│  ┌──────────────┐                                           │
│  │     AXI      │                                           │
│  │ Interconnect │                                           │
│  └──────┬───────┘                                           │
│         │                                                   │
│         ├─────────────────┐                                 │
│         ↓                 ↓                                 │
│  ┌──────────────┐  ┌─────────────┐                         │
│  │  AXI BRAM    │  │ System ILA  │ ←── AXI 버스 모니터링   │
│  │  Controller  │  │  (Debug)    │                         │
│  └──────┬───────┘  └─────────────┘                         │
│         │                                                   │
│         ↓                                                   │
│  ┌──────────────┐                                           │
│  │    BRAM      │                                           │
│  │   (8KB)      │                                           │
│  │ 0x80000000   │                                           │
│  └──────────────┘                                           │
└─────────────────────────────────────────────────────────────┘
```

### 메모리 맵
| 주소 범위 | 크기 | 설명 |
|-----------|------|------|
| 0x80000000 - 0x80001FFF | 8KB | AXI BRAM (테스트 대상) |

### 파일 구조
```
kv260_bram_ila/
├── vivado/
│   ├── create_project.tcl    # Vivado 프로젝트 생성 스크립트
│   └── build_all.tcl         # 합성/구현/비트스트림 자동화
├── vitis/
│   └── src/
│       ├── main.c            # BRAM 테스트 애플리케이션
│       └── lscript_template.ld
└── docs/
    └── workflow_guide.md     # 이 문서
```

---

## 2. Vivado 프로젝트 빌드

### 2.1 프로젝트 생성

```batch
:: Windows Command Prompt
cd C:\path\to\kv260_bram_ila\vivado

:: Vivado 실행 및 TCL 스크립트 실행
vivado -mode batch -source create_project.tcl
```

또는 Vivado GUI에서:
1. **Tools → Run Tcl Script...**
2. `create_project.tcl` 선택
3. 실행

### 2.2 빌드 실행

```batch
:: 프로젝트 생성 후 빌드
vivado -mode batch -source build_all.tcl
```

또는 Vivado GUI에서:
1. 프로젝트 열기 (`kv260_bram_ila.xpr`)
2. **Flow Navigator → Generate Bitstream** 클릭
3. 완료 후 **File → Export → Export Hardware...**
   - ☑️ Include bitstream 체크
   - XSA 파일 저장

### 2.3 생성되는 파일
- `kv260_bram_ila.xsa` - 하드웨어 플랫폼 (Vitis에서 사용)
- `kv260_bram_ila.ltx` - ILA 프로브 파일 (Hardware Manager에서 사용)
- `design_1_wrapper.bit` - 비트스트림

---

## 3. Vitis 플랫폼 생성

### 3.1 Vitis 실행

```batch
:: Vitis Classic (2022.2)
vitis -workspace ./vitis_workspace
```

### 3.2 플랫폼 프로젝트 생성

1. **File → New → Platform Project**
2. 설정:
   - Platform project name: `kv260_bram_platform`
   - ☑️ Create from hardware specification (XSA)
3. **Next** 클릭
4. XSA 파일 선택:
   - Browse → `vivado/kv260_bram_ila/kv260_bram_ila.xsa`
5. 운영 체제 설정:
   - Operating system: **standalone**
   - Processor: **psu_cortexa53_0**
6. **Finish** 클릭
7. 플랫폼 빌드:
   - 플랫폼 프로젝트 우클릭 → **Build Project**

---

## 4. 애플리케이션 프로젝트 생성

### 4.1 애플리케이션 프로젝트 생성

1. **File → New → Application Project**
2. 플랫폼 선택:
   - Select a platform: `kv260_bram_platform`
3. **Next** 클릭
4. 애플리케이션 설정:
   - Application project name: `bram_test_app`
   - System project name: `bram_test_system`
5. 도메인 선택:
   - Domain: `standalone_psu_cortexa53_0`
6. **Next** 클릭
7. 템플릿 선택:
   - **Empty Application (C)**
8. **Finish** 클릭

### 4.2 소스 코드 추가

1. **Explorer** 에서 `bram_test_app → src` 폴더 우클릭
2. **Import → General → File System**
3. `vitis/src/main.c` 파일 선택
4. Import 완료

또는 직접 복사:
```batch
copy vitis\src\main.c vitis_workspace\bram_test_app\src\
```

### 4.3 빌드 설정 확인

1. 프로젝트 우클릭 → **Properties**
2. **C/C++ Build → Settings**
3. **ARM v8 gcc compiler → Optimization**
   - Optimization Level: **-O0** (디버깅 용이)
4. **Apply and Close**

### 4.4 애플리케이션 빌드

1. 프로젝트 우클릭 → **Build Project**
2. 빌드 완료 확인

---

## 5. ILA 디버깅 워크플로우

### 5.1 권장 워크플로우 (방법 1: Vivado + Vitis 동시 사용)

이 방법이 **가장 효율적**입니다. Vivado Hardware Manager에서 ILA를 모니터링하면서 Vitis에서 애플리케이션을 실행합니다.

#### 단계 1: Vivado Hardware Manager 실행

1. Vivado 열기
2. **Flow Navigator → Open Hardware Manager**
3. **Open Target → Auto Connect**
4. FPGA 프로그래밍:
   - Device 우클릭 → **Program Device**
   - Bitstream: `design_1_wrapper.bit`
   - Debug probes: `kv260_bram_ila.ltx`
   - **Program** 클릭

#### 단계 2: ILA 트리거 설정

1. **hw_ila_1** 더블클릭하여 ILA 대시보드 열기
2. **Trigger Setup** 창에서 트리거 조건 설정:

**쓰기 동작 캡처:**
```
SLOT_0_AXI:AWVALID = 1
```

**읽기 동작 캡처:**
```
SLOT_0_AXI:ARVALID = 1
```

**특정 주소 캡처:**
```
SLOT_0_AXI:AWADDR = 0x80000000
```

3. **Trigger position** 설정 (예: 512)
4. **Run Trigger** 버튼 클릭 (또는 ▶ 버튼)
   - ILA가 "Waiting for Trigger" 상태가 됨

#### 단계 3: Vitis에서 애플리케이션 실행

1. Vitis에서 `bram_test_app` 프로젝트 선택
2. **Run → Run Configurations...**
3. **Single Application Debug** 더블클릭하여 새 설정 생성
4. 설정:
   - **Target Connection:** 하드웨어 연결
   - ☑️ Reset entire system (처음 실행 시)
   - ☐ Program FPGA (이미 Vivado에서 했으므로 체크 해제!)
5. **Apply** → **Run**

#### 단계 4: 테스트 실행 및 ILA 캡처

1. Vitis 터미널에서 메뉴 선택
2. 예: **9. ILA Burst Test** 선택
3. Vivado의 ILA가 트리거되면서 AXI 트랜잭션 캡처
4. Waveform 분석

### 5.2 ILA 신호 분석 가이드

#### AXI 쓰기 트랜잭션 신호
| 신호 | 설명 |
|------|------|
| AWADDR | 쓰기 주소 |
| AWVALID | 주소 유효 신호 |
| AWREADY | 슬레이브 준비 완료 |
| WDATA | 쓰기 데이터 |
| WVALID | 데이터 유효 신호 |
| WREADY | 슬레이브 준비 완료 |
| WSTRB | 바이트 스트로브 |
| BRESP | 응답 상태 |
| BVALID | 응답 유효 |
| BREADY | 마스터 응답 수신 준비 |

#### AXI 읽기 트랜잭션 신호
| 신호 | 설명 |
|------|------|
| ARADDR | 읽기 주소 |
| ARVALID | 주소 유효 신호 |
| ARREADY | 슬레이브 준비 완료 |
| RDATA | 읽기 데이터 |
| RVALID | 데이터 유효 |
| RREADY | 마스터 수신 준비 |
| RRESP | 응답 상태 |

#### 예상되는 파형 (쓰기)
```
        ____      ____
AWVALID     |____|
            ____
AWREADY ____|    |____
        ____
AWADDR  X__| 0x80000000 |__X
            ____
WVALID  ____|    |____
            ____
WREADY  ____|    |____
            ____
WDATA   X__| 0xDEAD0000 |__X
                ____
BVALID  ________|    |____
                ____
BREADY  ________|    |____
```

### 5.3 대안 워크플로우들

#### 방법 2: Vitis에서 FPGA 프로그래밍 후 Vivado로 ILA 연결
- 장점: Vitis에서 모든 것 관리
- 단점: FPGA 재프로그래밍 시 ILA 연결 끊김

#### 방법 3: System Debugger + TCF Agent
- 장점: 원격 디버깅 가능
- 단점: 설정이 복잡함

---

## 6. 테스트 메뉴 사용법

### 6.1 UART 터미널 설정

- **Baud Rate:** 115200
- **Data Bits:** 8
- **Parity:** None
- **Stop Bits:** 1
- **Flow Control:** None

### 6.2 메뉴 구성

```
============================================================
                    MAIN MENU
------------------------------------------------------------
  [Write Operations]
    1. Write Single Word      - 단일 주소에 데이터 쓰기
    2. Write Multiple Words   - 연속 주소에 여러 데이터 쓰기
    3. Fill All BRAM          - 전체 BRAM을 같은 값으로 채우기

  [Read Operations]
    4. Read Single Word       - 단일 주소 읽기
    5. Read Multiple Words    - 연속 주소 여러 개 읽기
    6. Read All BRAM          - 전체 BRAM 읽기 (요약)

  [Pattern Tests]
    7. Write Test Pattern     - 테스트 패턴 쓰기
    8. Verify Test Pattern    - 테스트 패턴 검증

  [ILA Debug]
    9. ILA Burst Test         - ILA 캡처용 빠른 연속 액세스

  [Utilities]
   10. Hex Dump               - 메모리 덤프
   11. Clear All BRAM         - 전체 초기화
   12. Show BRAM Info         - BRAM 정보 출력

    0. Exit
------------------------------------------------------------
```

### 6.3 테스트 시나리오 예시

#### 시나리오 1: 단일 쓰기/읽기 테스트
```
Enter your choice: 1
Enter offset (0-2047): 0
Enter data (hex): 0xDEADBEEF

Writing 0xDEADBEEF to offset 0 (addr: 0x80000000)...
Readback: 0xDEADBEEF
SUCCESS: Write verified!

Enter your choice: 4
Enter offset (0-2047): 0

Address: 0x80000000
Offset:  0
Data:    0xDEADBEEF (3735928559 decimal)
```

#### 시나리오 2: 패턴 테스트
```
Enter your choice: 7
Select pattern:
  1. Incrementing (0, 1, 2, 3, ...)
  2. Address pattern
  3. Checkerboard
  4. Walking ones
  5. All 0xFFFFFFFF
  6. All 0x00000000
Choice: 1

Writing pattern to all 2048 words...
Pattern: Incrementing
Pattern write complete!

Enter your choice: 8
Select pattern to verify:
Choice: 1

Verifying pattern...
SUCCESS: All 2048 words verified correctly!
```

#### 시나리오 3: ILA 버스트 테스트
```
Enter your choice: 9
=== ILA Burst Test ===
------------------------------------------------------------
This test performs rapid consecutive accesses
for easy ILA capture. Set ILA trigger before running.
------------------------------------------------------------

Select burst type:
  1. Write burst (100 consecutive writes)
  2. Read burst (100 consecutive reads)
  3. Mixed read/write burst
  4. Custom burst count
Choice: 1

*** Arm ILA trigger now! Press any key to start burst ***
[Press any key]
Starting write burst...
Write burst complete!
```

---

## 7. 트러블슈팅

### 7.1 일반적인 문제들

#### 문제: Vitis에서 하드웨어 연결 실패
**해결:**
1. KV260이 JTAG 모드인지 확인 (Boot Mode SW 설정)
2. USB 케이블 연결 확인
3. 드라이버 설치 확인 (Xilinx Cable Drivers)

#### 문제: BRAM 액세스 시 데이터 불일치
**해결:**
1. 캐시 비활성화 확인 (`Xil_DCacheDisable()`)
2. 주소 범위 확인 (0x80000000 ~ 0x80001FFF)
3. XSA 파일이 최신인지 확인

#### 문제: ILA에서 트리거가 발생하지 않음
**해결:**
1. FPGA가 프로그래밍되었는지 확인
2. LTX 파일이 비트스트림과 일치하는지 확인
3. 트리거 조건이 올바른지 확인
4. ILA가 "Waiting for Trigger" 상태인지 확인

#### 문제: "Program FPGA" 후 ILA 연결 끊김
**해결:**
1. Vivado Hardware Manager에서 다시 **Refresh Device**
2. 또는 Vivado에서만 FPGA 프로그래밍하고 Vitis에서는 체크 해제

### 7.2 ILA 캡처 팁

1. **Trigger Position 조정:**
   - 쓰기 시작 전 상태를 보려면 trigger position을 뒤쪽으로
   - 전체 burst를 보려면 trigger position을 앞쪽으로

2. **Capture Depth 설정:**
   - 긴 트랜잭션은 더 큰 depth 필요 (프로젝트는 4096으로 설정됨)

3. **다중 트리거:**
   - Trigger Setup에서 여러 조건 조합 가능
   - 예: `AWVALID=1 AND AWADDR=0x80000100`

### 7.3 성능 최적화

1. **Release 빌드:**
   - 최종 테스트 시 Optimization을 -O2로 변경
   
2. **Burst 전송:**
   - 현재 코드는 단일 전송 사용
   - 성능 향상을 위해 memcpy 기반 burst 구현 가능

---

## 📚 참고 자료

- [Xilinx UG1085 - Zynq UltraScale+ Device TRM](https://docs.xilinx.com/r/en-US/ug1085-zynq-ultrascale-trm)
- [Xilinx UG908 - Vivado Design Suite User Guide: Programming and Debugging](https://docs.xilinx.com/r/en-US/ug908-vivado-programming-debugging)
- [Xilinx UG1400 - Vitis Embedded Software Development Flow](https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded)
- [Xilinx UG1393 - Vitis Application Acceleration Development](https://docs.xilinx.com/r/en-US/ug1393-vitis-application-acceleration)

---

*Document Version: 1.0*
*Last Updated: 2025-01*
*Target: Vivado/Vitis 2022.2, Kria KV260*
