/*==============================================================================
 * KV260 LED Control Application - Vitis
 *
 * Description:
 *   PS(Processing System)에서 PL(Programmable Logic) LED를 제어하는 예제
 *   - AXI GPIO를 통한 LED 직접 제어
 *   - 모드 선택 (sw[1:0]) 제어
 *   - 인터랙티브 메뉴 인터페이스
 *
 * Target: Xilinx KRIA KV260 Vision AI Starter Kit
 * Tool: Vitis 2022.2
 *============================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "sleep.h"
#include "xuartps.h"

/*------------------------------------------------------------------------------
 * 매크로 정의
 *----------------------------------------------------------------------------*/

/* AXI GPIO Device ID - xparameters.h에서 자동 생성됨 */
#ifndef XPAR_AXI_GPIO_0_DEVICE_ID
#define XPAR_AXI_GPIO_0_DEVICE_ID   0
#endif

/* GPIO 채널 정의 */
#define GPIO_CHANNEL_MODE   1       /* 모드 선택 (sw[1:0]) 출력 */
#define GPIO_CHANNEL_LED    2       /* LED 직접 제어 (옵션) */

/* LED 모드 정의 */
#define MODE_OFF            0x00    /* 모든 LED 꺼짐 */
#define MODE_BLINK          0x01    /* 1Hz 점멸 */
#define MODE_COUNTER        0x02    /* 바이너리 카운터 */
#define MODE_KNIGHT         0x03    /* Knight Rider 효과 */

/* LED 패턴 정의 */
#define LED_ALL_ON          0xFF
#define LED_ALL_OFF         0x00
#define LED_ALTERNATE_1     0xAA    /* 10101010 */
#define LED_ALTERNATE_2     0x55    /* 01011010 */

/* 지연 시간 (밀리초) */
#define DELAY_SHORT         100
#define DELAY_MEDIUM        250
#define DELAY_LONG          500

/*------------------------------------------------------------------------------
 * 전역 변수
 *----------------------------------------------------------------------------*/

XGpio GpioMode;             /* 모드 제어용 GPIO 인스턴스 */
XGpio GpioLed;              /* LED 직접 제어용 GPIO 인스턴스 (옵션) */

u8 CurrentMode = MODE_OFF;  /* 현재 모드 */
u8 DirectControl = 0;       /* 직접 제어 모드 플래그 */

/*------------------------------------------------------------------------------
 * 함수 프로토타입
 *----------------------------------------------------------------------------*/

int InitializeGpio(void);
void SetMode(u8 mode);
void SetLedDirect(u8 pattern);
void PrintMenu(void);
void PrintCurrentStatus(void);
void RunDemo(void);
void RunSequentialTest(void);
void RunBinaryCountDemo(void);
void RunKnightRiderDemo(void);
void RunCustomPattern(void);
char GetChar(void);

/*------------------------------------------------------------------------------
 * 메인 함수
 *----------------------------------------------------------------------------*/

