# Kria KV260 Vision AI Starter Kit User Guide (UG1089)

---

# TOC (목차)
## Summary (요약)
* What's in the Box? (박스 안에는 뭐가 들어 있나요?)
* Interfaces (인터페이스)
## Initial Setup (초기 설정)
* Powering the Starter Kit and Power Budgets (스타터 키트 전원 공급 및 전력 예산)
* Fan and Heat Sink (팬과 히트 싱크)
## Boot Devices and Firmware Overview (부팅 장치 및 펌웨어 개요)
* Primary Boot Device (주요 부팅 장치)
* Secondary Boot Device (보조 부팅 장치)
## Software Getting Started (소프트웨어 시작하기)
* Platform Management Utility (플랫폼 관리 유틸리티)
* Accelerated Applications (가속 응용 프로그램)
* Accelerated Application Package Selection (가속 응용 프로그램 패키지 선택)
* Supported Peripherals (지원되는 주변 장치)
## Xilinx Tools Integration (자일링스 도구 통합)
* Vitis Platforms (Vitis 플랫폼)
* Vivado Board Flow (Vivado 보드 플로우)
## Board Reset, Firmware Update, and Recovery (보드 리셋, 펌웨어 업데이트 및 복구)
* Board Reset (보드 리셋)
* Firmware Update (펌웨어 업데이트)
* Boot Image Recovery Tool (부팅 이미지 복구 도구)
* Boot Firmware A/B Update (부팅 펌웨어 A/B 업데이트)
## Additional Resources and Legal Notices (추가 자료 및 법적 고지)
* Finding Additional Documentation (추가 문서 찾기)
* Support Resources (지원 자료)
* References (참고 문헌)
* Revision History (개정 이력)
* Please Read: Important Legal Notices ( 꼭 읽어주세요: 중요한 법적 고지)

---

## Summary (요약)

AMD Kria™ KV260 Vision AI 스타터 키트는 K26 시스템 온 모듈(SOM)의 비생산 버전, 캐리어 카드, 그리고 열 솔루션으로 구성되어 있어요. 이 SOM에는 AMD Zynq™ UltraScale+™ MPSoC, 런타임 메모리, 비휘발성 부트 장치, 통합 전원 솔루션, 그리고 보안 모듈 등 핵심 디지털 하드웨어가 들어 있어요. 
비전 중심의 KV 캐리어 카드는 다양한 카메라/센서 입력, 비디오 디스플레이 출력, USB, SD 카드, 이더넷 물리적 인터페이스 등 여러 애플리케이션 주변기기 옵션을 제공해요. 열 솔루션에는 히트 싱크, 히트 싱크 커버, 팬이 포함되어 있죠. Kria KV260 Vision AI 스타터 키트는 고객이 목표 애플리케이션을 평가하고 나중에 K26 SOM으로 자신의 캐리어 카드를 설계할 수 있는 플랫폼을 제공하도록 설계되었어요. 주요 목표 애플리케이션에는 스마트 시티, AI/ML 컴퓨팅, 보안, 미래형 리테일 등이 있어요.

<p align="center">
  <img src="UG1089-media/image2.png" width="800">
</p>

## What's in the Box? (상자 안에는 무엇이 들어있나요?)

Kria KV260 Vision AI Starter Kit에는 K26 SOM, 통합 열 솔루션, 그리고 캐리어 카드가 포함되어 있습니다. 이 키트는 캐리어 카드를 통해 다양한 주변 장치를 연결할 수 있도록 SOM 플랫폼 평가용으로만 제공됩니다. 상자에는 시작 안내 카드도 들어있어 시작 웹페이지와 제품 페이지로 안내해 줍니다. 개발자용 스티커도 상자에 포함되어 있습니다. KV260 스타터 키트에는 전원 공급 장치, SD 카드, 주변 장치, 추가 액세서리는 포함되어 있지 않습니다.

However, this guide lists Power Adapters and Supported Peripherals you can purchase separately.

하지만, 이 가이드에는 별도로 구매할 수 있는 전원 어댑터와 지원되는 주변 장치가 나와 있습니다.

* Table: Summary of Box Contents *

| Line Item | Items | Quantity | 
|:------:|:------:|:------:|
| 1 | Starter Kit SOM with fansink thermal solution | 1 | 
| 2 | Starter kit carrier card | 1 | 
| 3 | Getting Started card | 1 | 
| 4 | Developer stickers | 1 | 


