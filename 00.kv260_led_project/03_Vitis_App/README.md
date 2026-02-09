# 작업3: Vitis LED 제어 애플리케이션

## 📋 개요

PS(Processing System)의 ARM Cortex-A53에서 실행되는 Bare-metal 애플리케이션으로,
AXI GPIO를 통해 PL(Programmable Logic)의 LED 모드를 제어합니다.

```
┌─────────────────────────────────────────────────────────────────────┐
│                         KV260 System                                │
│  ┌──────────────────────────┐    ┌────────────────────────────────┐│
│  │   PS (ARM Cortex-A53)    │    │         PL (FPGA)              ││
│  │  ┌────────────────────┐  │    │  ┌──────────┐    ┌─────────┐  ││
│  │  │  Vitis Application │  │    │  │ AXI GPIO │───►│LED Logic│  ││
│  │  │    (main.c)        │  │    │  │ sw[1:0]  │    │         │──┼┼──►LED
│  │  └─────────┬──────────┘  │    │  └──────────┘    └─────────┘  ││
│  │            │             │    │                                ││
│  │         AXI Bus          │    │                                ││
│  └────────────┼─────────────┘    └────────────────────────────────┘│
│               └──────────────────────────►                         │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🔧 사전 요구사항

### 필수 조건

| 항목 | 설명 |
|------|------|
| **작업2 완료** | `02_PS_PL_Verilog` 또는 `02_PS_PL_VHDL` 빌드 완료 |
| **XSA 파일** | `kv260_led_ps_pl.xsa` 파일 존재 확인 |
| **Vitis 2022.2** | 설치 및 라이선스 활성화 |

### XSA 파일 위치 확인

```
02_PS_PL_Verilog/
├── kv260_led_ps_pl.xsa    ← 이 파일이 있어야 함
├── design_1_wrapper.bit
└── kv260_led_ps_pl/
```

XSA 파일이 없다면 작업2를 먼저 완료하세요:
```batch
cd 02_PS_PL_Verilog
build.bat → 1번 선택
```

---

## 🚀 빌드 방법

### 방법 1: 배치 파일 사용 (권장)

```batch
cd 03_Vitis_App
build.bat
```

메뉴에서 **1번** 선택:
```
==============================================================================
 KV260 LED Control - Vitis Application
==============================================================================

 NOTE: Build 02_PS_PL_Verilog or 02_PS_PL_VHDL first!

 [1] Create and Build Vitis Project
 [2] Clean Workspace
 [3] Open Vitis IDE
 [0] Exit

==============================================================================
Select: 1
```

### 방법 2: XSCT 콘솔에서 직접 실행

```tcl
# Vitis 설치 경로에서 XSCT 실행
C:\Xilinx\Vitis\2022.2\bin\xsct.bat

# TCL 스크립트 실행
cd C:/work/kv260_led_project/03_Vitis_App
source create_vitis_project.tcl
```

### 방법 3: Vitis GUI 사용

1. **Vitis 실행**
   ```
   시작 메뉴 → Xilinx → Vitis 2022.2
   ```

2. **Workspace 선택**
   ```
   C:\work\kv260_led_project\03_Vitis_App\workspace
   ```

3. **Platform 프로젝트 생성**
   - `File` → `New` → `Platform Project`
   - Name: `kv260_led_platform`
   - XSA: `../02_PS_PL_Verilog/kv260_led_ps_pl.xsa` 선택
   - Processor: `psu_cortexa53_0`
   - OS: `standalone`
   - `Finish` 클릭

4. **Platform 빌드**
   - Explorer에서 `kv260_led_platform` 우클릭
   - `Build Project` 선택

5. **Application 프로젝트 생성**
   - `File` → `New` → `Application Project`
   - Platform: `kv260_led_platform` 선택
   - Name: `led_control`
   - Domain: `standalone_domain`
   - Template: `Empty Application`
   - `Finish` 클릭

6. **소스 파일 추가**
   - `led_control` → `src` 폴더 우클릭
   - `Import Sources` 선택
   - `03_Vitis_App/src/main.c` 선택

7. **빌드**
   - `led_control` 우클릭 → `Build Project`

---

## 📡 FPGA 프로그래밍 및 실행

### Step 1: FPGA 비트스트림 로드

#### Vivado Hardware Manager 사용

```tcl
# Vivado TCL Console
open_hw_manager
connect_hw_server
open_hw_target

# 비트스트림 프로그래밍
set_property PROGRAM.FILE {C:/work/kv260_led_project/02_PS_PL_Verilog/design_1_wrapper.bit} [current_hw_device]
program_hw_devices
```

#### Vitis에서 프로그래밍

1. `Xilinx` → `Program Device`
2. Bitstream: `02_PS_PL_Verilog/design_1_wrapper.bit` 선택
3. `Program` 클릭

### Step 2: 애플리케이션 실행

1. **Run Configuration 생성**
   - `Run` → `Run Configurations`
   - `Single Application Debug` 더블클릭
   - Project: `led_control` 선택
   - `Apply` → `Run`

2. **또는 Debug로 실행**
   - `led_control` 우클릭
   - `Debug As` → `Launch Hardware (Single Application Debug)`

---

## 🖥️ UART 터미널 설정

### 터미널 프로그램

- **Windows**: PuTTY, Tera Term, MobaXterm
- **Linux**: minicom, screen, picocom

### COM 포트 확인

```
Windows: 장치 관리자 → 포트(COM & LPT) → USB Serial Port (COMx)
Linux: ls /dev/ttyUSB*
```

### 연결 설정

| 항목 | 값 |
|------|-----|
| **Baud Rate** | 115200 |
| **Data Bits** | 8 |
| **Parity** | None |
| **Stop Bits** | 1 |
| **Flow Control** | None |

### PuTTY 설정 예시

```
Session:
  - Connection type: Serial
  - Serial line: COM3 (확인 필요)
  - Speed: 115200

