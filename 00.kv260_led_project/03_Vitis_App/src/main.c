/*==============================================================================
 * KV260 LED Control Application
 * 
 * PS에서 AXI GPIO를 통해 PL LED 모드를 제어합니다.
 * 
 * Modes:
 *   0: All OFF
 *   1: Blink (1Hz)
 *   2: Counter (10Hz)
 *   3: Knight Rider
 *============================================================================*/

#include <stdio.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"
#include "sleep.h"

/*------------------------------------------------------------------------------
 * Definitions
 *----------------------------------------------------------------------------*/
#define GPIO_DEVICE_ID  XPAR_AXI_GPIO_0_DEVICE_ID
#define GPIO_CHANNEL    1

#define MODE_OFF        0
#define MODE_BLINK      1
#define MODE_COUNTER    2
#define MODE_KNIGHT     3

/*------------------------------------------------------------------------------
 * Global Variables
 *----------------------------------------------------------------------------*/
XGpio Gpio;

/*------------------------------------------------------------------------------
 * Function Prototypes
 *----------------------------------------------------------------------------*/
int InitGpio(void);
void SetMode(u8 mode);
void PrintMenu(void);
void RunDemo(void);

/*------------------------------------------------------------------------------
 * Main
 *----------------------------------------------------------------------------*/
int main(void)
{
    int status;
    char input;
    
    xil_printf("\r\n");
    xil_printf("==========================================\r\n");
    xil_printf("  KV260 LED Control Application\r\n");
    xil_printf("==========================================\r\n\r\n");
    
    /* Initialize GPIO */
    status = InitGpio();
    if (status != XST_SUCCESS) {
        xil_printf("GPIO Init Failed!\r\n");
        return XST_FAILURE;
    }
    
    xil_printf("GPIO Initialized. Ready.\r\n\r\n");
    
    /* Set initial mode */
    SetMode(MODE_OFF);
    
    /* Main loop */
    while (1) {
        PrintMenu();
        input = inbyte();
        xil_printf("%c\r\n\r\n", input);
        
        switch (input) {
            case '0':
                xil_printf("Mode: OFF\r\n");
                SetMode(MODE_OFF);
                break;
                
            case '1':
                xil_printf("Mode: BLINK (1Hz)\r\n");
                SetMode(MODE_BLINK);
                break;
                
            case '2':
                xil_printf("Mode: COUNTER (Binary)\r\n");
                SetMode(MODE_COUNTER);
                break;
                
            case '3':
                xil_printf("Mode: KNIGHT RIDER\r\n");
                SetMode(MODE_KNIGHT);
                break;
                
            case 'd':
            case 'D':
                xil_printf("Running Demo...\r\n");
                RunDemo();
                break;
                
            case 'q':
            case 'Q':
                xil_printf("Exiting. LED OFF.\r\n");
                SetMode(MODE_OFF);
                return XST_SUCCESS;
                
            default:
                xil_printf("Invalid option.\r\n");
                break;
        }
    }
    
    return XST_SUCCESS;
}

/*------------------------------------------------------------------------------
 * Initialize GPIO
 *----------------------------------------------------------------------------*/
int InitGpio(void)
{
    int status;
    
    status = XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
    if (status != XST_SUCCESS) {
        return XST_FAILURE;
    }
    
    /* Set as output */
    XGpio_SetDataDirection(&Gpio, GPIO_CHANNEL, 0x00);
    
    return XST_SUCCESS;
}

/*------------------------------------------------------------------------------
 * Set LED Mode
 *----------------------------------------------------------------------------*/
void SetMode(u8 mode)
{
    XGpio_DiscreteWrite(&Gpio, GPIO_CHANNEL, mode & 0x03);
    xil_printf("  -> Mode register: 0x%02X\r\n", mode & 0x03);
}

/*------------------------------------------------------------------------------
 * Print Menu
 *----------------------------------------------------------------------------*/
void PrintMenu(void)
{
    xil_printf("\r\n");
    xil_printf("------------------------------------------\r\n");
    xil_printf("  LED Mode Selection\r\n");
    xil_printf("------------------------------------------\r\n");
    xil_printf("  0: OFF\r\n");
    xil_printf("  1: BLINK (1Hz)\r\n");
    xil_printf("  2: COUNTER (Binary 10Hz)\r\n");
    xil_printf("  3: KNIGHT RIDER\r\n");
    xil_printf("  D: Demo (cycle all modes)\r\n");
    xil_printf("  Q: Quit\r\n");
    xil_printf("------------------------------------------\r\n");
    xil_printf("Select: ");
}

/*------------------------------------------------------------------------------
 * Run Demo - Cycle through all modes
 *----------------------------------------------------------------------------*/
void RunDemo(void)
{
    xil_printf("\r\n[Demo] Mode: BLINK\r\n");
    SetMode(MODE_BLINK);
    sleep(5);
    
    xil_printf("\r\n[Demo] Mode: COUNTER\r\n");
    SetMode(MODE_COUNTER);
    sleep(5);
    
    xil_printf("\r\n[Demo] Mode: KNIGHT\r\n");
    SetMode(MODE_KNIGHT);
    sleep(5);
    
    xil_printf("\r\n[Demo] Mode: OFF\r\n");
    SetMode(MODE_OFF);
    
    xil_printf("\r\nDemo Complete.\r\n");
}