## Interfaces (인터페이스)

다음 그림과 표는 스타터 킷에서 물리적 연결, 설계자, 그리고 상대적 위치를 보여줍니다. 표에서는 특정 설계자가 캐리어 카드에 있는지 SOM에 있는지를 나타내기 위해 다음 약어를 사용합니다. KV260 캐리어 카드는 두 가지 버전(rev. 1.0과 rev. 2.0)이 있습니다. 일부 기능은 2.0 버전에서만 이용 가능합니다. 자세한 내용은 각 버전의 회로도를 참고하세요.

* CC = Device or interface is located on the carrier card (장치 또는 인터페이스가 캐리어 카드에 있음)
* SOM = Device or interface is located on the SOM (장치 또는 인터페이스가 SOM에 있음)

Figure: Interfaces and Connectors Rev. 2.0

<p align="center">
  <img src="UG1089-media/image3.jpeg" width="800">
</p>

Figure: Interfaces and Connectors Rev. 1.0

<p align="center">
  <img src="UG1089-media/image4.jpeg" width="800">
</p>

Table: Descriptions and Locations for both Rev 1.0 and Rev 2.0

| Location | Name | Present on Rev1.0 | Present on Rev 2.0 | Description | 
|:--------:|:--------:|:--------:|:--------:|--------|
| SOM DS34 | PS done LED | Y | Y | Lit indicates that the PS has successfully loaded a PL design. |
| SOM DS35 | Heartbeat LED | Y | Y | Periodic flashing green LED driven by the Zynq UltraScale+ MPSoC APU processor. | 
| SOM DS36 | PS status LED | Y|  Y | Status LED, when lit indicates a successful application load. | 
| CC DS1-DS6 | Power status LEDs | Y | Y | Indicates various power supply and power domain status.  Green LED indicates good status.  | 
| CC J2  | Pmod  | Y | Y | Digilent Pmod 2x6 expansion header  | 
| CC J3  | JTAG  | Y | Y | Direct JTAG interface, bypasses the FTDI device.  | 
| CC J20 | JTAG boot mode selection jumper | N | Y | When J20 is populated, it sets boot mode to JTAG instead of QSPI. By default, the header is not populated. |
| CC J4 | FTDI USB2.0 UART and JTAG | Y | Y | Integrated JTAG and device UART interface via USB2.0 |
| CC J6 | DisplayPort | Y | Y | DisplayPort video output |
| CC J5 | HDMI | Y | Y | HDMI™ video output | 
| CC J7 | IAS0 | Y | Y | OnSemi image access system (IAS) camera module interface supporting four MIPI lanes. Connects to OnSemi AP1302 ISP device sensor 0 interface. | 
| CC J18 | IAS0 AF selection jumper | N | Y| Default pin 1-2 is connected. When jumper connects the two pins, it enables the auto-focus (AF) power supply on IAS0. |
| CC J8 | IAS1 | Y | Y | OnSemi IAS camera module interface supporting four MIPI lanes. Connected directly to the Zynq UltraScale+ MPSoC HPA bank. |
| CC J19 | IAS1 AF selection jumper | N | Y | Header and capacitor and jumpers are not populated. When populated, it enables auto-focus power supply on IAS1. |
| CC J9 | RPi camera | Y | Y | Raspberry Pi camera module interface. 15-pin variant supporting two MIPI lanes directly connected directly to the Zynq UltraScale+ MPSoC HPA bank. | 
| CC J10 | Ethernet RJ45 jack | Y | Y | 1 Gb/s Ethernet interface |
| CC J11 | microSD card | Y | Y | microSD card boot device |
| CC J12 | 12V power input | Y |  Y | 12V power | input jack |
| CC J13 | Fan power | Y | Y | 12V SOM fan power interface |
| CC SW1 | Firmware update button | Y | Y | Push button used during the boot firmware update process. |
| CC SW2 | Reset button | Y | Y | Push button that resets the SOM via the device POR_B signal. | 
| CC J21 | PMU reset | N | Y | Default is for the jumper to not be populated. When connected and implemented by PMU firmware, it enables a PMU-commanded POR_B reset of the SOM. | 
| CC U44 | USB0 | Y | Y | Two USB3.0 or USB2.0 compatible connectors | 
| CC U46 | USB1 | Y | Y | Two USB3.0 or USB2.0 compatible connectors | 

# Initial Setup (초기 설정)