Serial:
  - Data bits: 8
  - Stop bits: 1
  - Parity: None
  - Flow control: None
```

---

## 📺 애플리케이션 메뉴

실행 시 UART 터미널에 다음 메뉴가 표시됩니다:

```
==========================================
  KV260 LED Control Application
==========================================

GPIO Initialized. Ready.

------------------------------------------
  LED Mode Selection
------------------------------------------
  0: OFF
  1: BLINK (1Hz)
  2: COUNTER (Binary 10Hz)
  3: KNIGHT RIDER
  D: Demo (cycle all modes)
  Q: Quit
------------------------------------------
Select:
```

### 메뉴 설명

| 키 | 모드 | 설명 |
|----|------|------|
| **0** | OFF | 모든 LED 꺼짐 |
| **1** | BLINK | 전체 LED 1Hz 점멸 (0.5초 ON, 0.5초 OFF) |
| **2** | COUNTER | 8비트 바이너리 카운터 (10Hz, 0→255 순환) |
| **3** | KNIGHT RIDER | LED가 좌우로 이동하는 효과 (20Hz) |
| **D** | Demo | 모든 모드 5초씩 자동 시연 |
| **Q** | Quit | 프로그램 종료 (LED OFF) |

### 동작 예시

```
Select: 2
Mode: COUNTER (Binary)
  -> Mode register: 0x02

Select: 3
Mode: KNIGHT RIDER
  -> Mode register: 0x03

Select: D
Running Demo...

[Demo] Mode: BLINK
  -> Mode register: 0x01

[Demo] Mode: COUNTER
  -> Mode register: 0x02

[Demo] Mode: KNIGHT
  -> Mode register: 0x03

[Demo] Mode: OFF
  -> Mode register: 0x00

Demo Complete.
```

---

## 🔍 소스 코드 설명

### main.c 구조

```c
/* GPIO 초기화 */
int InitGpio(void) {
    XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
    XGpio_SetDataDirection(&Gpio, GPIO_CHANNEL, 0x00);  // Output
    return XST_SUCCESS;
}

/* 모드 설정 - AXI GPIO에 2비트 값 쓰기 */
void SetMode(u8 mode) {
    XGpio_DiscreteWrite(&Gpio, GPIO_CHANNEL, mode & 0x03);
}
```

### AXI GPIO 주소

XSA에서 자동 생성된 `xparameters.h`에 정의됨:

```c
#define XPAR_AXI_GPIO_0_DEVICE_ID    0
#define XPAR_AXI_GPIO_0_BASEADDR     0x80000000
```

### 모드 값과 LED 패턴

| 모드 값 | sw[1:0] | PL 동작 |
|---------|---------|---------|
| 0x00 | 00 | LED = 0x00 (OFF) |
| 0x01 | 01 | LED = 0xFF ↔ 0x00 (1Hz) |
| 0x02 | 10 | LED = counter++ (10Hz) |
| 0x03 | 11 | LED = Knight Rider (20Hz) |

---

## ⚠️ 문제 해결

### 문제: UART 출력이 안 보임

**원인 1: COM 포트 번호 확인**
```
장치 관리자에서 COM 포트 번호 확인
KV260은 여러 COM 포트가 생성될 수 있음
```

**원인 2: 보레이트 불일치**
```
115200 baud로 설정되어 있는지 확인
```

**원인 3: FPGA 미프로그래밍**
```
비트스트림이 로드되지 않으면 UART가 동작하지 않음
```

### 문제: GPIO 초기화 실패

**원인: XSA 불일치**
```
Platform을 재빌드하거나 새 XSA로 갱신
Vitis: Platform → Update Hardware Specification
```

### 문제: LED가 동작하지 않음

**확인 사항:**
1. PMOD LED 모듈 연결 확인 (J2 커넥터)
2. 비트스트림 프로그래밍 확인 (DONE LED 점등)
3. UART에서 모드 설정 확인 (`Mode register: 0x0X`)

### 문제: Vitis 프로젝트 생성 실패

**원인: XSA 파일 없음**
```
ERROR: XSA file not found!
→ 작업2를 먼저 완료하세요
```

---

## 📁 출력 파일 위치

```
03_Vitis_App/
├── workspace/
│   ├── kv260_led_platform/        # Platform 프로젝트
│   │   └── hw/
│   │       └── kv260_led_ps_pl.xsa
│   └── led_control/               # Application 프로젝트
│       └── Debug/
│           └── led_control.elf    ← 실행 파일
└── src/
    └── main.c
```

---

## 📚 참고 자료

- [Vitis Embedded Software Development (UG1400)](https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded)
- [AXI GPIO Product Guide (PG144)](https://docs.xilinx.com/r/en-US/pg144-axi-gpio)
- [Zynq UltraScale+ Device TRM (UG1085)](https://docs.xilinx.com/r/en-US/ug1085-zynq-ultrascale-trm)