int main(void)
{
    int status;
    char input;

    xil_printf("\r\n");
    xil_printf("==============================================================\r\n");
    xil_printf("  KV260 LED Control Application\r\n");
    xil_printf("  Vitis 2022.2\r\n");
    xil_printf("==============================================================\r\n");
    xil_printf("\r\n");

    /* GPIO 초기화 */
    status = InitializeGpio();
    if (status != XST_SUCCESS) {
        xil_printf("ERROR: GPIO initialization failed!\r\n");
        return XST_FAILURE;
    }

    xil_printf("GPIO initialized successfully.\r\n");
    xil_printf("\r\n");

    /* 초기 모드 설정 */
    SetMode(MODE_OFF);

    /* 메인 루프 */
    while (1) {
        PrintMenu();
        input = GetChar();
        xil_printf("\r\n");

        switch (input) {
            case '0':
                xil_printf("Setting mode: OFF\r\n");
                DirectControl = 0;
                SetMode(MODE_OFF);
                break;

            case '1':
                xil_printf("Setting mode: BLINK (1Hz)\r\n");
                DirectControl = 0;
                SetMode(MODE_BLINK);
                break;

            case '2':
                xil_printf("Setting mode: COUNTER (Binary)\r\n");
                DirectControl = 0;
                SetMode(MODE_COUNTER);
                break;

            case '3':
                xil_printf("Setting mode: KNIGHT RIDER\r\n");
                DirectControl = 0;
                SetMode(MODE_KNIGHT);
                break;

            case '4':
                xil_printf("LED Direct Control: ALL ON\r\n");
                DirectControl = 1;
                SetLedDirect(LED_ALL_ON);
                break;

            case '5':
                xil_printf("LED Direct Control: ALL OFF\r\n");
                DirectControl = 1;
                SetLedDirect(LED_ALL_OFF);
                break;

            case '6':
                xil_printf("LED Direct Control: Alternate Pattern 1 (0xAA)\r\n");
                DirectControl = 1;
                SetLedDirect(LED_ALTERNATE_1);
                break;

            case '7':
                xil_printf("LED Direct Control: Alternate Pattern 2 (0x55)\r\n");
                DirectControl = 1;
                SetLedDirect(LED_ALTERNATE_2);
                break;

            case '8':
                RunCustomPattern();
                break;

            case 'd':
            case 'D':
                xil_printf("Running Demo...\r\n");
                RunDemo();
                break;

            case 't':
            case 'T':
                xil_printf("Running Sequential Test...\r\n");
                RunSequentialTest();
                break;

            case 's':
            case 'S':
                PrintCurrentStatus();
                break;

            case 'q':
            case 'Q':
                xil_printf("Exiting... Setting LED OFF\r\n");
                SetMode(MODE_OFF);
                SetLedDirect(LED_ALL_OFF);
                xil_printf("Goodbye!\r\n");
                return XST_SUCCESS;

            default:
                xil_printf("Invalid option. Please try again.\r\n");
                break;
        }
    }

    return XST_SUCCESS;
}

/*------------------------------------------------------------------------------
 * GPIO 초기화
 *----------------------------------------------------------------------------*/

int InitializeGpio(void)
{
    int status;

    /* 모드 제어용 GPIO 초기화 */
    status = XGpio_Initialize(&GpioMode, XPAR_AXI_GPIO_0_DEVICE_ID);
    if (status != XST_SUCCESS) {
        xil_printf("ERROR: Mode GPIO init failed\r\n");
        return XST_FAILURE;
    }

    /* 채널 1: 모드 출력 (2비트) */
    XGpio_SetDataDirection(&GpioMode, GPIO_CHANNEL_MODE, 0x00);  /* Output */

    /* 채널 2: LED 직접 제어 (8비트) - 있는 경우 */
    XGpio_SetDataDirection(&GpioMode, GPIO_CHANNEL_LED, 0x00);   /* Output */

    /* 셀프 테스트 */
    status = XGpio_SelfTest(&GpioMode);
    if (status != XST_SUCCESS) {
        xil_printf("WARNING: GPIO self-test failed\r\n");
        /* 계속 진행 (일부 설정에서는 실패할 수 있음) */
    }

    return XST_SUCCESS;
}

/*------------------------------------------------------------------------------
 * 모드 설정 (PL 로직 제어)
 *----------------------------------------------------------------------------*/

void SetMode(u8 mode)
{
    CurrentMode = mode & 0x03;  /* 2비트만 사용 */
    XGpio_DiscreteWrite(&GpioMode, GPIO_CHANNEL_MODE, CurrentMode);

    xil_printf("  Mode register set to: 0x%02X\r\n", CurrentMode);
}

/*------------------------------------------------------------------------------
 * LED 직접 제어 (PS에서 직접 패턴 출력)
 *----------------------------------------------------------------------------*/

void SetLedDirect(u8 pattern)
{
    XGpio_DiscreteWrite(&GpioMode, GPIO_CHANNEL_LED, pattern);
    xil_printf("  LED pattern set to: 0x%02X (", pattern);

    /* 이진수로 출력 */
    for (int i = 7; i >= 0; i--) {
        xil_printf("%c", (pattern & (1 << i)) ? '1' : '0');
    }
    xil_printf(")\r\n");
}

/*------------------------------------------------------------------------------
 * 메뉴 출력
 *----------------------------------------------------------------------------*/