### Powering the Starter Kit and Power Budgets (스타터 키트 전원 및 전력 예산)

AMD Kria™ KV260 Vision AI 스타터 키트는 키트를 작동시키기 위해 12V, 3A 전원 어댑터가 필요합니다.

> ✎ 참고: 전원 어댑터는 KV260 스타터 키트에 포함되어 있지 않습니다. <br>
> 아래 표에는 별도로 구입해야 하는 권장 전원 어댑터가 나와 있습니다.

Table: Power Adapters to Purchase for the KV260 Starter Kit

| Vendor | Model | Description | 
|:-------:|:-------:|:-------:|
| CUI Inc. | SMI36-12-V-P6 | +12V, 3A DC adapter using a center-pin positive barrel connector (2.5 mm ID, 5.5 mm OD) | 

The power supply adapter barrel connector plugs into the DC jack (J12) to supply the +12V power source to KV260 Starter Kit.

### Powering the K26 SOM (K26 SOM 전원 공급)

KV260 스타터 키트 캐리어 카드의 내장 레귤레이터가 5V 전원을 생성하고 다른 전압 레귤레이터에도 전원을 제공합니다.

SOM 전원 레일(VCC_SOM)은 5V 전원으로 구동됩니다.

다음으로, SOM의 보드 내 전원 켜기 시퀀스가 시작됩니다.

캐리어 카드는 SOM이 VCCOEN_S_M2C와 VCCOEN_PL_M2C 신호를 어설트한 후, 프로그래머블 로직(PL)에 VCCO 전원 레일을 제공합니다.

### Power Telemetry (전력 텔레메트리)

SOM 전원 레일(VCC_SOM)에서 전력 모니터 장치를 사용할 수 있습니다. I2C 버스와 AMD에서 제공하는 유틸리티를 통해 SOM 모듈이 소비하는 전체 전력을 확인할 수 있습니다.

### Powering Peripherals (주변기기 전원 공급)

KV260 스타터 키트 캐리어 카드에서는 다음 인터페이스 사양에 따라 I/O 주변기기에 전원을 공급합니다.

### USB3.0

KV260 스타터 키트 캐리어 카드에는 총 4개의 USB3.0 인터페이스 포트가 있습니다. 각 포트는 연결된 I/O 주변기기에 최대 900 mA까지 5V 전원을 공급할 수 있습니다. 모든 포트는 개별 900 mA 전원 스위치를 통해 과전류 상황으로부터 보호됩니다.

> ✎ 참고: 총 전류(4개 포트 전체)는 2.1A로 할당됩니다.

### Pmod Connector (Pmod 커넥터)

Pmod 인터페이스(Digilent Inc. 제공)는 공급 핀에서 3.3V, 100 mA 용량을 지원합니다.

## Raspberry Pi Camera Interface (라즈베리 파이 카메라 인터페이스)

라즈베리 파이 카메라 15핀 인터페이스 커넥터는 공급 핀에서 3.3V 공급 전압을 지원합니다.

### IAS Module Connector (IAS 모듈 커넥터)

SOM은 ON Semiconductor IAS 모듈 정의 표준에 따라 두 개의 IAS 모듈 커넥터를 지원합니다. KV260 스타터 키트 캐리어 카드에서는 지정된 전원 핀에서 2.75V, 1.8V, 1.2V 전원 레일을 제공합니다.

## Fan and Heat Sink (팬과 히트 싱크)

KV260 스타터 키트는 통합 액티브 냉각 솔루션이 내장되어 있습니다(그림 2 참조). 통합 팬싱크 덕분에 추가 액세서리 없이도 전체 10W의 AMD Zynq™ UltraScale+™ MPSoC 애플리케이션 전력 예산을 충분히 활용할 수 있습니다.

박스에서 꺼내면 12V 팬은 이미 스타터 키트에 연결되어 있어야 합니다. 연결되어 있지 않다면 팬이 표 1에 지정된 커넥터에 연결되어 있는지 확인하세요. 팬 커넥터는 올바른 방향으로 연결되도록 설계되어 있습니다.

기본적으로 팬은 일정한 속도로 작동합니다. 팬 속도 가변 제어는 FPGA 기반 PWM 팬 컨트롤러를 통해 구현할 수 있습니다. 팬 게이팅 신호는 제어를 위해 FPGA HD I/O 뱅크 핀에 연결됩니다. 특정 핀 할당은 KV260 스타터 키트 캐리어 카드 회로도를 참조하고, RTL 구현은 AMD SOM 소스 코드 저장소를 참고하여 디자인에 통합할 수 있습니다.

