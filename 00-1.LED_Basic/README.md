# KV260 LED 기본 제어 프로젝트

## 📋 프로젝트 개요

KRIA KV260 보드에서 PL(Programmable Logic)을 이용한 가장 기본적인 LED 제어 프로젝트입니다.
FPGA 입문자를 위한 첫 번째 프로젝트로, Vivado 2022.2 환경에서 진행합니다.

### 학습 목표

1. **기본 로직 설계**: Verilog/VHDL을 이용한 LED 제어 로직 작성
2. **ILA 디버깅**: 내부 신호를 ILA(Integrated Logic Analyzer)로 모니터링
3. **Vivado 워크플로우**: TCL 스크립트 기반 자동화 빌드

---

## 🎯 프로젝트 구성

```
00.LED_Basic/
├── README.md                    # 이 문서
├── vivado/
│   ├── create_project.tcl       # Vivado 프로젝트 생성 스크립트
│   ├── build_all.tcl            # 합성/구현/비트스트림 자동화
│   ├── build.bat                # Windows 빌드 배치 파일
│   └── constraints/
│       └── kv260_led.xdc        # 핀 제약 조건 파일
├── src/
│   ├── verilog/
│   │   ├── led_top.v            # 최상위 Verilog 모듈
│   │   ├── led_blink.v          # LED 블링크 모듈
│   │   └── led_counter.v        # 카운터 기반 LED 제어
│   └── vhdl/
│       ├── led_top.vhd          # 최상위 VHDL 엔티티
│       ├── led_blink.vhd        # LED 블링크 컴포넌트
│       └── led_counter.vhd      # 카운터 기반 LED 제어
├── vitis/
│   ├── create_vitis_project.tcl # Vitis 프로젝트 생성 스크립트
│   └── src/
│       └── main.c               # LED 제어 애플리케이션
└── docs/
    ├── hardware_guide.md        # 하드웨어 연결 가이드
    ├── ila_debug_guide.md       # ILA 디버깅 가이드
    └── vitis_workflow_guide.md  # Vitis 워크플로우 가이드
```

---

## 🔧 개발 환경

| 항목 | 값 |
|------|-----|
| **Vivado 버전** | 2022.2 |
| **Target Board** | Xilinx KRIA KV260 Vision AI Starter Kit |
| **Part Number** | xck26-sfvc784-2LV-c |
| **PL 클럭** | 100 MHz (pl_clk0) |
| **OS** | Windows 11 |

---

## 📐 하드웨어 사양

### KV260 LED 및 GPIO 정보

KV260 캐리어 보드에는 사용자 LED가 제한적이므로, PMOD 커넥터를 통해 외부 LED를 연결합니다.

| 신호명 | PMOD 핀 | FPGA 핀 | 용도 |
|--------|---------|---------|------|
| PMOD1_0 | J2.1 | H12 | LED[0] |
| PMOD1_1 | J2.2 | E10 | LED[1] |
| PMOD1_2 | J2.3 | D10 | LED[2] |
| PMOD1_3 | J2.4 | C11 | LED[3] |
| PMOD1_4 | J2.7 | B10 | LED[4] |
| PMOD1_5 | J2.8 | E12 | LED[5] |
| PMOD1_6 | J2.9 | D11 | LED[6] |
| PMOD1_7 | J2.10 | B11 | LED[7] |

### 권장 PMOD LED 모듈

- **Digilent PMOD LED**: 8개 LED (저항 내장)
- 직접 제작: LED + 330Ω 저항

---

## 🚀 빠른 시작

### 1. Vivado TCL Console에서 실행

```tcl
# Vivado TCL Console 열기
cd C:/work/kv260_projects/00.LED_Basic/vivado
source create_project.tcl
```

### 2. Windows 배치 파일 실행

```batch
cd C:\work\kv260_projects\00.LED_Basic\vivado
build.bat
```

### 3. Vitis에서 LED 제어 애플리케이션 실행

```tcl
# Vitis XSCT Console
cd C:/work/kv260_projects/00.LED_Basic/vitis
source create_vitis_project.tcl
```

