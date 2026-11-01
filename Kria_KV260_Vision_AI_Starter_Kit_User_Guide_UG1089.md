# Kria KV260 Vision AI Starter Kit User Guide (UG1089)

## TOC

### Summary
What's in the Box?
Interfaces

### Initial Setup
* Powering the Starter Kit and Power Budgets
* Fan and Heat Sink
### Boot Devices and Firmware Overview
* Primary Boot Device
* Secondary Boot Device
### Software Getting Started
* Platform Management Utility
* Accelerated Applications
* Accelerated Application Package Selection
* Supported Peripherals
### Xilinx Tools Integration
* Vitis Platforms
* Vivado Board Flow
### Board Reset, Firmware Update, and Recovery
* Board Reset
* Firmware Update
* Boot Image Recovery Tool
* Boot Firmware A/B Update
### Additional Resources and Legal Notices
* Finding Additional Documentation
* Support Resources
* References
* Revision History
* Please Read: Important Legal Notices

## Summary

The AMD Kria™ KV260 Vision AI Starter Kit is comprised of a non-production version of the K26 system-on-module (SOM), carrier card, and thermal solution. The SOM integrates core digital hardware components including an AMD Zynq™ UltraScale+™ MPSoC, run-time memory, non-volatile boot devices, an integrated power solution, and a security module. 
The vision-focused KV carrier card provides various application peripheral options including a variety of camera/sensor inputs, video display outputs, USB, SD card, and Ethernet physical interfaces. The thermal solution includes a heat sink, heat sink cover, and fan. The Kria KV260 Vision AI Starter  Kit is designed to provide customers a platform to evaluate their target applications and ultimately design their own carrier card with K26 SOMs. Key target applications include smart city, AI/ML computing, security, and future retail.

AMD Kria™ KV260 Vision AI 스타터 키트는 K26 시스템 온 모듈(SOM)의 비생산 버전, 캐리어 카드, 그리고 열 솔루션으로 구성되어 있어요. 이 SOM에는 AMD Zynq™ UltraScale+™ MPSoC, 런타임 메모리, 비휘발성 부트 장치, 통합 전원 솔루션, 그리고 보안 모듈 등 핵심 디지털 하드웨어가 들어 있어요. 
비전 중심의 KV 캐리어 카드는 다양한 카메라/센서 입력, 비디오 디스플레이 출력, USB, SD 카드, 이더넷 물리적 인터페이스 등 여러 애플리케이션 주변기기 옵션을 제공해요. 열 솔루션에는 히트 싱크, 히트 싱크 커버, 팬이 포함되어 있죠. Kria KV260 Vision AI 스타터 키트는 고객이 목표 애플리케이션을 평가하고 나중에 K26 SOM으로 자신의 캐리어 카드를 설계할 수 있는 플랫폼을 제공하도록 설계되었어요. 주요 목표 애플리케이션에는 스마트 시티, AI/ML 컴퓨팅, 보안, 미래형 리테일 등이 있어요.

<div style="text-align: center;">
  <img src=UG1089-media/image2.png">
</div>


## What's in the Box?

The Kria KV260 Vision AI Starter Kit includes a K26 SOM, integrated thermal solution, and carrier card. The kit is only meant for SOM platform evaluation with the carrier card providing a variety of interfaces for integrating
different peripherals. The box also includes a Getting Started card that directs  you to the getting started web page and product page. Developer stickers are also included in the box. The KV260 Starter Kit does not include a power supply, SD card, peripherals, or additional accessories.

However, this guide lists Power Adapters and Supported Peripherals you can purchase separately.

* Table: Summary of Box Contents *

| Line Item | Items | Quantity | 
|:------:|:------:|:------:|
| 1 | Starter Kit SOM with fansink thermal solution | 1 | 
| 2 | Starter kit carrier card | 1 | 
| 3 | Getting Started card | 1 | 
| 4 | Developer stickers | 1 | 

## Interfaces

The following figure and table provide an overview of the physical connections, their designators, and relative position on the starter kit. The table  uses the following abbreviations to indicate if a specific designator is
located on the carrier card or on the SOM. There are two versions of the KV260 carrier card (rev. 1.0 and rev. 2.0). Some of the features are only available on the 2.0 version. For further details, refer to the schematics of
each version.