# Boot Devices and Firmware Overview (부트 장치 및 펌웨어 개요)

AMD Kria™ KV260 Vision AI 스타터 키트에는 기본 부트 장치와 보조 부트 장치가 있어 플랫폼별 부트 펌웨어를 런타임 운영체제 및 애플리케이션과 격리할 수 있습니다. 이를 통해 부트 펌웨어를 다시 빌드하고 플래시하지 않고도 애플리케이션 이미지 내에서 애플리케이션 코드를 개발하고 업데이트하는 데 집중할 수 있습니다. 기본 부트 장치는 SOM에 위치한 QSPI 메모리이고, 보조 부트 장치는 캐리어 카드의 SD 카드 인터페이스입니다. 기본적으로 KV260 스타터 키트 캐리어 카드는 XCK26 부트 모드를 QSPI32로 설정합니다. SOM은 QSPI 내용을 사용하여 U-Boot로 부팅한 후, U-Boot는 보조 부트 장치로 핸드오프합니다.

> ✎ 참고: 키트가 Linux로 성공적으로 부팅되려면 SD 카드 이미지를 구워 캐리어 카드에 SD 카드를 장착해야 합니다.

전체 부트 장치 정의와 펌웨어 내용은 다음 그림에 나와 있습니다.

Figure: Boot Devices

<p align="center">
  <img src="UG1089-media/image5.png" width="400">
</p>

> ✎ 중요: 생산용 SOM은 통합된 1차 및 2차 부트 구성을 지원하기 위해 SOM PCB에 QSPI 및 eMMC 장치를 모두 제공합니다.

# Primary Boot Device (1차 부트 장치)

주 부팅 장치는 SOM에 위치한 QSPI 장치입니다. 필요한 요소들은 AMD Zynq™ UltraScale+™ MPSoC 전용 형식으로 패키징되어 BOOT.BIN 파일로 캡처됩니다. BOOT.BIN 파일에는 다음 요소들로 구성된 보드 전용 부팅 펌웨어가 포함되어 있습니다:

### FSBL (FSBL)
   * First-stage boot-loader firmware
   * 1단계 부트로더 펌웨어

### PMU
   * Platform management unit firmware
   * 플랫폼 관리 장치 펌웨어

### ATF
   * Arm® trusted firmware
   * Arm® 트러스트 펌웨어

### U-Boot
   * Second-stage boot loader
   * 2단계 부트로더

U-Boot은 기본 부트 장치와 보조 부트 장치 간의 핸드오프 기능을 제공합니다. U-Boot에서 정의한 우선순위가 매겨진 보조 부트 장치 목록을 검색하며, SD 카드 인터페이스가 가장 높은 우선순위를 가집니다.

기본 부트 장치는 A/B 구성으로 배열된 부트 펌웨어의 중복 사본을 제공합니다. A/B 구성은 동적인 기본 및 보조 이미지 운영과 이에 따른 업데이트 메커니즘을 제공합니다. 부팅 시 시스템은 정의된 기본 이미지에서 자동으로 부팅하고, 부팅에 실패하면 이전에 정상적으로 부팅된 이미지로 되돌아갑니다.

## Secondary Boot Device (보조 부트 장치)

KV260 스타터 키트의 보조 부트 장치는 SD 카드입니다. 이 카드에는 운영 체제 이미지와 관련 애플리케이션 파일이 들어 있습니다. KV260 스타터 키트 가속화 애플리케이션 참조는 리눅스 운영 체제 기반으로 만들어졌습니다. 시작하기 웹 페이지에서는 미리 만들어진 참조 이미지를 제공하며, 이를 마이크로SD 카드에 기록하면 바로 사용할 수 있습니다. SOM 보드 지원 패키지(BSP)도 제공되므로 OS를 커스터마이징하고 싶다면 사용할 수 있습니다.

> ✎ 권장: SOM은 SDHC 표준 마이크로SD 카드를 사용하도록 설계되었습니다.

# Software Getting Started (소프트웨어 시작하기)

KV260 스타터 키트를 시작하려면, 보드에 전원을 켜고 부팅하며 첫 번째 애플리케이션을 실행하기 전에, Kria KV260 Vision AI 스타터 키트 시작하기 페이지의 지침을 따라 Xilinx SOM 스타터 리눅스 이미지를 microSD 카드에 다운로드하고 기록해야 합니다. 웹페이지는 KV260의 전원을 켜고 리눅스를 부팅하며, 미리 빌드된 가속화된 애플리케이션을 실행해 플랫폼의 기능을 평가할 수 있도록 안내합니다.