또는 Vitis GUI에서:
1. `File` → `New` → `Platform Project` (XSA 파일 선택)
2. `File` → `New` → `Application Project`
3. `vitis/src/main.c` 소스 추가
4. `Run` → `Run Configurations`

### 4. 비트스트림 로드

1. Vivado Hardware Manager 실행
2. KV260 JTAG 연결 (USB 케이블)
3. Program Device → 비트스트림 선택
4. LED 동작 확인

---

## 💻 Vitis LED 제어 메뉴

UART 터미널 (115200 baud)에서 다음 메뉴를 사용합니다:

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
```

### 제어 방식

| 방식 | 설명 | 메뉴 |
|------|------|------|
| **PL Mode** | PS가 모드만 설정, 패턴은 PL 로직에서 생성 | 0-3 |
| **PS Direct** | PS가 LED 패턴을 직접 출력 | 4-8 |

---

## 📺 기능 설명

### 1. LED Blink (led_blink.v / led_blink.vhd)

가장 기본적인 LED 점멸 로직입니다.

```
동작:
- 1초 간격으로 LED ON/OFF 반복
- 100MHz 클럭 기준 50,000,000 카운트
```

### 2. LED Counter (led_counter.v / led_counter.vhd)

8비트 바이너리 카운터로 LED 패턴 표시

```
동작:
- 0.1초 간격으로 카운터 증가
- LED[7:0]에 카운터 값 출력
- 0x00 → 0x01 → 0x02 → ... → 0xFF → 0x00 반복
```

### 3. LED Top (led_top.v / led_top.vhd)

모드 선택 기능 포함 최상위 모듈

```
모드 (sw[1:0]):
- 00: LED 전체 OFF
- 01: LED Blink (1Hz)
- 10: LED Counter (바이너리 패턴)
- 11: Knight Rider 효과
```

---

## 🔍 ILA 디버깅

### ILA 모니터링 신호

| 신호명 | 폭 | 설명 |
|--------|-----|------|
| counter | 32-bit | 메인 카운터 값 |
| led_reg | 8-bit | LED 출력 레지스터 |
| state | 4-bit | FSM 상태 |
| clk_div | 1-bit | 분주 클럭 |

### ILA 트리거 설정 예시

```
# 특정 LED 패턴 캡처
led_reg == 8'hAA

# 카운터 특정 값 도달
counter == 32'd50_000_000

# 상태 전이 캡처
state != state_prev
```

---

## 📝 Verilog vs VHDL 선택

| 특성 | Verilog | VHDL |
|------|---------|------|
| **문법** | C 스타일, 간결 | Ada 스타일, 명시적 |
| **타이핑** | 약한 타입 | 강한 타입 |
| **시뮬레이션** | 빠른 작성 | 엄격한 검증 |
| **산업 분야** | ASIC, 미국/아시아 | 유럽, 방산/항공 |
| **추천** | 입문자, 빠른 프로토타입 | 대규모 설계, 신뢰성 |

**이 프로젝트에서는 Verilog와 VHDL 모두 제공합니다.**
TCL 스크립트에서 `USE_VHDL` 변수로 선택 가능합니다.

---

## 📚 참고 자료

### Xilinx 공식 문서

- [Kria KV260 Vision AI Starter Kit User Guide (UG1089)](https://docs.xilinx.com/r/en-US/ug1089-kv260-starter-kit)
- [Vivado Design Suite User Guide: Programming and Debugging (UG908)](https://docs.xilinx.com/r/en-US/ug908-vivado-programming-debugging)
- [Vivado Design Suite Tcl Command Reference Guide (UG835)](https://docs.xilinx.com/r/en-US/ug835-vivado-tcl-commands)

### 관련 프로젝트

- [01.KRIA_BRAM_ILA](../01.KRIA_BRAM_ILA) - AXI BRAM + ILA 디버깅
- [02.Smart_Camera](../02.Smart_Camera) - 카메라 영상 처리
- [03.AI_Box_ReID](../03.AI_Box_ReID) - 객체 재식별

---

## 📝 버전 이력

| 버전 | 날짜 | 변경사항 |
|------|------|----------|
| 1.0 | 2025-02 | 초기 릴리스 |

---

*Made with Claude AI for KV260 FPGA Development*