void PrintMenu(void)
{
    xil_printf("\r\n");
    xil_printf("============================================================\r\n");
    xil_printf("                    LED CONTROL MENU\r\n");
    xil_printf("------------------------------------------------------------\r\n");
    xil_printf("  [PL Mode Control]\r\n");
    xil_printf("    0. Mode OFF         - All LEDs off\r\n");
    xil_printf("    1. Mode BLINK       - 1Hz blinking\r\n");
    xil_printf("    2. Mode COUNTER     - Binary counter\r\n");
    xil_printf("    3. Mode KNIGHT      - Knight Rider effect\r\n");
    xil_printf("\r\n");
    xil_printf("  [PS Direct Control]\r\n");
    xil_printf("    4. All LEDs ON      - 0xFF\r\n");
    xil_printf("    5. All LEDs OFF     - 0x00\r\n");
    xil_printf("    6. Alternate 1      - 0xAA\r\n");
    xil_printf("    7. Alternate 2      - 0x55\r\n");
    xil_printf("    8. Custom Pattern   - Enter hex value\r\n");
    xil_printf("\r\n");
    xil_printf("  [Demo & Test]\r\n");
    xil_printf("    D. Run Demo         - All patterns demo\r\n");
    xil_printf("    T. Sequential Test  - Test each LED\r\n");
    xil_printf("    S. Show Status      - Current settings\r\n");
    xil_printf("\r\n");
    xil_printf("    Q. Quit\r\n");
    xil_printf("------------------------------------------------------------\r\n");
    xil_printf("Select option: ");
}

/*------------------------------------------------------------------------------
 * 현재 상태 출력
 *----------------------------------------------------------------------------*/

void PrintCurrentStatus(void)
{
    const char* modeNames[] = {"OFF", "BLINK", "COUNTER", "KNIGHT"};
    u32 modeReg, ledReg;

    modeReg = XGpio_DiscreteRead(&GpioMode, GPIO_CHANNEL_MODE);
    ledReg = XGpio_DiscreteRead(&GpioMode, GPIO_CHANNEL_LED);

    xil_printf("\r\n");
    xil_printf("============ CURRENT STATUS ============\r\n");
    xil_printf("  Control Mode    : %s\r\n", DirectControl ? "PS Direct" : "PL Logic");
    xil_printf("  PL Mode (sw)    : %s (0x%02X)\r\n", modeNames[CurrentMode], CurrentMode);
    xil_printf("  LED Register    : 0x%02X\r\n", (u8)ledReg);
    xil_printf("  LED Binary      : ");
    for (int i = 7; i >= 0; i--) {
        xil_printf("%c", (ledReg & (1 << i)) ? '1' : '0');
    }
    xil_printf("\r\n");
    xil_printf("=========================================\r\n");
}

/*------------------------------------------------------------------------------
 * 데모 실행
 *----------------------------------------------------------------------------*/

void RunDemo(void)
{
    xil_printf("\r\n--- Starting Demo (Press any key to stop) ---\r\n");

    /* 1. 순차 점등 */
    xil_printf("1. Sequential LED test...\r\n");
    for (int i = 0; i < 8; i++) {
        SetLedDirect(1 << i);
        usleep(DELAY_MEDIUM * 1000);
    }

    /* 2. 바이너리 카운트 */
    xil_printf("2. Binary count demo...\r\n");
    for (int i = 0; i < 16; i++) {
        SetLedDirect(i);
        usleep(DELAY_SHORT * 1000);
    }

    /* 3. 교차 패턴 */
    xil_printf("3. Alternate pattern...\r\n");
    for (int i = 0; i < 6; i++) {
        SetLedDirect(LED_ALTERNATE_1);
        usleep(DELAY_MEDIUM * 1000);
        SetLedDirect(LED_ALTERNATE_2);
        usleep(DELAY_MEDIUM * 1000);
    }

    /* 4. Knight Rider */
    xil_printf("4. Knight Rider demo...\r\n");
    for (int cycle = 0; cycle < 3; cycle++) {
        for (int i = 0; i < 8; i++) {
            SetLedDirect(1 << i);
            usleep(DELAY_SHORT * 1000);
        }
        for (int i = 6; i > 0; i--) {
            SetLedDirect(1 << i);
            usleep(DELAY_SHORT * 1000);
        }
    }

    /* 5. 전체 점멸 */
    xil_printf("5. Blink all...\r\n");
    for (int i = 0; i < 6; i++) {
        SetLedDirect(LED_ALL_ON);
        usleep(DELAY_LONG * 1000);
        SetLedDirect(LED_ALL_OFF);
        usleep(DELAY_LONG * 1000);
    }

    xil_printf("--- Demo Complete ---\r\n");
    SetLedDirect(LED_ALL_OFF);
}