* CC = Device or interface is located on the carrier card
* SOM = Device or interface is located on the SOM

Figure: Interfaces and Connectors Rev. 2.0

![](UG1089-media/image3.jpeg)

Figure: Interfaces and Connectors Rev. 1.0

![](UG1089-media/image4.jpeg)

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

# Initial Setup

### Powering the Starter Kit and Power Budgets
* The AMD Kria™ KV260 Vision AI Starter Kit requires a 12V, 3A power supply adapter to power the kit.

> ✎ Note: The power supply adapter is not included in the KV260 Starter Kit. <br>
> The following table lists the suggested power supply adapter that must be purchased separately.

Table: Power Adapters to Purchase for the KV260 Starter Kit

| Vendor | Model | Description | 
|:-------:|:-------:|:-------:|
| CUI Inc. | SMI36-12-V-P6 | +12V, 3A DC adapter using a center-pin positive barrel connector (2.5 mm ID, 5.5 mm OD) | 

* The power supply adapter barrel connector plugs into the DC jack (J12) to supply the +12V power source to KV260 Starter Kit.

### Powering the K26 SOM

* The KV260 Starter Kit carrier card on-board regulator generates a 5V supply and provides power to other voltage regulators.
* The SOM power rail (VCC_SOM) is powered by the 5V supply.
* Next, the SOM on-board power-on sequencing starts.
* The carrier card provides the programmable logic (PL) the VCCO voltage rails after the SOM asserts the VCCOEN_S_M2C and VCCOEN_PL_M2C signals Power Telemetry

### A power monitor device is available on the SOM power rail (VCC_SOM). You
can access the total power consumed by the SOM module through the I2C
bus and AMD provided utilities.

### Powering Peripherals

The KV260 Starter Kit carrier card supplies power to the I/O peripherals as specified by the following interface specifications.

### USB3.0

There are four USB3.0 interface ports available on the KV260 Starter Kit carrier card. Each port can deliver a 5V supply to the attached I/O peripherals with up to 900 mA per port. All ports are protected against an
over-current event through individual 900 mA power switches per port.

> ✎ Note: The total current (across all four ports) is allocated at 2.1A.

### Pmod Connector

The Pmod interface (from Digilent Inc.) is supported by the 3.3V, 100 mA capacity on the supply pin.

## Raspberry Pi Camera Interface

The Raspberry Pi camera 15 pin interface connector is supported by the 3.3V supply voltage on the supply pin.

### IAS Module Connector

The SOM supports two IAS module connectors, as defined by the ON Semiconductor IAS module definition standard. The KV260 Starter Kit carrier card provides 2.75V, 1.8V, and 1.2V supply rails on specified power pins.

## Fan and Heat Sink

The KV260 Starter Kit is built with an integrated active cooling solution (see Figure 2). The integrated fansink allows you to exercise the full 10W AMD Zynq™ UltraScale+™ MPSoC application power budget without any additional accessories.

Out of the box, the 12V fan should already be plugged into the starter kit. If it is not, be sure that the fan is plugged into the connector designated in Table 1. The fan connector is keyed to ensure proper orientation.

By default, the fan runs at a constant speed. Variable fan speed control can be implemented through a FPGA based PWM fan controller. The fan gating signal is connected to a FPGA HD I/O bank pin for control. Consult the
corresponding KV260 Starter Kit carrier card schematic for specific pin assignment and AMD SOM source code repositories for an RTL implementation that can be integrated with your design.

# Boot Devices and Firmware Overview

The AMD Kria™ KV260 Vision AI Starter Kit has a primary and secondary boot device that provides isolation of platform-specific boot firmware from the run-time operating system and application. This allows you to focus on developing and updating your application code within the application image without having to rebuild and flash boot firmware. The primary boot device is a QSPI memory located on the SOM and the secondary boot device is an SD card interface on the carrier card. By default, the KV260 Starter Kit carrier card sets the XCK26 boot mode to QSPI32. The SOM boots up to U-Boot using the QSPI contents and then U-Boot does a hand-off to the secondary boot device.

