# KV260 LED Control Project

## 개요

KRIA KV260에서 LED 제어를 위한 단계별 프로젝트입니다.

---

## 프로젝트 구조

```
KV260_LED_Project/
│
├── 01_PL_Only_Verilog/      # 작업1: PL만 사용 (Verilog)
├── 01_PL_Only_VHDL/         # 작업1: PL만 사용 (VHDL)
│
├── 02_PS_PL_Verilog/        # 작업2: PS+PL 연동 (Verilog)
├── 02_PS_PL_VHDL/           # 작업2: PS+PL 연동 (VHDL)
│
├── 03_Vitis_App/            # 작업3: Vitis 펌웨어
│
└── docs/                    # 문서
```

---

## 단계별 작업 흐름

### 작업1: PL Only (FPGA 로직만)

PS에서 클럭만 공급받고, LED 패턴은 PL 로직에서 자동 생성합니다.

```
┌─────────────────────────────────────────────────────┐
│                    Block Design                      │
│  ┌──────────┐                      ┌─────────────┐  │
│  │ Zynq PS  │ ──pl_clk0 (100MHz)─► │  LED Logic  │  │
│  │ (최소)   │ ──pl_resetn0───────► │  (Verilog/  │──►LED[7:0]
│  └──────────┘                      │   VHDL)     │  │
│                                    └─────────────┘  │
└─────────────────────────────────────────────────────┘
```

**빌드 방법:**
```batch
cd 01_PL_Only_Verilog
build.bat    (메뉴에서 1번 선택)
```

**결과:** 비트스트림만 생성, FPGA 프로그래밍 후 LED 자동 동작

---

### 작업2: PS + PL 연동

PS에서 AXI GPIO를 통해 LED 모드를 제어합니다.

```
┌─────────────────────────────────────────────────────────────┐
│                      Block Design                            │
│  ┌──────────┐      ┌───────────┐      ┌─────────────┐       │
│  │ Zynq PS  │─AXI─►│ AXI GPIO  │─────►│  LED Logic  │──►LED │
│  │          │      │ (sw[1:0]) │      │             │       │
│  │          │──────│───────────│─────►│  clk, rst   │       │
│  └──────────┘      └───────────┘      └─────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

**빌드 방법:**
```batch
cd 02_PS_PL_Verilog
build.bat    (메뉴에서 1번 선택)
```

**결과:** 비트스트림 + XSA 파일 생성

---

### 작업3: Vitis 펌웨어

작업2의 XSA를 사용하여 Vitis에서 LED 제어 애플리케이션을 실행합니다.

**사전 조건:** 작업2 완료 (XSA 파일 필요)

**빌드 방법:**
```batch
cd 03_Vitis_App
build.bat    (메뉴에서 1번 선택)
```

**UART 메뉴:**
- 0: LED OFF
- 1: LED Blink (1Hz)
- 2: LED Counter
- 3: Knight Rider
- D: Demo 실행

---

## 개발 환경

| 항목 | 버전 |
|------|------|
| Vivado | 2022.2 |
| Vitis | 2022.2 |
| OS | Windows 11 |
| Board | KRIA KV260 |

---

## PMOD LED 연결

## KV260 PMOD J2 Connector Pinout

### 커넥터 배치도
```
        ┌─────────────────────────────────────┐
        │         PMOD J2 Connector           │
        │            (Top View)               │
        ├─────────────────────────────────────┤
        │                                     │
        │   Pin 6 ●  ●  ●  ●  ●  ● Pin 1     │
        │         5  4  3  2  1               │
        │                                     │
        │  Pin 12 ●  ●  ●  ●  ●  ● Pin 7     │
        │        11 10  9  8  7               │
        │                                     │
        └─────────────────────────────────────┘
```

### 핀 매핑 테이블

| PMOD Pin | Signal Name   | FPGA Pin | Bank | I/O Standard | 용도 |
|:--------:|:-------------:|:--------:|:----:|:------------:|:----:|
| 1        | PMOD_HDA11    | H12      | 45   | LVCMOS33     | I/O  |
| 2        | PMOD_HDA12    | E10      | 45   | LVCMOS33     | I/O  |
| 3        | PMOD_HDA13    | D10      | 45   | LVCMOS33     | I/O  |
| 4        | PMOD_HDA14    | C11      | 45   | LVCMOS33     | I/O  |
| 5        | GND           | -        | -    | -            | 전원 |
| 6        | VCC (3.3V)    | -        | -    | -            | 전원 |
| 7        | PMOD_HDA15    | B10      | 45   | LVCMOS33     | I/O  |
| 8        | PMOD_HDA16_CC | E12      | 45   | LVCMOS33     | I/O  |
| 9        | PMOD_HDA17    | D11      | 45   | LVCMOS33     | I/O  |
| 10       | PMOD_HDA18    | B11      | 45   | LVCMOS33     | I/O  |
| 11       | GND           | -        | -    | -            | 전원 |
| 12       | VCC (3.3V)    | -        | -    | -            | 전원 |

### XDC 제약 파일 (Vivado)
```tcl
# PMOD J2 - Upper Row (Pin 1-4)
set_property PACKAGE_PIN H12 [get_ports {pmod[0]}]
set_property PACKAGE_PIN E10 [get_ports {pmod[1]}]
set_property PACKAGE_PIN D10 [get_ports {pmod[2]}]
set_property PACKAGE_PIN C11 [get_ports {pmod[3]}]

# PMOD J2 - Lower Row (Pin 7-10)
set_property PACKAGE_PIN B10 [get_ports {pmod[4]}]
set_property PACKAGE_PIN E12 [get_ports {pmod[5]}]
set_property PACKAGE_PIN D11 [get_ports {pmod[6]}]
set_property PACKAGE_PIN B11 [get_ports {pmod[7]}]

# I/O Standard
set_property IOSTANDARD LVCMOS33 [get_ports {pmod[*]}]
```

### 참고사항

- **전압 레벨**: 3.3V LVCMOS
- **I/O Bank**: Bank 45 (HD Bank)
- **최대 전류**: 각 핀 12mA 권장
- **CC 핀**: Pin 8 (E12)은 Clock-Capable 핀으로 클럭 입력에 적합

### Digilent PMOD 모듈 연결

| PMOD LED 모듈 | KV260 J2 Pin | FPGA Pin |
|:-------------:|:------------:|:--------:|
| LD0           | Pin 1        | H12      |
| LD1           | Pin 2        | E10      |
| LD2           | Pin 3        | D10      |
| LD3           | Pin 4        | C11      |
| LD4           | Pin 7        | B10      |
| LD5           | Pin 8        | E12      |
| LD6           | Pin 9        | D11      |
| LD7           | Pin 10       | B11      |


J2 커넥터에 PMOD LED 모듈 연결:

| LED | FPGA Pin | PMOD Pin |
|-----|----------|----------|
| LED[0] | H12 | J2.1 |
| LED[1] | E10 | J2.2 |
| LED[2] | D10 | J2.3 |
| LED[3] | C11 | J2.4 |
| LED[4] | B10 | J2.7 |
| LED[5] | E12 | J2.8 |
| LED[6] | D11 | J2.9 |
| LED[7] | B11 | J2.10 |

---

## 버전 이력

| 버전 | 날짜 | 내용 |
|------|------|------|
| 1.0 | 2025-02 | 초기 릴리스 |
