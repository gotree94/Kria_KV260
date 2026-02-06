# ILA 디버깅 가이드

## 📋 개요

ILA(Integrated Logic Analyzer)를 사용하여 KV260 LED 프로젝트의 내부 신호를 실시간으로 모니터링하고 디버깅하는 방법을 설명합니다.

---

## 🔧 ILA 구성

### HDL에서 mark_debug 속성

프로젝트의 RTL 코드에는 이미 `mark_debug` 속성이 포함되어 있습니다.

**Verilog:**
```verilog
(* mark_debug = "true" *) reg [31:0] ila_counter;
(* mark_debug = "true" *) reg [7:0]  ila_led_reg;
(* mark_debug = "true" *) reg [3:0]  ila_state;
(* mark_debug = "true" *) reg [1:0]  ila_mode;
```

**VHDL:**
```vhdl
attribute MARK_DEBUG : string;
attribute MARK_DEBUG of ila_counter : signal is "TRUE";
attribute MARK_DEBUG of ila_led_reg : signal is "TRUE";
attribute MARK_DEBUG of ila_state   : signal is "TRUE";
attribute MARK_DEBUG of ila_mode    : signal is "TRUE";
```

### 모니터링 신호 목록

| 신호명 | 비트폭 | 설명 |
|--------|--------|------|
| `ila_counter` | 32-bit | 시스템 사이클 카운터 |
| `ila_led_reg` | 8-bit | 현재 LED 출력 값 |
| `ila_state` | 4-bit | FSM 상태 (Knight Rider 모드) |
| `ila_mode` | 2-bit | 현재 선택된 모드 |

---

## 🚀 ILA 사용 방법

### Step 1: Vivado에서 ILA 확인

1. 합성(Synthesis) 완료 후 `Open Synthesized Design`
2. `Tools` → `Set Up Debug` 클릭
3. `mark_debug` 신호가 자동으로 검출됨
4. 샘플 깊이, 트리거 옵션 설정
5. `OK` 클릭 후 저장

### Step 2: Implementation 및 Bitstream 생성

```tcl
# Vivado TCL Console
source build_all.tcl
```

### Step 3: Hardware Manager에서 ILA 연결

1. **Hardware Manager 열기**
   - `Flow` → `Open Hardware Manager`
   - `Open Target` → `Auto Connect`

2. **FPGA 프로그래밍**
   - `Program Device` 클릭
   - Bitstream 파일 선택
   - `Program` 클릭

3. **ILA 대시보드 열기**
   - `hw_ila_1` 더블클릭
   - ILA 대시보드 창이 열림

---

## 🎯 트리거 설정

### 기본 트리거 (신호 값)

| 목적 | 트리거 조건 | 설명 |
|------|-------------|------|
| LED 모두 ON | `ila_led_reg == 8'hFF` | 모든 LED가 켜질 때 |
| 특정 패턴 | `ila_led_reg == 8'hAA` | 교차 패턴 |
| 모드 전환 | `ila_mode != prev_mode` | 모드 변경 시 |
| 상태 전이 | `ila_state == 4'd1` | ST_LEFT 진입 시 |

### 트리거 설정 방법

1. ILA 대시보드에서 `Trigger Setup` 탭 선택
2. 원하는 신호 선택
3. 비교 연산자 선택 (`==`, `!=`, `<`, `>` 등)
4. 트리거 값 입력
5. `Run Trigger` 클릭

### 복합 트리거

```
(ila_mode == 2'b11) AND (ila_state == 4'd2)
```
→ Knight Rider 모드에서 우측 이동 상태 캡처

---

## 📊 파형 분석

### Window 설정

| 설정 | 권장값 | 설명 |
|------|--------|------|
| Sample Depth | 4096 | 캡처할 샘플 수 |
| Capture Mode | BASIC | 기본 캡처 모드 |
| Trigger Position | 1024 | 트리거 전 샘플 수 |

### 파형 보기

1. 트리거 조건 충족 후 파형 자동 표시
2. 줌 인/아웃으로 상세 분석
3. 마커 추가로 특정 시점 표시
4. `Export` 버튼으로 CSV/VCD 저장

---

## 🔍 디버깅 시나리오

### 시나리오 1: LED가 동작하지 않음

**확인 사항:**
1. `ila_mode` 값 확인 → 올바른 모드 선택 여부
2. `ila_counter` 값 확인 → 클럭 동작 여부
3. `ila_led_reg` 값 확인 → 출력 로직 동작 여부

**트리거:**
```
ila_counter[31:28] == 4'h0  (시작점 캡처)
```

### 시나리오 2: Knight Rider 패턴 이상

**확인 사항:**
1. `ila_state` 전이 확인 (IDLE → LEFT → RIGHT → LEFT)
2. `ila_led_reg` 패턴 확인 (0x01 → 0x02 → 0x04 → ... → 0x80)

**트리거:**
```
ila_state == 4'd1  (ST_LEFT 상태)
```

### 시나리오 3: 타이밍 검증

**확인 사항:**
1. `ila_counter`로 LED 전환 주기 측정
2. 100MHz 클럭 기준 예상값과 비교

**계산:**
- 1Hz Blink: 50,000,000 클럭 (0.5초 ON, 0.5초 OFF)
- 10Hz Counter: 10,000,000 클럭 (0.1초마다 증가)

---

## 💡 고급 기능

### VIO (Virtual I/O) 추가

실시간으로 모드를 변경하려면 VIO를 추가할 수 있습니다:

```tcl
# Block Design에서 VIO 추가
create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0
set_property -dict [list \
    CONFIG.C_PROBE_OUT0_WIDTH {2} \
    CONFIG.C_NUM_PROBE_OUT {1} \
] [get_bd_cells vio_0]
```

### ILA 데이터 내보내기

```tcl
# Vivado TCL Console에서
write_hw_ila_data -csv_file {led_capture.csv} [current_hw_ila_data]
```

---

## ⚠️ 주의사항

1. **ILA는 리소스를 사용합니다**
   - BRAM 사용량 증가
   - 최종 제품에서는 ILA 제거 권장

2. **타이밍에 영향**
   - Debug Hub가 클럭 도메인을 사용
   - 타이밍 크리티컬 설계에서 주의

3. **비트스트림 크기 증가**
   - ILA 포함 시 비트스트림 용량 증가

4. **프로덕션 빌드**
   ```tcl
   # create_project.tcl에서
   set USE_ILA 0
   ```

---

## 📚 참고 자료

- [Vivado Design Suite User Guide: Programming and Debugging (UG908)](https://docs.xilinx.com/r/en-US/ug908-vivado-programming-debugging)
- [Vivado Design Suite User Guide: Design Analysis and Closure (UG906)](https://docs.xilinx.com/r/en-US/ug906-vivado-design-analysis)

---

*Made with Claude AI for KV260 FPGA Development*