> ✎ Note: You must burn the SD card image and populate the SD card in the carrier card for the kit to successfully boot to Linux.

The overall boot device definition and firmware contents are outlined in the following figure.

Figure: Boot Devices

![](UG1089-media/image5.png)

> ✎ Important: Production SOMs provide both QSPI and eMMC devices on the SOM PCB to support integrated primary and secondary boot configurations.

# Primary Boot Device

The primary boot device is a QSPI device located on the SOM. The necessary elements are packaged in an AMD Zynq™ UltraScale+™ MPSoC specific format  and file captured as BOOT.BIN. The BOOT.BIN file contains the board-specific boot firmware that consists of the following elements:

### FSBL
   * First-stage boot-loader firmware

### PMU
   * Platform management unit firmware

### ATF
   * Arm® trusted firmware

### U-Boot
   * Second-stage boot loader

U-Boot provides the functionality for the hand-off between the primary boot device and the secondary boot device. It searches through a U-Boot defined prioritized list of secondary boot devices with priority given to the SD card interface.

The primary boot device provides a redundant copy of boot firmware arranged in an A/B configuration. The A/B configuration provides a dynamic primary and secondary image operation with corresponding update mechanisms. On boot, the system automatically boots from the defined primary  image, and, if boot fails, it falls back to the previously known good boot image.

## Secondary Boot Device

The secondary boot device on the KV260 Starter Kit is the SD card. It contains the operating system image and associated application files. The KV260 Starter Kit accelerated application references are built on the Linux operating system. The Getting Started web page provides a pre-built reference image that can be written to a microSD card for out-of-the-box functionality. SOM board support packages (BSPs) are also available if you want to customize your OS.

> ✎ Recommended: The SOM is designed to use SDHC standard microSD cards.

# Software Getting Started

To get started with the KV260 Starter Kit, prior to powering, booting the board, and running your first application, you need to follow the instructions  on the Getting Started with Kria KV260 Vision AI Starter Kit pages to download and write the Xilinx SOM Starter Linux image to a microSD card. The webpage guides you to power on the KV260, boot Linux, and run a number of pre-built accelerated applications to start evaluation of the capabilities on the platform.

## Platform Management Utility

A platform management utility called xmutil is included in the SOM Linux image to help you configure and work with the SOM. Refer to the Kria SOM Wiki page for a list of xmutil functions and their descriptions.

## Accelerated Applications

The AMD SOM platforms are enabled with a number of accelerated applications that can be dynamically installed on the SOM platform. The SOM  starter Linux image is application agnostic and provides a set of utilities for pulling the hardware accelerated application examples from the SOM Linux package feeds.

Accelerated applications are software controllable, application-specific reference designs for AI developers, embedded developers, and system architects to customize and enhance the functionality through software control or updating the AI models. The following table outlines some featured accelerated applications available for the KV260 Starter Kit.

Consider this list as a starting point because the SOM Getting Started web page contains the most up-to-date accelerated applications availability.

Table: KV260 Accelerated Applications

| Name | Description | 
|:------:|:------:|
| Smart camera | Configurable camera/sensor input options with hardware accelerated ML inference with face detection and other models that can be dynamically loaded. Inference information is outputted to a monitor or network via RTSP. | 
| AI box-ReID | Multi-stream IP camera RTSP inputs with hardware accelerated ML inference models supporting face detection and re-identification (ReID) models. Outputs are displayed to monitor. | 
| Defect detection | Hardware accelerated machine vision application as applied in defect detection. | 

# Accelerated Application Package Selection

> ✎ Recommended: Public Ethernet connectivity is necessary to dynamically pull down the latest accelerated application designs.

1. If you have not already verified Internet connectivity do so before proceeding via ping test or DNS lookup (e.g., nslookup).

2. The sudo xmutil getpkgs lists a series of package groups that apply to your platform. The package group naming convention is: packagegroup-kit_name-application_name . For example, the Smart Camera application for the KV260 platform has the following package group name packagegroup-kv260-smartcamera . You can install any number of matching accelerated applications to your platform by executing a DNF install for the chosen application package group. For
example, to install the smart camera application, run sudo dnf install packagegroup-kv260-smartcamera .

