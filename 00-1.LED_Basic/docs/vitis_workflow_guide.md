# Vitis LED 제어 워크플로우 가이드

## 📋 개요

Vitis 2022.2 환경에서 KV260 LED를 PS(Processing System)로 제어하는 방법을 안내합니다.

---

## 🔧 사전 요구사항

### 하드웨어
- KV260 Vision AI Starter Kit
- USB Type-C 케이블 (전원 + JTAG)
- PMOD LED 모듈 (J2 연결)

### 소프트웨어
- Vivado 2022.2
- Vitis 2022.2
- 터미널 프로그램 (PuTTY, Tera Term 등)

### 파일
- `kv260_led_basic.xsa` (Vivado에서 생성)

---

## 🚀 Step-by-Step 가이드

### Step 1: Vivado에서 하드웨어 생성

```tcl
# Vivado TCL Console
cd C:/work/kv260_projects/00.LED_Basic/vivado
source create_project.tcl
source build_all.tcl
```

출력 파일:
- `kv260_led_basic.xsa` (하드웨어 정의)
- `design_1_wrapper.bit` (비트스트림)

### Step 2: Vitis 워크스페이스 생성

#### 방법 A: XSCT 콘솔 사용

```tcl
# Vitis IDE > Window > Show View > XSCT Console
cd C:/work/kv260_projects/00.LED_Basic/vitis
source create_vitis_project.tcl
```

#### 방법 B: Vitis GUI 사용

1. **Vitis 실행**
   - `vitis -workspace C:/work/kv260_projects/00.LED_Basic/vitis/workspace`

2. **플랫폼 프로젝트 생성**
   - `File` → `New` → `Platform Project`
   - Name: `kv260_led_platform`
   - XSA: `../vivado/kv260_led_basic.xsa` 선택
   - Processor: `psu_cortexa53_0`
   - OS: `standalone`
   - `Finish` 클릭

3. **플랫폼 빌드**
   - Explorer에서 플랫폼 우클릭 → `Build Project`

4. **애플리케이션 프로젝트 생성**
   - `File` → `New` → `Application Project`
   - Platform: `kv260_led_platform` 선택
   - Name: `led_control`
   - Domain: `standalone_domain`
   - Template: `Empty Application`
   - `Finish` 클릭

5. **소스 파일 추가**
   - `led_control/src` 우클릭 → `Import Sources`
   - `vitis/src/main.c` 선택

6. **빌드**
   - 프로젝트 우클릭 → `Build Project`

### Step 3: FPGA 프로그래밍

#### Vivado Hardware Manager 사용 (권장)

```tcl
# Vivado TCL Console
open_hw_manager
connect_hw_server
open_hw_target

set_property PROGRAM.FILE {C:/work/kv260_projects/00.LED_Basic/vivado/design_1_wrapper.bit} [current_hw_device]
program_hw_devices
```

#### Vitis에서 프로그래밍

1. `Xilinx` → `Program Device`
2. Bitstream 파일 선택
3. `Program` 클릭

### Step 4: 애플리케이션 실행

1. **Run Configuration 생성**
   - `Run` → `Run Configurations`
   - `Single Application Debug` 더블클릭
   - Project: `led_control`
   - `Apply` → `Run`

2. **UART 터미널 연결**
   - COM 포트 확인 (장치 관리자)
   - 터미널 프로그램 설정:
     - Baud Rate: 115200
     - Data Bits: 8
     - Parity: None
     - Stop Bits: 1

---

## 📺 애플리케이션 메뉴

```
============================================================
                    LED CONTROL MENU
------------------------------------------------------------
  [PL Mode Control]
    0. Mode OFF         - All LEDs off
    1. Mode BLINK       - 1Hz blinking
    2. Mode COUNTER     - Binary counter
    3. Mode KNIGHT      - Knight Rider effect

  [PS Direct Control]
    4. All LEDs ON      - 0xFF
    5. All LEDs OFF     - 0x00
    6. Alternate 1      - 0xAA
    7. Alternate 2      - 0x55
    8. Custom Pattern   - Enter hex value

  [Demo & Test]
    D. Run Demo         - All patterns demo
    T. Sequential Test  - Test each LED
    S. Show Status      - Current settings

    Q. Quit
------------------------------------------------------------
Select option:
```

---

## 🔍 제어 방식 비교

### PL Mode Control (0-3)

PS에서 AXI GPIO를 통해 `sw[1:0]` 신호를 설정하면, PL의 LED 로직이 해당 모드로 동작합니다.

```c
/* sw[1:0] = 0b01 → BLINK 모드 */
XGpio_DiscreteWrite(&GpioMode, 1, 0x01);
```

LED 패턴은 PL 로직(Verilog/VHDL)에서 생성됩니다.

### PS Direct Control (4-8)

PS에서 직접 LED 패턴을 출력합니다. PL 로직을 우회하고 GPIO로 직접 제어합니다.

```c
/* LED = 0xAA (교차 패턴) */
XGpio_DiscreteWrite(&GpioLed, 2, 0xAA);
```

---

## 🛠️ Block Design 수정 (선택사항)

PS에서 LED를 직접 제어하려면 Block Design에 두 번째 AXI GPIO를 추가해야 합니다.

### 추가 GPIO 설정

```tcl
# Vivado Block Design에서
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_led

set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {8} \
    CONFIG.C_ALL_OUTPUTS {1} \
] [get_bd_cells axi_gpio_led]

# LED 출력 포트로 연결
make_bd_pins_external [get_bd_pins axi_gpio_led/gpio_io_o]
```

---

## ⚠️ 문제 해결

### 문제: UART 출력이 안 보임

**원인:** 잘못된 COM 포트 또는 보레이트

**해결:**
1. 장치 관리자에서 COM 포트 확인
2. 보레이트 115200 확인
3. 다른 터미널 프로그램 사용

### 문제: GPIO 초기화 실패

**원인:** XSA 파일과 코드 불일치

**해결:**
1. Block Design에 AXI GPIO 포함 확인
2. XSA 재생성 후 플랫폼 재빌드
3. `xparameters.h`에서 Device ID 확인

### 문제: LED가 동작하지 않음

**원인:** 비트스트림 미프로그래밍

**해결:**
1. Vivado Hardware Manager에서 FPGA 프로그래밍
2. DONE LED 점등 확인
3. PMOD 연결 상태 확인

---

## 📚 참고 자료

- [Vitis Embedded Software Development Flow (UG1400)](https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded)
- [AXI GPIO Product Guide (PG144)](https://docs.xilinx.com/r/en-US/pg144-axi-gpio)
- [Standalone Library Documentation (UG643)](https://docs.xilinx.com/r/en-US/oslib_rm)

---

*Made with Claude AI for KV260 FPGA Development*