## Platform Management Utility (플랫폼 관리 유틸리티)

SOM Linux 이미지에는 SOM을 구성하고 사용하기 쉽게 도와주는 xmutil이라는 플랫폼 관리 유틸리티가 포함되어 있어요. xmutil 기능과 설명 목록은 Kria SOM 위키 페이지를 참고하세요.

## Accelerated Applications (가속 애플리케이션)

AMD SOM 플랫폼에서는 여러 가속 애플리케이션을 동적으로 설치할 수 있어요. SOM 스타터 Linux 이미지는 특정 애플리케이션에 종속되지 않으며, SOM Linux 패키지 피드에서 하드웨어 가속 애플리케이션 예제를 가져올 수 있는 유틸리티들을 제공합니다.

가속화 애플리케이션은 AI 개발자, 임베디드 개발자, 시스템 아키텍트를 위해 소프트웨어 제어를 통해 기능을 맞춤화하고 AI 모델을 업데이트하여 기능을 향상시킬 수 있는 소프트웨어 제어 가능 애플리케이션별 레퍼런스 디자인입니다. 다음 표는 KV260 스타터 키트에서 제공되는 일부 주요 가속화 애플리케이션을 보여줍니다.

이 목록은 시작점으로 생각하세요. 최신 가속화 애플리케이션 정보는 SOM 시작하기 웹 페이지에서 확인할 수 있습니다.

Table: KV260 Accelerated Applications

| Name | Description | 
|:------:|:------:|
| Smart camera | Configurable camera/sensor input options with hardware accelerated ML inference with face detection and other models that can be dynamically loaded. Inference information is outputted to a monitor or network via RTSP. | 
| AI box-ReID | Multi-stream IP camera RTSP inputs with hardware accelerated ML inference models supporting face detection and re-identification (ReID) models. Outputs are displayed to monitor. | 
| Defect detection | Hardware accelerated machine vision application as applied in defect detection. | 

# Accelerated Application Package Selection (가속화된 애플리케이션 패키지 선택)

> ✎ 추천: 최신 가속화된 애플리케이션 디자인을 동적으로 내려받으려면 공용 이더넷 연결이 필요합니다.

1. 아직 인터넷 연결을 확인하지 않았다면, 진행하기 전에 ping 테스트나 DNS 조회(e.g., nslookup)를 통해 확인하세요.

2. sudo xmutil getpkgs 명령어는 당신의 플랫폼에 적용되는 일련의 패키지 그룹을 보여줘요. 패키지 그룹 명명 규칙은 다음과 같아요: packagegroup-킷_이름-애플리케이션_이름. 예를 들어, KV260 플랫폼용 스마트 카메라 애플리케이션의 패키지 그룹 이름은 packagegroup-kv260-smartcamera예요. 선택한 애플리케이션 패키지 그룹을 DNF로 설치하면 원하는 만큼 동일한 가속 애플리케이션을 플랫폼에 설치할 수 있어요. 예를 들어, 스마트 카메라 애플리케이션을 설치하려면 sudo dnf install packagegroup-kv260-smartcamera를 실행하면 돼요.

> ✎ 참고: 사용 중인 스타터 키트 구성과 호환되는 패키지 그룹만 설치해야 해요.

3. DNF 설치를 통해 로컬 파일 시스템에 설치된 애플리케이션의 경우, 이제 플랫폼에서 해당 애플리케이션을 동적으로 불러오고 교체할 수 있어요. 시스템에 로컬로 설치된 애플리케이션 목록을 보려면 sudo xmutil listapps 를 실행하면 됩니다. /opt/xilinx 디렉토리를 직접 탐색해서 로컬 애플리케이션을 확인할 수도 있어요.

4. 기본적으로 kv260-dp는 부팅 시 로드됩니다. 애플리케이션 목록에서 활성 애플리케이션이 로드되어 있는지 확인하세요 (xmutil listapps 출력에서 active = 1). 만약 애플리케이션이 로드되어 있다면, 다음 단계로 진행하기 전에 sudo xmutil unloadapp 명령어를 실행해서 현재 애플리케이션을 언로드하세요.