> ✎ Note: You should only install package-groups that are compatible with your particular starter kit configuration.

3. For any applications installed on the local file system via the DNF install, the platform can now dynamically load and swap those applications. To see a list of the applications local to the system, execute sudo xmutil listapps . You can also see what applications are local by manually exploring the /opt/xilinx directory.

4. By default, kv260-dp is loaded on boot. From the applications list, check for an active application loaded (active = 1 in the xmutil listapps output). If there is a loaded application, unload it by running the sudo xmutil unloadapp command to unload the current application before proceeding to the next step.

5. From the application list, start the new application by running sudo xmutil loadapp application_name . The platform configuration is automatically handled and starts the application. 

6. Applications with a Jupyter-based cockpit will start-up automatically. You need to point your web-browser to the associated IP address and port. The associated IP address and port information is printed to the UART at boot. To query your Jupyter lab server URL after the initial boot, run: sudo jupyter notebook list .

# Supported Peripherals

The following table outlines external peripherals that are tested with the corresponding accelerated applications. It is recommended that you use a peripheral from the list to ensure that you realize maximum platform performance.

Table: Accelerated Application Peripherals


| Accelerated Application | Peripheral | Part Number | 
|:-----------:|:-----------:|:-----------:|
| Smart camera | IAS camera sensor ISP interface (J7)  | OnSemi AR1335 sensor module. Avnet part number: CAVBA-000A  | 
| Smart camera | USB camera   | Logitech BRIO  | 
| Smart camera | Audio Codec I2S PMOD (J2)  | Digilent PMOD SKU 410-379  | 
| AI-Box-ReID  | IP camera  | Amcrest IP8M-2493EW  | 

The following table outlines external peripherals that are functionally verified with the KV260 Starter Kit.

Table: KV260 Starter Kit Functionally Tested Peripherals

| Peripheral  |  Part Number  | 
|:-----------:|:-----------:|
| IAS camera sensor ISP interface (J7)  | OnSemi AR0144 | 
| IAS camera sensor ISP interface (J7)  | OnSemi AR1335 | 
| IAS camera sensor direct interface (J8) | OnSemi AR1335 | 
| RPi camera interface (J9) | Raspberry Pi camera module v2 | 

# Xilinx Tools Integration

The K26LTD SOM and KV260 Starter Kit are integrated with the AMD Vitis™ software development platform and AMD Vivado™ Design Suite for rapid development of your unique applications on the platform.

## Vitis Platforms

Vitis base platforms are available in the kv260-vitis GitHub repository. For the KV260 Starter Kit, the following Vitis base platforms are available. Because additional KV260 base platforms are added and updated over time,
be sure to reference the repository for the most up to date list of platforms before starting your design work.

### kv260_ispMipiRx_vcu_DP

* Video capture using the IAS ISP MIPI interface for a AR1335 sensor module configuration
* Display using standard DisplayPort and/or HDMI™
* Audio transmit and receive (I2S) via PMOD audio codec
* Video codec unit (VCU) encode/decode and one stream encode buffer
* Support for 4k30 and 1080p30 in NV12 video formats

### kv260_vcuDecode_vmixDP

* VCU decode of four input streams
* Display using video mixer (VMIX) to DisplayPort and/or HDMI for 2x2 display configuration
* Resolution support for 1080p30 for each stream

### kv260_ispMipiRx_vmixDP

* Video capture using the IAS ISP MIPI interface for a AR0144 sensor module configuration
* VCU decoding of four streams
* Display using video mixer (VMIX) to DisplayPort and/or HDMI for 2x2 display configuration

Vitis base platforms are built within the context of a specific hardware target and the physical peripheral interfaces they enable.

```
starter-kit-name_interface1_interface2
```


For example, the kv260_ispMipiRx_vcu_DP base platform targets the KV260 Starter Kit and enables a MIPI receive interface to the ISP on the carrier card and a standard single video stream to the DisplayPort.

