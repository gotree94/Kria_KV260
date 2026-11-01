# Kria KV260 Vision AI 스타터 키트 사용자 가이드 (UG1089)

---

# 목차 (TOC)
## 요약 (Summary)
* 상자 안에는 무엇이 들어 있나요? (What's in the Box?)
* 인터페이스 (Interfaces)
## 초기 설정 (Initial Setup)
* 스타터 키트 전원 공급 및 전력 예산 (Powering the Starter Kit and Power Budgets)
* 팬과 히트 싱크 (Fan and Heat Sink)
## 부팅 장치 및 펌웨어 개요 (Boot Devices and Firmware Overview)
* 기본 부팅 장치 (Primary Boot Device)
* 보조 부팅 장치 (Secondary Boot Device)
## 소프트웨어 시작하기 (Software Getting Started)
* 플랫폼 관리 유틸리티 (Platform Management Utility)
* 가속 애플리케이션 (Accelerated Applications)
* 가속 애플리케이션 패키지 선택 (Accelerated Application Package Selection)
* 지원되는 주변 장치 (Supported Peripherals)
## Xilinx 도구 통합 (Xilinx Tools Integration)
* Vitis 플랫폼 (Vitis Platforms)
* Vivado 보드 플로우 (Vivado Board Flow)
## 보드 리셋, 펌웨어 업데이트 및 복구 (Board Reset, Firmware Update, and Recovery)
* 보드 리셋 (Board Reset)
* 펌웨어 업데이트 (Firmware Update)
* 부트 이미지 복구 도구 (Boot Image Recovery Tool)
* 부트 펌웨어 A/B 업데이트 (Boot Firmware A/B Update)
## 추가 자료 및 법적 고지 (Additional Resources and Legal Notices)
* 추가 문서 찾기 (Finding Additional Documentation)
* 지원 자료 (Support Resources)
* 참고 문헌 (References)
* 개정 이력 (Revision History)
* 필독: 중요한 법적 고지 사항 (Please Read: Important Legal Notices)

---

## 요약 (Summary)

AMD Kria™ KV260 Vision AI 스타터 키트는 비양산 버전의 K26 시스템 온 모듈(SOM), 캐리어 카드, 그리고 열 솔루션으로 구성되어 있습니다. 이 SOM에는 AMD Zynq™ UltraScale+™ MPSoC, 런타임 메모리, 비휘발성 부트 장치, 통합 전원 솔루션, 그리고 보안 모듈 등 핵심 디지털 하드웨어가 들어 있습니다. 비전 중심의 KV 캐리어 카드는 다양한 카메라/센서 입력, 비디오 디스플레이 출력, USB, SD 카드, 이더넷 물리적 인터페이스 등 여러 애플리케이션 주변기기 옵션을 제공합니다. 열 솔루션에는 히트 싱크, 히트 싱크 커버, 팬이 포함되어 있습니다. Kria KV260 Vision AI 스타터 키트는 고객이 목표 애플리케이션을 평가하고 나중에 K26 SOM으로 자신의 캐리어 카드를 설계할 수 있는 플랫폼을 제공하도록 설계되었습니다. 주요 목표 애플리케이션에는 스마트 시티, AI/ML 컴퓨팅, 보안, 미래형 리테일 등이 있습니다.

<p align="center">
  <img src="UG1089-media/image2.png" width="800">
</p>

## 상자 안에는 무엇이 들어 있나요? (What's in the Box?)

Kria KV260 Vision AI 스타터 키트에는 K26 SOM, 통합 열 솔루션, 그리고 캐리어 카드가 포함되어 있습니다. 이 키트는 캐리어 카드를 통해 다양한 주변 장치를 연결할 수 있도록 SOM 플랫폼 평가용으로만 제공됩니다. 상자에는 시작 안내 카드도 들어 있어 시작 웹페이지와 제품 페이지로 안내해 줍니다. 개발자용 스티커도 상자에 포함되어 있습니다. KV260 스타터 키트에는 전원 공급 장치, SD 카드, 주변 장치, 추가 액세서리는 포함되어 있지 않습니다.

하지만, 이 가이드에는 별도로 구매할 수 있는 전원 어댑터와 지원되는 주변 장치가 나와 있습니다.

* 표: 상자 내용물 요약

| 항목 번호 | 품목 | 수량 | 
|:------:|:------:|:------:|
| 1 | 팬싱크 열 솔루션이 포함된 스타터 키트 SOM | 1 | 
| 2 | 스타터 키트 캐리어 카드 | 1 | 
| 3 | 시작 안내 카드 | 1 | 
| 4 | 개발자 스티커 | 1 | 


## 인터페이스 (Interfaces)

다음 그림과 표는 스타터 키트에서 물리적 연결, 설계자, 그리고 상대적 위치를 보여줍니다. 표에서는 특정 설계자가 캐리어 카드에 있는지 SOM에 있는지를 나타내기 위해 다음 약어를 사용합니다. KV260 캐리어 카드는 두 가지 버전(rev. 1.0과 rev. 2.0)이 있습니다. 일부 기능은 2.0 버전에서만 이용 가능합니다. 자세한 내용은 각 버전의 회로도를 참고하세요.

* CC = 장치 또는 인터페이스가 캐리어 카드에 있음
* SOM = 장치 또는 인터페이스가 SOM에 있음

그림: 인터페이스 및 커넥터 Rev. 2.0

<p align="center">
  <img src="UG1089-media/image3.jpeg" width="800">
</p>

그림: 인터페이스 및 커넥터 Rev. 1.0

<p align="center">
  <img src="UG1089-media/image4.jpeg" width="800">
</p>

표: Rev 1.0 및 Rev 2.0의 설명과 위치

| 위치 | 이름 | Rev 1.0 탑재 | Rev 2.0 탑재 | 설명 | 
|:--------:|:--------:|:--------:|:--------:|--------|
| SOM DS34 | PS 완료 LED | Y | Y | 켜지면 PS가 PL 설계를 성공적으로 로드했음을 나타냅니다. |
| SOM DS35 | 하트비트 LED | Y | Y | Zynq UltraScale+ MPSoC APU 프로세서에 의해 구동되는 주기적으로 깜박이는 녹색 LED. | 
| SOM DS36 | PS 상태 LED | Y | Y | 상태 LED로, 켜지면 애플리케이션이 성공적으로 로드되었음을 나타냅니다. | 
| CC DS1-DS6 | 전원 상태 LED | Y | Y | 다양한 전원 공급 및 전원 도메인 상태를 나타냅니다. 녹색 LED는 정상 상태를 나타냅니다. | 
| CC J2 | Pmod | Y | Y | Digilent Pmod 2x6 확장 헤더 | 
| CC J3 | JTAG | Y | Y | 직접 JTAG 인터페이스로, FTDI 디바이스를 우회합니다. | 
| CC J20 | JTAG 부트 모드 선택 점퍼 | N | Y | J20이 장착되면 부트 모드를 QSPI 대신 JTAG로 설정합니다. 기본적으로 헤더는 장착되어 있지 않습니다. |
| CC J4 | FTDI USB2.0 UART 및 JTAG | Y | Y | USB2.0을 통한 통합 JTAG 및 디바이스 UART 인터페이스 |
| CC J6 | DisplayPort | Y | Y | DisplayPort 비디오 출력 |
| CC J5 | HDMI | Y | Y | HDMI™ 비디오 출력 | 
| CC J7 | IAS0 | Y | Y | 4개의 MIPI 레인을 지원하는 OnSemi 이미지 액세스 시스템(IAS) 카메라 모듈 인터페이스. OnSemi AP1302 ISP 디바이스 센서 0 인터페이스에 연결됩니다. | 
| CC J18 | IAS0 AF 선택 점퍼 | N | Y | 기본적으로 핀 1-2가 연결됩니다. 점퍼가 두 핀을 연결하면 IAS0의 자동 초점(AF) 전원 공급이 활성화됩니다. |
| CC J8 | IAS1 | Y | Y | 4개의 MIPI 레인을 지원하는 OnSemi IAS 카메라 모듈 인터페이스. Zynq UltraScale+ MPSoC HPA 뱅크에 직접 연결됩니다. |
| CC J19 | IAS1 AF 선택 점퍼 | N | Y | 헤더, 커패시터 및 점퍼는 장착되어 있지 않습니다. 장착되면 IAS1의 자동 초점 전원 공급이 활성화됩니다. |
| CC J9 | RPi 카메라 | Y | Y | 라즈베리 파이 카메라 모듈 인터페이스. 두 개의 MIPI 레인을 지원하며 Zynq UltraScale+ MPSoC HPA 뱅크에 직접 연결되는 15핀 변형입니다. | 
| CC J10 | 이더넷 RJ45 잭 | Y | Y | 1Gb/s 이더넷 인터페이스 |
| CC J11 | microSD 카드 | Y | Y | microSD 카드 부트 디바이스 |
| CC J12 | 12V 전원 입력 | Y | Y | 12V 전원 입력 잭 |
| CC J13 | 팬 전원 | Y | Y | 12V SOM 팬 전원 인터페이스 |
| CC SW1 | 펌웨어 업데이트 버튼 | Y | Y | 부트 펌웨어 업데이트 과정에서 사용되는 푸시 버튼. |
| CC SW2 | 리셋 버튼 | Y | Y | 디바이스 POR_B 신호를 통해 SOM을 리셋하는 푸시 버튼. | 
| CC J21 | PMU 리셋 | N | Y | 기본적으로 점퍼는 장착되지 않습니다. 연결되어 PMU 펌웨어에 의해 구현되면 SOM의 PMU 명령 POR_B 리셋이 활성화됩니다. | 
| CC U44 | USB0 | Y | Y | USB3.0 또는 USB2.0 호환 커넥터 2개 | 
| CC U46 | USB1 | Y | Y | USB3.0 또는 USB2.0 호환 커넥터 2개 | 

# 초기 설정 (Initial Setup)

### 스타터 키트 전원 공급 및 전력 예산 (Powering the Starter Kit and Power Budgets)

AMD Kria™ KV260 Vision AI 스타터 키트는 키트를 작동시키기 위해 12V, 3A 전원 어댑터가 필요합니다.

> ✎ 참고: 전원 어댑터는 KV260 스타터 키트에 포함되어 있지 않습니다. <br>
> 아래 표에는 별도로 구입해야 하는 권장 전원 어댑터가 나와 있습니다.

표: KV260 스타터 키트용으로 구매할 전원 어댑터

| 제조사 | 모델 | 설명 | 
|:-------:|:-------:|:-------:|
| CUI Inc. | SMI36-12-V-P6 | 센터 핀 양극 배럴 커넥터(2.5 mm ID, 5.5 mm OD)를 사용하는 +12V, 3A DC 어댑터 | 

전원 공급 어댑터의 배럴 커넥터를 DC 잭(J12)에 연결하여 KV260 스타터 키트에 +12V 전원을 공급합니다.

### K26 SOM 전원 공급 (Powering the K26 SOM)

KV260 스타터 키트 캐리어 카드의 내장 레귤레이터가 5V 전원을 생성하고 다른 전압 레귤레이터에도 전원을 제공합니다.

SOM 전원 레일(VCC_SOM)은 5V 전원으로 구동됩니다.

다음으로, SOM의 보드 내 전원 켜기 시퀀스가 시작됩니다.

캐리어 카드는 SOM이 VCCOEN_S_M2C와 VCCOEN_PL_M2C 신호를 어서트한 후, 프로그래머블 로직(PL)에 VCCO 전원 레일을 제공합니다.

### 전력 텔레메트리 (Power Telemetry)

SOM 전원 레일(VCC_SOM)에서 전력 모니터 장치를 사용할 수 있습니다. I2C 버스와 AMD에서 제공하는 유틸리티를 통해 SOM 모듈이 소비하는 전체 전력을 확인할 수 있습니다.

### 주변기기 전원 공급 (Powering Peripherals)

KV260 스타터 키트 캐리어 카드에서는 다음 인터페이스 사양에 따라 I/O 주변기기에 전원을 공급합니다.

### USB3.0

KV260 스타터 키트 캐리어 카드에는 총 4개의 USB3.0 인터페이스 포트가 있습니다. 각 포트는 연결된 I/O 주변기기에 최대 900 mA까지 5V 전원을 공급할 수 있습니다. 모든 포트는 개별 900 mA 전원 스위치를 통해 과전류 상황으로부터 보호됩니다.

> ✎ 참고: 총 전류(4개 포트 전체)는 2.1A로 할당됩니다.

### Pmod 커넥터 (Pmod Connector)

Pmod 인터페이스(Digilent Inc. 제공)는 공급 핀에서 3.3V, 100 mA 용량을 지원합니다.

## 라즈베리 파이 카메라 인터페이스 (Raspberry Pi Camera Interface)

라즈베리 파이 카메라 15핀 인터페이스 커넥터는 공급 핀에서 3.3V 공급 전압을 지원합니다.

### IAS 모듈 커넥터 (IAS Module Connector)

SOM은 ON Semiconductor IAS 모듈 정의 표준에 따라 두 개의 IAS 모듈 커넥터를 지원합니다. KV260 스타터 키트 캐리어 카드에서는 지정된 전원 핀에서 2.75V, 1.8V, 1.2V 전원 레일을 제공합니다.

## 팬과 히트 싱크 (Fan and Heat Sink)

KV260 스타터 키트는 통합 액티브 냉각 솔루션이 내장되어 있습니다(그림 2 참조). 통합 팬싱크 덕분에 추가 액세서리 없이도 전체 10W의 AMD Zynq™ UltraScale+™ MPSoC 애플리케이션 전력 예산을 충분히 활용할 수 있습니다.

박스에서 꺼내면 12V 팬은 이미 스타터 키트에 연결되어 있어야 합니다. 연결되어 있지 않다면 팬이 표 1에 지정된 커넥터에 연결되어 있는지 확인하세요. 팬 커넥터는 올바른 방향으로 연결되도록 설계되어 있습니다.

기본적으로 팬은 일정한 속도로 작동합니다. 팬 속도 가변 제어는 FPGA 기반 PWM 팬 컨트롤러를 통해 구현할 수 있습니다. 팬 게이팅 신호는 제어를 위해 FPGA HD I/O 뱅크 핀에 연결됩니다. 특정 핀 할당은 KV260 스타터 키트 캐리어 카드 회로도를 참조하고, RTL 구현은 AMD SOM 소스 코드 저장소를 참고하여 디자인에 통합할 수 있습니다.

# 부트 장치 및 펌웨어 개요 (Boot Devices and Firmware Overview)

AMD Kria™ KV260 Vision AI 스타터 키트에는 기본 부트 장치와 보조 부트 장치가 있어 플랫폼별 부트 펌웨어를 런타임 운영체제 및 애플리케이션과 격리할 수 있습니다. 이를 통해 부트 펌웨어를 다시 빌드하고 플래시하지 않고도 애플리케이션 이미지 내에서 애플리케이션 코드를 개발하고 업데이트하는 데 집중할 수 있습니다. 기본 부트 장치는 SOM에 위치한 QSPI 메모리이고, 보조 부트 장치는 캐리어 카드의 SD 카드 인터페이스입니다. 기본적으로 KV260 스타터 키트 캐리어 카드는 XCK26 부트 모드를 QSPI32로 설정합니다. SOM은 QSPI 내용을 사용하여 U-Boot로 부팅한 후, U-Boot는 보조 부트 장치로 핸드오프합니다.

> ✎ 참고: 키트가 Linux로 성공적으로 부팅되려면 SD 카드 이미지를 구워 캐리어 카드에 SD 카드를 장착해야 합니다.

전체 부트 장치 정의와 펌웨어 내용은 다음 그림에 나와 있습니다.

그림: 부트 장치

<p align="center">
  <img src="UG1089-media/image5.png" width="400">
</p>

> ✎ 중요: 생산용 SOM은 통합된 1차 및 2차 부트 구성을 지원하기 위해 SOM PCB에 QSPI 및 eMMC 장치를 모두 제공합니다.

# 기본 부트 장치 (Primary Boot Device)

주 부팅 장치는 SOM에 위치한 QSPI 장치입니다. 필요한 요소들은 AMD Zynq™ UltraScale+™ MPSoC 전용 형식으로 패키징되어 BOOT.BIN 파일로 캡처됩니다. BOOT.BIN 파일에는 다음 요소들로 구성된 보드 전용 부팅 펌웨어가 포함되어 있습니다:

### FSBL
   * 1단계 부트로더 펌웨어

### PMU
   * 플랫폼 관리 장치 펌웨어

### ATF
   * Arm® 트러스트 펌웨어

### U-Boot
   * 2단계 부트로더

U-Boot은 기본 부트 장치와 보조 부트 장치 간의 핸드오프 기능을 제공합니다. U-Boot에서 정의한 우선순위가 매겨진 보조 부트 장치 목록을 검색하며, SD 카드 인터페이스가 가장 높은 우선순위를 가집니다.

기본 부트 장치는 A/B 구성으로 배열된 부트 펌웨어의 중복 사본을 제공합니다. A/B 구성은 동적인 기본 및 보조 이미지 운영과 이에 따른 업데이트 메커니즘을 제공합니다. 부팅 시 시스템은 정의된 기본 이미지에서 자동으로 부팅하고, 부팅에 실패하면 이전에 정상적으로 부팅된 이미지로 되돌아갑니다.

## 보조 부트 장치 (Secondary Boot Device)

KV260 스타터 키트의 보조 부트 장치는 SD 카드입니다. 이 카드에는 운영 체제 이미지와 관련 애플리케이션 파일이 들어 있습니다. KV260 스타터 키트 가속화 애플리케이션 참조는 리눅스 운영 체제 기반으로 만들어졌습니다. 시작하기 웹 페이지에서는 미리 만들어진 참조 이미지를 제공하며, 이를 마이크로SD 카드에 기록하면 바로 사용할 수 있습니다. SOM 보드 지원 패키지(BSP)도 제공되므로 OS를 커스터마이징하고 싶다면 사용할 수 있습니다.

> ✎ 권장: SOM은 SDHC 표준 마이크로SD 카드를 사용하도록 설계되었습니다.

# 소프트웨어 시작하기 (Software Getting Started)

KV260 스타터 키트를 시작하려면, 보드에 전원을 켜고 부팅하며 첫 번째 애플리케이션을 실행하기 전에, Kria KV260 Vision AI 스타터 키트 시작하기 페이지의 지침을 따라 Xilinx SOM 스타터 리눅스 이미지를 microSD 카드에 다운로드하고 기록해야 합니다. 웹페이지는 KV260의 전원을 켜고 리눅스를 부팅하며, 미리 빌드된 가속화된 애플리케이션을 실행해 플랫폼의 기능을 평가할 수 있도록 안내합니다.

## 플랫폼 관리 유틸리티 (Platform Management Utility)

SOM Linux 이미지에는 SOM을 구성하고 사용하기 쉽게 도와주는 xmutil이라는 플랫폼 관리 유틸리티가 포함되어 있습니다. xmutil 기능과 설명 목록은 Kria SOM 위키 페이지를 참고하세요.

## 가속 애플리케이션 (Accelerated Applications)

AMD SOM 플랫폼에서는 여러 가속 애플리케이션을 동적으로 설치할 수 있습니다. SOM 스타터 Linux 이미지는 특정 애플리케이션에 종속되지 않으며, SOM Linux 패키지 피드에서 하드웨어 가속 애플리케이션 예제를 가져올 수 있는 유틸리티들을 제공합니다.

가속화 애플리케이션은 AI 개발자, 임베디드 개발자, 시스템 아키텍트를 위해 소프트웨어 제어를 통해 기능을 맞춤화하고 AI 모델을 업데이트하여 기능을 향상시킬 수 있는 소프트웨어 제어 가능 애플리케이션별 레퍼런스 디자인입니다. 다음 표는 KV260 스타터 키트에서 제공되는 일부 주요 가속화 애플리케이션을 보여줍니다.

이 목록은 시작점으로 생각하세요. 최신 가속화 애플리케이션 정보는 SOM 시작하기 웹 페이지에서 확인할 수 있습니다.

표: KV260 가속 애플리케이션

| 이름 | 설명 | 
|:------:|:------:|
| 스마트 카메라 | 얼굴 감지 및 동적으로 로드할 수 있는 기타 모델을 포함한 하드웨어 가속 ML 추론을 지원하는 구성 가능한 카메라/센서 입력 옵션. 추론 정보는 RTSP를 통해 모니터 또는 네트워크로 출력됩니다. | 
| AI 박스-ReID | 얼굴 감지 및 재식별(ReID) 모델을 지원하는 하드웨어 가속 ML 추론 모델과 다중 스트림 IP 카메라 RTSP 입력. 출력은 모니터에 표시됩니다. | 
| 결함 감지 | 결함 감지에 적용되는 하드웨어 가속 머신 비전 애플리케이션. | 

# 가속화된 애플리케이션 패키지 선택 (Accelerated Application Package Selection)

> ✎ 추천: 최신 가속화된 애플리케이션 디자인을 동적으로 내려받으려면 공용 이더넷 연결이 필요합니다.

1. 아직 인터넷 연결을 확인하지 않았다면, 진행하기 전에 ping 테스트나 DNS 조회(예: nslookup)를 통해 확인하세요.

2. sudo xmutil getpkgs 명령어는 당신의 플랫폼에 적용되는 일련의 패키지 그룹을 보여줍니다. 패키지 그룹 명명 규칙은 다음과 같습니다: packagegroup-킷_이름-애플리케이션_이름. 예를 들어, KV260 플랫폼용 스마트 카메라 애플리케이션의 패키지 그룹 이름은 packagegroup-kv260-smartcamera입니다. 선택한 애플리케이션 패키지 그룹을 DNF로 설치하면 원하는 만큼 동일한 가속 애플리케이션을 플랫폼에 설치할 수 있습니다. 예를 들어, 스마트 카메라 애플리케이션을 설치하려면 sudo dnf install packagegroup-kv260-smartcamera를 실행하면 됩니다.

> ✎ 참고: 사용 중인 스타터 키트 구성과 호환되는 패키지 그룹만 설치해야 합니다.

3. DNF 설치를 통해 로컬 파일 시스템에 설치된 애플리케이션의 경우, 이제 플랫폼에서 해당 애플리케이션을 동적으로 불러오고 교체할 수 있습니다. 시스템에 로컬로 설치된 애플리케이션 목록을 보려면 sudo xmutil listapps 를 실행하면 됩니다. /opt/xilinx 디렉토리를 직접 탐색해서 로컬 애플리케이션을 확인할 수도 있습니다.

4. 기본적으로 kv260-dp는 부팅 시 로드됩니다. 애플리케이션 목록에서 활성 애플리케이션이 로드되어 있는지 확인하세요 (xmutil listapps 출력에서 active = 1). 만약 애플리케이션이 로드되어 있다면, 다음 단계로 진행하기 전에 sudo xmutil unloadapp 명령어를 실행해서 현재 애플리케이션을 언로드하세요.

5. 애플리케이션 목록에서 sudo xmutil loadapp application_name 명령어를 실행해서 새 애플리케이션을 시작하세요. 플랫폼 구성은 자동으로 처리되며 애플리케이션이 시작됩니다.

6. Jupyter 기반의 코콕핏을 가진 애플리케이션은 자동으로 시작됩니다. 웹 브라우저를 관련 IP 주소와 포트로 연결해야 합니다. 관련 IP 주소와 포트 정보는 부팅 시 UART에 출력됩니다. 초기 부팅 후 Jupyter 랩 서버 URL을 확인하려면 다음을 실행하세요: sudo jupyter notebook list.

# 지원되는 주변기기 (Supported Peripherals)

다음 표는 해당 가속화된 애플리케이션과 함께 테스트된 외부 주변기기를 정리한 것입니다. 최대 플랫폼 성능을 발휘하려면 목록에 있는 주변기기를 사용하는 것이 좋습니다.

표: 가속 애플리케이션 주변기기

| 가속 애플리케이션 | 주변기기 | 부품 번호 | 
|:-----------:|:-----------:|:-----------:|
| 스마트 카메라 | IAS 카메라 센서 ISP 인터페이스 (J7) | OnSemi AR1335 센서 모듈. Avnet 부품 번호: CAVBA-000A | 
| 스마트 카메라 | USB 카메라 | Logitech BRIO | 
| 스마트 카메라 | 오디오 코덱 I2S PMOD (J2) | Digilent PMOD SKU 410-379 | 
| AI-Box-ReID | IP 카메라 | Amcrest IP8M-2493EW | 

다음 표는 KV260 스타터 키트와 기능적으로 검증된 외부 주변기기를 보여줍니다.

표: KV260 스타터 키트 기능 검증 주변기기

| 주변기기 | 부품 번호 | 
|:-----------:|:-----------:|
| IAS 카메라 센서 ISP 인터페이스 (J7) | OnSemi AR0144 | 
| IAS 카메라 센서 ISP 인터페이스 (J7) | OnSemi AR1335 | 
| IAS 카메라 센서 직접 인터페이스 (J8) | OnSemi AR1335 | 
| RPi 카메라 인터페이스 (J9) | Raspberry Pi 카메라 모듈 v2 | 

# Xilinx 도구 통합 (Xilinx Tools Integration)

K26LTD SOM과 KV260 스타터 키트는 AMD Vitis™ 소프트웨어 개발 플랫폼과 AMD Vivado™ 디자인 스위트와 통합되어 있어 플랫폼에서 나만의 애플리케이션을 빠르게 개발할 수 있습니다.

## Vitis 플랫폼 (Vitis Platforms)

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

# Vivado 보드 플로우 (Vivado Board Flow)

K26LTD SOM은 비바도 디자인 스위트에서 비바도 보드 플로우 기능을 통해 활성화됩니다. 비바도 보드 플로우는 SOM 카드에 고정된 주변 장치(예: DDR4)를 자동으로 구성하고, 관련 타이밍 제약을 정의하며, SOM 커넥터에서 사용할 수 있는 맞춤형 물리적 I/O를 제공합니다.

비바도 SOM 보드 모델은 비바도 설치 과정에서뿐만 아니라 비바도 보드 파일 [GitHub](https://github.com/Xilinx/XilinxBoardStore/tree/HEAD/boards/Xilinx) 저장소에서도 제공됩니다. 다음은 KV260 관련 비바도 보드 파일들입니다.

### KV260 스타터 키트

* 비전 스타터 키트 컴패니언 카드가 장착된 K26 SOM

### SM-K26-XCL2GC

* K26 상업용 등급 생산 SOM

### SM-K26-XCL2GI

* K26 산업용 등급 생산 SOM

AMD SOM 보드 플로우 인프라는 Vivado 도구의 컴패니언 카드 메커니즘을 통해 스타터 키트 캐리어 카드 인지를 제공합니다.

SOM과 관련 캐리어 카드(예: KV260 스타터 키트)를 선택할 때 I/O 연결 및 주변 장치 IP 구성을 자동으로 처리하여 하드웨어 구성을 생성합니다.

Vivado 도구와 Vivado 보드 플로우 사용에 대한 추가 정보는 Vivado Design Suite 사용자 가이드: 시스템 수준 디자인 입력(UG895)을 참고하세요.

# 보드 리셋, 펌웨어 업데이트 및 복구 (Board Reset, Firmware Update, and Recovery)

이 섹션에서는 KV260 스타터 키트에 내장된 업데이트 및 복구 메커니즘에 대해 설명합니다. 펌웨어 업데이트를 위해 두 가지 도구가 제공됩니다. 첫 번째는 Linux 기반의 A/B 업데이트 도구로, QSPI 장치의 A/B 펌웨어 파티션에 사용자 지정 또는 AMD에서 제공하는 업데이트를 원격 및 이중화 방식으로 지원합니다. 두 번째 도구는 이더넷 복구 도구로, 전체 플랫폼을 원래 공장 펌웨어로 복구할 때만 사용하도록 설계되었습니다.

## 보드 리셋 (Board Reset)

### 전원 켜기 리셋 (Power-on Reset)

1. SOM 리셋 신호(PS_POR_L)는 캐리어 카드에서 CC_PS_PGOOD 신호가 활성화될 때까지 리셋 상태로 유지됩니다.

2. 캐리어 카드의 모든 PS 및 PL I/O 장치 리셋 신호는 PS와 PL 전원 영역이 켜지고 안정된 후 25ms가 지나야 리셋이 해제됩니다.

3. KV260 스타터 키트에서 리셋 버튼(CC SW2)을 누르거나 소프트웨어를 통해 리셋 명령을 내리면 하드 리셋을 수행할 수 있습니다.

다음 그림은 KV260 스타터 키트에서 지원하는 리셋 기능을 보여줍니다.

그림: 디바이스 리셋

<p align="center">
  <img src="UG1089-media/image6.png" width="600">
</p>

## 펌웨어 업데이트 (Firmware Update)

펌웨어 업데이트 버튼은 KV260 스타터 키트 캐리어 카드에 있는 물리적 SW1/FWUEN 푸시 버튼입니다. 이 버튼은 두 가지 기능을 지원합니다:

1. 전원 켜기 시 플랫폼을 복구 모드 애플리케이션으로 강제로 진입하게 하기 위해 사용합니다. 복구 애플리케이션은 이 문서의 부트 이미지 복구 도구 섹션에 설명되어 있습니다.

2. 사용자가 실제로 없을 때 원격으로 부트 펌웨어를 업데이트하는 것을 방지하는 보안 메커니즘.

## 부트 이미지 복구 도구 (Boot Image Recovery Tool)

부트 이미지 복구 도구는 AMD에서 제공하는 스타터 키트 QSPI 이미지에 포함된 작은 애플리케이션입니다. Linux가 작동하지 않을 때 부트 펌웨어를 업데이트할 수 있는 간단한 이더넷 기반 인터페이스와 애플리케이션을 제공합니다. Linux가 정상적으로 작동한다면, xmutil 부트 펌웨어 업데이트 유틸리티를 사용해서 부트 펌웨어를 업데이트하는 것이 추천됩니다. 부트 이미지 복구 도구를 사용하는 방법에 대해서는 Kria SOM 위키 페이지를 참고하세요.

## 부트 펌웨어 A/B 업데이트 (Boot Firmware A/B Update)

부트 디바이스와 펌웨어 개요에서 설명된 것처럼, AMD 스타터 키트와 SOM은 QSPI 장치에 두 개의 부트 펌웨어 복사본을 제공합니다. 이 메커니즘은 핑퐁 방식으로 강력한 업데이트 인프라를 갖추고 있어, 항상 마지막으로 확인된 정상 부트 이미지를 플랫폼에서 사용할 수 있습니다. AMD 스타터 키트 리눅스는 이러한 업데이트를 완전히 현장에서 수행할 수 있는 유틸리티를 제공합니다. AMD SOM A/B 업데이트 도구를 사용하는 단계는 위키 페이지 '부트 펌웨어 업데이트 과정(Boot FW Update Process)'에 문서화되어 있습니다.

# 추가 자료 및 법적 고지 (Additional Resources and Legal Notices)

## 추가 문서 찾기 (Finding Additional Documentation)

### 기술 정보 포털 (Technical Information Portal)

AMD 기술 정보 포털은 웹 브라우저를 사용하여 문서에 대한 강력한 검색 및 탐색 기능을 제공하는 온라인 도구입니다. 기술 정보 포털에 접속하려면 [https://docs.amd.com](https://docs.amd.com/)으로 이동하십시오.

### 문서 탐색기 (Documentation Navigator)

문서 탐색기(DocNav)는 AMD Adaptive Computing 문서, 비디오 및 지원 자료에 대한 접근을 제공하는 설치형 도구로, 필터링 및 검색을 통해 정보를 찾을 수 있습니다. DocNav를 열려면:

* AMD Vivado™ IDE에서 Help > Documentation and Tutorials를 선택합니다.
* Windows에서 시작 버튼을 클릭하고 Xilinx Design Tools > DocNav를 선택합니다.
* Linux 명령 프롬프트에서 docnav를 입력합니다.

> ✎ 참고: DocNav에 대한 자세한 내용은 Documentation Navigator 사용자 가이드([UG968](https://docs.amd.com/access/sources/dita/map?isLatest=true&ft:locale=en-US&url=Xilinx-Documentation-Navigator-User-Guide))를 참고하십시오.

## 디자인 허브 (Design Hubs)

AMD 디자인 허브는 설계 작업 및 기타 주제별로 정리된 문서 링크를 제공하며, 이를 통해 핵심 개념을 배우고 자주 묻는 질문을 해결할 수 있습니다. 디자인 허브에 접속하려면:

* DocNav에서 Design Hubs View 탭을 클릭합니다.
* [Design Hubs](https://docs.amd.com/p/design-hubs) 웹 페이지로 이동합니다.

# 지원 자료 (Support Resources)

답변, 문서, 다운로드 및 포럼과 같은 지원 자료는 [Support](https://adaptivesupport.amd.com/)를 참조하십시오.

# 참고 문헌 (References)

이 문서들은 이 가이드와 함께 사용하기에 유용한 보충 자료를 제공합니다:

1. [Kria SOM GitHub.io 문서](https://xilinx.github.io/kria-apps-docs)

2. Kria KV260 Vision AI 스타터 키트 데이터 시트 ([DS986](https://docs.amd.com/go/en-US/ds986-kv260-starter-kit))

3. Kria K26 SOM 데이터 시트 ([DS987](https://docs.amd.com/go/en-US/ds987-k26-som))

4. Kria K26 SOM 열 설계 가이드 ([UG1090](https://docs.amd.com/go/en-US/ug1090-k26-thermal-design))

5. Kria SOM 캐리어 카드 설계 가이드 ([UG1091](https://docs.amd.com/go/en-US/ug1091-carrier-card-design))

6. Vitis Model Composer 사용자 가이드 ([UG1483](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1483-model-composer-sys-gen-user-guide&ft:locale=en-US))

7. Vivado Design Suite 사용자 가이드: 시스템 수준 디자인 입력 ([UG895](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug895-vivado-system-level-design-entry&ft:locale=en-US))

8. Vitis를 이용한 임베디드 디자인 개발 ([UG1701](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1701-vitis-accelerated-embedded&ft:locale=en-US))

9. Vitis 레퍼런스 가이드 ([UG1702](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1702-vitis-accelerated-reference&ft:locale=en-US))


* https://xilinx-wiki.atlassian.net/wiki/spaces/A/overview?homepageId=18844350