5. 애플리케이션 목록에서 sudo xmutil loadapp application_name 명령어를 실행해서 새 애플리케이션을 시작하세요. 플랫폼 구성은 자동으로 처리되며 애플리케이션이 시작됩니다.

6. Jupyter 기반의 코콕핏을 가진 애플리케이션은 자동으로 시작됩니다. 웹 브라우저를 관련 IP 주소와 포트로 연결해야 합니다. 관련 IP 주소와 포트 정보는 부팅 시 UART에 출력됩니다. 초기 부팅 후 Jupyter 랩 서버 URL을 확인하려면 다음을 실행하세요: sudo jupyter notebook list.

# Supported Peripherals (지원되는 주변기기)

다음 표는 해당 가속화된 애플리케이션과 함께 테스트된 외부 주변기기를 정리한 것입니다. 최대 플랫폼 성능을 발휘하려면 목록에 있는 주변기기를 사용하는 것이 좋습니다.

Table: Accelerated Application Peripherals

| Accelerated Application | Peripheral | Part Number | 
|:-----------:|:-----------:|:-----------:|
| Smart camera | IAS camera sensor ISP interface (J7)  | OnSemi AR1335 sensor module. Avnet part number: CAVBA-000A  | 
| Smart camera | USB camera   | Logitech BRIO  | 
| Smart camera | Audio Codec I2S PMOD (J2)  | Digilent PMOD SKU 410-379  | 
| AI-Box-ReID  | IP camera  | Amcrest IP8M-2493EW  | 

다음 표는 KV260 스타터 키트와 기능적으로 검증된 외부 주변기기를 보여줘요.

Table: KV260 Starter Kit Functionally Tested Peripherals

| Peripheral  |  Part Number  | 
|:-----------:|:-----------:|
| IAS camera sensor ISP interface (J7)  | OnSemi AR0144 | 
| IAS camera sensor ISP interface (J7)  | OnSemi AR1335 | 
| IAS camera sensor direct interface (J8) | OnSemi AR1335 | 
| RPi camera interface (J9) | Raspberry Pi camera module v2 | 

# Xilinx Tools Integration (자일링스 도구 통합)

K26LTD SOM과 KV260 스타터 키트는 AMD Vitis™ 소프트웨어 개발 플랫폼과 AMD Vivado™ 디자인 스위트와 통합되어 있어 플랫폼에서 나만의 애플리케이션을 빠르게 개발할 수 있습니다.

## Vitis Platforms (Vitis 플랫폼)

Vitis 베이스 플랫폼은 kv260-vitis GitHub 저장소에서 이용할 수 있습니다. KV260 스타터 키트의 경우, 다음과 같은 Vitis 베이스 플랫폼을 사용할 수 있습니다. 추가적인 KV260 베이스 플랫폼이 시간이 지나면서 계속 추가되고 업데이트되므로, 디자인 작업을 시작하기 전에 최신 플랫폼 목록을 저장소에서 확인하는 것이 좋습니다.

### kv260_ispMipiRx_vcu_DP

* AR1335 센서 모듈 설정을 위한 IAS ISP MIPI 인터페이스를 이용한 비디오 캡처
* 표준 DisplayPort 및/또는 HDMI™를 통한 디스플레이
* PMOD 오디오 코덱을 통해 오디오 송수신(I2S)
* 비디오 코덱 유닛(VCU) 인코드/디코드와 하나의 스트림 인코드 버퍼
* NV12 비디오 포맷에서 4k30 및 1080p30 지원

### kv260_vcuDecode_vmixDP

* 네 개의 입력 스트림을 VCU로 디코딩
* 비디오 믹서(VMIX)를 사용해 DisplayPort 및/또는 HDMI로 2x2 디스플레이 구성 출력
* 각 스트림에 대해 1080p30 해상도 지원

### kv260_ispMipiRx_vmixDP

* AR0144 센서 모듈 구성을 위한 IAS ISP MIPI 인터페이스를 이용한 비디오 캡처
* 네 개 스트림의 VCU 디코딩
* 비디오 믹서(VMIX)를 이용해 DisplayPort 및/또는 HDMI로 2x2 디스플레이 구성

Vitis 기본 플랫폼은 특정 하드웨어 대상과 그것이 지원하는 실제 주변 장치 인터페이스를 기준으로 구축됩니다.

```
starter-kit-name_interface1_interface2
```