For additional information about the Vitis tools and Vitis base platform work flows, see the Embedded Design Development Using Vitis ([UG1701](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1701-vitis-accelerated-embedded&ft:locale=en-US)) and the Vitis Reference Guide ([UG1702](https://docs.amd.com/access/sources/dita/map?isLatest=true&url=ug1702-vitis-accelerated-reference&ft:locale=en-US)).

# Vivado Board Flow

The K26LTD SOM is enabled in the Vivado Design Suite through the Vivado Board Flow functionality. Vivado Board Flow enables a level of hardware abstraction that automatically configures peripherals fixed on the SOM card (e.g., DDR4), defines associated timing constraints, and presents the customizable physical I/O available on the SOM connector(s).

The Vivado SOM board model is available through the Vivado installation process as well as on the Vivado board file [GitHub](https://github.com/Xilinx/XilinxBoardStore/tree/HEAD/boards/Xilinx) repository. The following KV260 related Vivado board files are available.

### KV260 Starter Kit

* Configured K26 SOM with Vision Starter Kit companion card

### SM-K26-XCL2GC

* K26 commercial grade production SOM

### SM-K26-XCL2GI

* K26 industrial grade production SOM

The AMD SOM board flow infrastructure provides starter kit carrier card awareness through the Vivado tools companion card mechanism.

Automation for I/O connection and peripheral IP configuration when selecting a SOM and an associated carrier card, such as the KV260 Starter Kit,  is used to create a hardware configuration.

For additional information on using the Vivado tools and the Vivado board flow, refer to the Vivado Design Suite User Guide: System-Level Design Entry (UG895).

# Board Reset, Firmware Update, and Recovery

This section outlines the update and recovery mechanisms built into the KV260 Starter Kit. Two tools are provided for firmware updates. The first is a Linux based A/B update tool that supports remote and redundant firmware updates to the A/B firmware partitions of the QSPI device with custom  or AMD provided updates. The second tool is the Ethernet recovery tool that is intended to be used only when recovering a full platform to the original factory firmware.

## Board Reset

### Power-on Reset

1. The SOM reset signal (PS_POR_L) is held in reset until the CC_PS_PGOOD signal is asserted on the carrier card.

2. All the PS and PL I/O device reset signals on the carrier card are held in reset until 25 ms after the PS and PL power domain are powered up and stable.

3. You can perform a hard reset on the KV260 Starter Kit by pressing the reset button (CC SW2) or by commanding a reset through software.

The following figure shows the reset functions supported on the KV260 Starter Kit.

Figure: Device Reset

![](UG1089-media/image6.png)

## Firmware Update 

The firmware update button is the physical SW1/FWUEN push button located on the KV260 Starter Kit carrier card. The button is used to support two features:

1. To force the platform into a recovery mode application during power-on. The recovery application is described in the Boot Image Recovery Tool section of this document.

2. Security mechanism to prevent remote update of the boot firmware, without the user being physically present. 

## Boot Image Recovery Tool

The boot image recovery tool is a small application included in the AMD provided Starter Kit QSPI image. It provides a simple Ethernet-based interface  and application for updating the boot firmware if Linux is not functional. If Linux is functional, the recommendation is to update the boot firmware using the xmutil boot firmware update utilities. Refer to the Kria SOM Wiki page for details on how to use the boot image recovery tool.

## Boot Firmware A/B Update

As outlined in Boot Devices and Firmware Overview, the AMD starter kit and SOM provide two copies of the boot firmware in the QSPI device. This mechanism has a robust update infrastructure through a ping-pong methodology, where the last known good boot image is always kept available in the platform. The AMD starter kit Linux provides a utility for doing these updates entirely on-target. The steps for using the AMD SOM A/B update tool are documented in the Wiki page at: Boot FW Update Process.

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

For support resources such as Answers, Documentation, Downloads, and Forums, see Support.

# References

These documents provide supplemental material useful with this guide:

1. Kria SOM GitHub.io documentation

2. Kria KV260 Vision AI Starter Kit Data Sheet (DS986)

3. Kria K26 SOM Data Sheet (DS987)

4. Kria K26 SOM Thermal Design Guide (UG1090)

5. Kria SOM Carrier Card Design Guide (UG1091)

6. Vitis Model Composer User Guide (UG1483)

7. Vivado Design Suite User Guide: System-Level Design Entry (UG895)

8. Embedded Design Development Using Vitis (UG1701)

9. Vitis Reference Guide (UG1702)