/*------------------------------------------------------------------------------
 * 순차 테스트 (각 LED 개별 점검)
 *----------------------------------------------------------------------------*/

void RunSequentialTest(void)
{
    xil_printf("\r\n--- Sequential LED Test ---\r\n");

    for (int i = 0; i < 8; i++) {
        xil_printf("Testing LED[%d]... ", i);
        SetLedDirect(1 << i);
        usleep(500000);  /* 0.5초 */
        xil_printf("OK\r\n");
    }

    xil_printf("\r\n");
    xil_printf("All LEDs ON for 2 seconds...\r\n");
    SetLedDirect(LED_ALL_ON);
    sleep(2);

    SetLedDirect(LED_ALL_OFF);
    xil_printf("--- Test Complete ---\r\n");
}

/*------------------------------------------------------------------------------
 * 바이너리 카운트 데모
 *----------------------------------------------------------------------------*/

void RunBinaryCountDemo(void)
{
    xil_printf("\r\n--- Binary Count Demo (0-255) ---\r\n");
    xil_printf("Press any key to stop...\r\n");

    for (int i = 0; i <= 255; i++) {
        SetLedDirect(i);
        usleep(DELAY_SHORT * 1000);

        /* 16개마다 진행 표시 */
        if (i % 16 == 0) {
            xil_printf("  Count: %3d (0x%02X)\r\n", i, i);
        }
    }

    xil_printf("--- Count Complete ---\r\n");
}

/*------------------------------------------------------------------------------
 * Knight Rider 데모
 *----------------------------------------------------------------------------*/

void RunKnightRiderDemo(void)
{
    xil_printf("\r\n--- Knight Rider Demo ---\r\n");
    xil_printf("Press any key to stop...\r\n");

    for (int cycle = 0; cycle < 10; cycle++) {
        /* 좌 → 우 */
        for (int i = 0; i < 8; i++) {
            SetLedDirect(1 << i);
            usleep(80000);  /* 80ms */
        }
        /* 우 → 좌 */
        for (int i = 6; i > 0; i--) {
            SetLedDirect(1 << i);
            usleep(80000);
        }
    }

    SetLedDirect(LED_ALL_OFF);
    xil_printf("--- Demo Complete ---\r\n");
}

/*------------------------------------------------------------------------------
 * 사용자 정의 패턴 입력
 *----------------------------------------------------------------------------*/

void RunCustomPattern(void)
{
    char hexStr[4] = {0};
    u8 pattern;
    int idx = 0;
    char c;

    xil_printf("\r\n");
    xil_printf("Enter hex value (00-FF): 0x");

    /* 최대 2자리 16진수 입력 */
    while (idx < 2) {
        c = GetChar();

        if (c == '\r' || c == '\n') {
            break;
        }

        if ((c >= '0' && c <= '9') ||
            (c >= 'a' && c <= 'f') ||
            (c >= 'A' && c <= 'F')) {
            hexStr[idx++] = c;
            xil_printf("%c", c);  /* 에코 */
        }
    }

    xil_printf("\r\n");

    if (idx == 0) {
        xil_printf("Invalid input. Cancelled.\r\n");
        return;
    }

    /* 문자열을 숫자로 변환 */
    pattern = (u8)strtol(hexStr, NULL, 16);

    xil_printf("Setting custom pattern: 0x%02X\r\n", pattern);
    DirectControl = 1;
    SetLedDirect(pattern);
}

/*------------------------------------------------------------------------------
 * 문자 입력 (UART)
 *----------------------------------------------------------------------------*/

char GetChar(void)
{
    /* UART에서 한 문자 읽기 */
    return inbyte();
}