예를 들어, kv260_ispMipiRx_vcu_DP 기본 플랫폼은 KV260 스타터 키트를 대상으로 하며, 캐리어 카드의 ISP로 MIPI 수신 인터페이스를 제공하고 표준 단일 비디오 스트림을 디스플레이포트로 보낼 수 있습니다.

Vitis 도구와 Vitis 기본 플랫폼 워크플로에 대한 추가 정보는 Embeded Design Development Using Vitis ([UG1701](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1701-vitis-accelerated-embedded&ft:locale=ko-KR))와 Vitis Reference Guide ([UG1702](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1702-vitis-accelerated-reference&ft:locale=ko-KR))를 참고하세요.

# Vivado Board Flow (비바도 보드 플로우)

K26LTD SOM은 비바도 디자인 스위트에서 비바도 보드 플로우 기능을 통해 활성화됩니다. 비바도 보드 플로우는 SOM 카드에 고정된 주변 장치(예: DDR4)를 자동으로 구성하고, 관련 타이밍 제약을 정의하며, SOM 커넥터에서 사용할 수 있는 맞춤형 물리적 I/O를 제공합니다.

비바도 SOM 보드 모델은 비바도 설치 과정에서뿐만 아니라 비바도 보드 파일 [GitHub](https://github.com/Xilinx/XilinxBoardStore/tree/HEAD/boards/Xilinx) 저장소에서도 제공됩니다. 다음은 KV260 관련 비바도 보드 파일들입니다.

### KV260 Starter Kit

* Vision Starter Kit 동반 카드가 장착된 K26 SOM

### SM-K26-XCL2GC

* K26 상업용 등급 생산 SOM

### SM-K26-XCL2GI

* K26 산업용 등급 생산 SOM

AMD SOM 보드 플로우 인프라는 Vivado 도구의 컴패니언 카드 메커니즘을 통해 스타터 키트 캐리어 카드 인지를 제공합니다.

SOM과 관련 캐리어 카드(예: KV260 Starter Kit)를 선택할 때 I/O 연결 및 주변 장치 IP 구성을 자동으로 처리하여 하드웨어 구성을 생성합니다.

Vivado 도구와 Vivado 보드 플로우 사용에 대한 추가 정보는 Vivado Design Suite 사용자 가이드: 시스템 수준 디자인 입력(UG895)을 참고하세요.

# Board Reset, Firmware Update, and Recovery (보드 초기화, 펌웨어 업데이트 및 복구)

이 섹션에서는 KV260 스타터 킷에 내장된 업데이트 및 복구 메커니즘에 대해 설명합니다. 펌웨어 업데이트를 위해 두 가지 도구가 제공됩니다. 첫 번째는 Linux 기반의 A/B 업데이트 도구로, QSPI 장치의 A/B 펌웨어 파티션에 사용자 지정 또는 AMD에서 제공하는 업데이트를 원격 및 이중화 방식으로 지원합니다. 두 번째 도구는 이더넷 복구 도구로, 전체 플랫폼을 원래 공장 펌웨어로 복구할 때만 사용하도록 설계되었습니다.

## Board Reset (보드 리셋)

### Power-on Reset (전원 켜기 리셋)

1. SOM 리셋 신호(PS_POR_L)는 캐리어 카드에서 CC_PS_PGOOD 신호가 활성화될 때까지 리셋 상태로 유지됩니다.

2. 캐리어 카드의 모든 PS 및 PL I/O 장치 리셋 신호는 PS와 PL 전원 영역이 켜지고 안정된 후 25ms가 지나야 리셋이 해제됩니다.

3. KV260 스타터 키트에서 리셋 버튼(CC SW2)을 누르거나 소프트웨어를 통해 리셋 명령을 내리면 하드 리셋을 수행할 수 있습니다.

다음 그림은 KV260 스타터 키트에서 지원하는 리셋 기능을 보여줘요.

Figure: Device Reset

<p align="center">
  <img src="UG1089-media/image6.png" width="600">
</p>

## Firmware Update (펌웨어 업데이트)

펌웨어 업데이트 버튼은 KV260 스타터 키트 캐리어 카드에 있는 물리적 SW1/FWUEN 푸시 버튼이에요. 이 버튼은 두 가지 기능을 지원합니다:

1. 전원 켜기 시 플랫폼을 복구 모드 애플리케이션으로 강제로 진입하게 하기 위해 사용합니다. 복구 애플리케이션은 이 문서의 부트 이미지 복구 도구 섹션에 설명되어 있어요.

2. 사용자가 실제로 없을 때 원격으로 부트 펌웨어를 업데이트하는 것을 방지하는 보안 메커니즘.

## Boot Image Recovery Tool (부트 이미지 복구 도구)

부트 이미지 복구 도구는 AMD에서 제공하는 스타터 키트 QSPI 이미지에 포함된 작은 애플리케이션이에요. Linux가 작동하지 않을 때 부트 펌웨어를 업데이트할 수 있는 간단한 이더넷 기반 인터페이스와 애플리케이션을 제공해요. Linux가 정상적으로 작동한다면, xmutil 부트 펌웨어 업데이트 유틸리티를 사용해서 부트 펌웨어를 업데이트하는 것이 추천돼요. 부트 이미지 복구 도구를 사용하는 방법에 대해서는 Kria SOM 위키 페이지를 참고하세요.

## Boot Firmware A/B Update (부트 펌웨어 A/B 업데이트)

부트 디바이스와 펌웨어 개요에서 설명된 것처럼, AMD 스타터 키트와 SOM은 QSPI 장치에 두 개의 부트 펌웨어 복사본을 제공합니다. 이 메커니즘은 핑퐁 방식으로 강력한 업데이트 인프라를 갖추고 있어, 항상 마지막으로 확인된 정상 부트 이미지를 플랫폼에서 사용할 수 있습니다. AMD 스타터 키트 리눅스는 이러한 업데이트를 완전히 현장에서 수행할 수 있는 유틸리티를 제공합니다. AMD SOM A/B 업데이트 도구를 사용하는 단계는 위키 페이지 '부트 펌웨어 업데이트 과정(Boot FW Update Process)'에 문서화되어 있습니다.

# Additional Resources and Legal Notices

## Finding Additional Documentation

### Technical Information Portal

The AMD Technical Information Portal is an online tool that provides robust search and navigation for documentation using your web browser. To access  the Technical Information Portal, go to [https://docs.amd.com](https://docs.amd.com/)

### Documentation Navigator

Documentation Navigator (DocNav) is an installed tool that provides access to AMD Adaptive Computing documents, videos, and support resources, which you can filter and search to find information. To open DocNav:

* From the AMD Vivado™ IDE, select Help > Documentation and Tutorials.
* On Windows, click the Start button and select Xilinx Design Tools > DocNav.
* At the Linux command prompt, enter docnav.

> ✎ Note: For more information on DocNav, refer to the Documentation Navigator User Guide ([UG968](https://docs.amd.com/access/sources/dita/map?isLatest=true&ft:locale=en-US&url=Xilinx-Documentation-Navigator-User-Guide)).

## Design Hubs

AMD Design Hubs provide links to documentation organized by design tasks and other topics, which you can use to learn key concepts and address frequently asked questions. To access the Design Hubs:

* In DocNav, click the Design Hubs View tab.
* Go to the [Design Hubs](https://docs.amd.com/p/design-hubs) web page.

# Support Resources

For support resources such as Answers, Documentation, Downloads, and Forums, see [Support](https://adaptivesupport.amd.com/).

# References

These documents provide supplemental material useful with this guide:

1. [Kria SOM GitHub.io documentation](https://xilinx.github.io/kria-apps-docs)

2. Kria KV260 Vision AI Starter Kit Data Sheet ([DS986](https://docs.amd.com/go/en-US/ds986-kv260-starter-kit))

3. Kria K26 SOM Data Sheet ([DS987](https://docs.amd.com/go/en-US/ds987-k26-som))

4. Kria K26 SOM Thermal Design Guide ([UG1090](https://docs.amd.com/go/en-US/ug1090-k26-thermal-design))

5. Kria SOM Carrier Card Design Guide ([UG1091](https://docs.amd.com/go/en-US/ug1091-carrier-card-design))

6. Vitis Model Composer User Guide ([UG1483](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1483-model-composer-sys-gen-user-guide&ft:locale=en-US))

7. Vivado Design Suite User Guide: System-Level Design Entry ([UG895](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug895-vivado-system-level-design-entry&ft:locale=en-US))

8. Embedded Design Development Using Vitis ([UG1701](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1701-vitis-accelerated-embedded&ft:locale=en-US))

9. Vitis Reference Guide ([UG1702](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1702-vitis-accelerated-reference&ft:locale=en-US))


* https://xilinx-wiki.atlassian.net/wiki/spaces/A/overview?homepageId=18844350


