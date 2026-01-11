/*******************************************************************************
 * KV260 BRAM AXI Test Application with ILA Debugging
 *
 * File: main.c
 * Description: BRAM read/write test program with interactive menu
 *              for ILA debugging on Kria KV260
 *
 * Author: Claude AI
 * Target: Xilinx Kria KV260 Vision AI Starter Kit
 * Vivado: 2022.2
 *
 * Memory Map:
 *   - BRAM Base Address: 0x80000000
 *   - BRAM Size: 8KB (2048 x 32-bit words)
 ******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xil_printf.h"
#include "xil_io.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "sleep.h"

/*******************************************************************************
 * 매크로 정의
 ******************************************************************************/
/* BRAM 베이스 주소 - xparameters.h에서 자동 생성되지만 명시적으로 정의 */
#ifndef XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR
#define XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR  0x80000000U
#endif

#define BRAM_BASE_ADDR      XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR
#define BRAM_SIZE_BYTES     (8 * 1024)          /* 8KB */
#define BRAM_SIZE_WORDS     (BRAM_SIZE_BYTES / 4)  /* 2048 words */
#define BRAM_MAX_OFFSET     (BRAM_SIZE_WORDS - 1)

/* 테스트 패턴 */
#define PATTERN_INCREMENT   0x00000001
#define PATTERN_DECREMENT   0xFFFFFFFF
#define PATTERN_CHECKERBOARD 0x55AA55AA
#define PATTERN_WALKING_ONE  0x00000001

/* UART 입력 버퍼 크기 */
#define INPUT_BUFFER_SIZE   64

/*******************************************************************************
 * 전역 변수
 ******************************************************************************/
static char input_buffer[INPUT_BUFFER_SIZE];

/*******************************************************************************
 * 함수 선언
 ******************************************************************************/
/* 메뉴 함수 */
void print_main_menu(void);
void print_separator(void);
void clear_input_buffer(void);
int get_user_input(void);
u32 get_hex_input(const char *prompt);
u32 get_dec_input(const char *prompt);

/* BRAM 기본 액세스 함수 */
void bram_write_single(u32 offset, u32 data);
u32 bram_read_single(u32 offset);
void bram_write_multiple(u32 start_offset, u32 *data, u32 count);
void bram_read_multiple(u32 start_offset, u32 *data, u32 count);
void bram_fill_all(u32 value);
void bram_read_all(void);

/* 테스트 함수 */
void test_write_single(void);
void test_write_multiple(void);
void test_fill_all(void);
void test_read_single(void);
void test_read_multiple(void);
void test_read_all(void);
void test_pattern_write(void);
void test_verify_pattern(void);
void test_ila_burst(void);

/* 유틸리티 함수 */
void hex_dump(u32 start_offset, u32 count);
int validate_offset(u32 offset);
void print_bram_info(void);

/*******************************************************************************
 * 메인 함수
 ******************************************************************************/
int main(void)
{
    int choice;
    int running = 1;

    /* 캐시 비활성화 (ILA 디버깅을 위해 - 모든 액세스가 실제로 AXI 버스로 전송됨) */
    Xil_DCacheDisable();

    /* 초기화 메시지 */
    xil_printf("\r\n");
    xil_printf("============================================================\r\n");
    xil_printf("   KV260 BRAM AXI Test Application with ILA Debugging\r\n");
    xil_printf("============================================================\r\n");
    xil_printf("\r\n");

    /* BRAM 정보 출력 */
    print_bram_info();

    /* 메인 루프 */
    while (running) {
        print_main_menu();
        choice = get_user_input();

        switch (choice) {
            /* 쓰기 테스트 */
            case 1:
                test_write_single();
                break;
            case 2:
                test_write_multiple();
                break;
            case 3:
                test_fill_all();
                break;

            /* 읽기 테스트 */
            case 4:
                test_read_single();
                break;
            case 5:
                test_read_multiple();
                break;
            case 6:
                test_read_all();
                break;

            /* 패턴 테스트 */
            case 7:
                test_pattern_write();
                break;
            case 8:
                test_verify_pattern();
                break;

            /* ILA 버스트 테스트 */
            case 9:
                test_ila_burst();
                break;

            /* Hex Dump */
            case 10:
                {
                    u32 start = get_dec_input("Start offset (decimal): ");
                    u32 count = get_dec_input("Word count: ");
                    if (validate_offset(start) && validate_offset(start + count - 1)) {
                        hex_dump(start, count);
                    }
                }
                break;

            /* BRAM 초기화 (0으로 채우기) */
            case 11:
                xil_printf("Clearing all BRAM to 0x00000000...\r\n");
                bram_fill_all(0x00000000);
                xil_printf("Done!\r\n");
                break;

            /* 정보 출력 */
            case 12:
                print_bram_info();
                break;

            /* 종료 */
            case 0:
                running = 0;
                xil_printf("\r\nExiting...\r\n");
                break;

            default:
                xil_printf("Invalid choice! Please try again.\r\n");
                break;
        }

        xil_printf("\r\n");
    }

    xil_printf("Program terminated.\r\n");
    return 0;
}

/*******************************************************************************
 * 메뉴 출력 함수
 ******************************************************************************/
void print_main_menu(void)
{
    xil_printf("\r\n");
    print_separator();
    xil_printf("                    MAIN MENU\r\n");
    print_separator();
    xil_printf("  [Write Operations]\r\n");
    xil_printf("    1. Write Single Word\r\n");
    xil_printf("    2. Write Multiple Words\r\n");
    xil_printf("    3. Fill All BRAM with Value\r\n");
    xil_printf("\r\n");
    xil_printf("  [Read Operations]\r\n");
    xil_printf("    4. Read Single Word\r\n");
    xil_printf("    5. Read Multiple Words\r\n");
    xil_printf("    6. Read All BRAM\r\n");
    xil_printf("\r\n");
    xil_printf("  [Pattern Tests]\r\n");
    xil_printf("    7. Write Test Pattern\r\n");
    xil_printf("    8. Verify Test Pattern\r\n");
    xil_printf("\r\n");
    xil_printf("  [ILA Debug]\r\n");
    xil_printf("    9. ILA Burst Test (rapid access)\r\n");
    xil_printf("\r\n");
    xil_printf("  [Utilities]\r\n");
    xil_printf("   10. Hex Dump\r\n");
    xil_printf("   11. Clear All BRAM\r\n");
    xil_printf("   12. Show BRAM Info\r\n");
    xil_printf("\r\n");
    xil_printf("    0. Exit\r\n");
    print_separator();
    xil_printf("Enter your choice: ");
}

void print_separator(void)
{
    xil_printf("------------------------------------------------------------\r\n");
}

/*******************************************************************************
 * 입력 처리 함수
 ******************************************************************************/
void clear_input_buffer(void)
{
    memset(input_buffer, 0, INPUT_BUFFER_SIZE);
}

int get_user_input(void)
{
    char c;
    int i = 0;
    int value;

    clear_input_buffer();

    /* 문자 입력 받기 */
    while (i < INPUT_BUFFER_SIZE - 1) {
        c = inbyte();  /* UART에서 1바이트 읽기 */

        if (c == '\r' || c == '\n') {
            xil_printf("\r\n");
            break;
        } else if (c == '\b' || c == 127) {  /* Backspace */
            if (i > 0) {
                i--;
                xil_printf("\b \b");
            }
        } else if (c >= '0' && c <= '9') {
            input_buffer[i++] = c;
            outbyte(c);  /* 에코 */
        }
    }
    input_buffer[i] = '\0';

    if (i == 0) {
        return -1;
    }

    value = atoi(input_buffer);
    return value;
}

u32 get_hex_input(const char *prompt)
{
    char c;
    int i = 0;
    u32 value = 0;

    xil_printf("%s", prompt);
    clear_input_buffer();

    while (i < 8) {  /* 최대 8자리 hex */
        c = inbyte();

        if (c == '\r' || c == '\n') {
            xil_printf("\r\n");
            break;
        } else if (c == '\b' || c == 127) {
            if (i > 0) {
                i--;
                xil_printf("\b \b");
            }
        } else if ((c >= '0' && c <= '9') ||
                   (c >= 'a' && c <= 'f') ||
                   (c >= 'A' && c <= 'F')) {
            input_buffer[i++] = c;
            outbyte(c);
        }
    }
    input_buffer[i] = '\0';

    /* Hex 문자열을 숫자로 변환 */
    value = (u32)strtoul(input_buffer, NULL, 16);
    return value;
}

u32 get_dec_input(const char *prompt)
{
    char c;
    int i = 0;
    u32 value = 0;

    xil_printf("%s", prompt);
    clear_input_buffer();

    while (i < 10) {  /* 최대 10자리 decimal */
        c = inbyte();

        if (c == '\r' || c == '\n') {
            xil_printf("\r\n");
            break;
        } else if (c == '\b' || c == 127) {
            if (i > 0) {
                i--;
                xil_printf("\b \b");
            }
        } else if (c >= '0' && c <= '9') {
            input_buffer[i++] = c;
            outbyte(c);
        }
    }
    input_buffer[i] = '\0';

    value = (u32)strtoul(input_buffer, NULL, 10);
    return value;
}

/*******************************************************************************
 * BRAM 기본 액세스 함수
 ******************************************************************************/

/**
 * @brief 단일 워드 쓰기
 * @param offset 워드 오프셋 (0 ~ BRAM_MAX_OFFSET)
 * @param data 쓸 데이터
 */
void bram_write_single(u32 offset, u32 data)
{
    u32 addr = BRAM_BASE_ADDR + (offset * 4);
    Xil_Out32(addr, data);
}

/**
 * @brief 단일 워드 읽기
 * @param offset 워드 오프셋 (0 ~ BRAM_MAX_OFFSET)
 * @return 읽은 데이터
 */
u32 bram_read_single(u32 offset)
{
    u32 addr = BRAM_BASE_ADDR + (offset * 4);
    return Xil_In32(addr);
}

/**
 * @brief 여러 워드 쓰기
 * @param start_offset 시작 워드 오프셋
 * @param data 데이터 배열 포인터
 * @param count 쓸 워드 개수
 */
void bram_write_multiple(u32 start_offset, u32 *data, u32 count)
{
    u32 i;
    u32 addr;

    for (i = 0; i < count; i++) {
        addr = BRAM_BASE_ADDR + ((start_offset + i) * 4);
        Xil_Out32(addr, data[i]);
    }
}

/**
 * @brief 여러 워드 읽기
 * @param start_offset 시작 워드 오프셋
 * @param data 데이터 저장 배열 포인터
 * @param count 읽을 워드 개수
 */
void bram_read_multiple(u32 start_offset, u32 *data, u32 count)
{
    u32 i;
    u32 addr;

    for (i = 0; i < count; i++) {
        addr = BRAM_BASE_ADDR + ((start_offset + i) * 4);
        data[i] = Xil_In32(addr);
    }
}

/**
 * @brief 전체 BRAM을 특정 값으로 채우기
 * @param value 채울 값
 */
void bram_fill_all(u32 value)
{
    u32 i;
    u32 addr;

    for (i = 0; i < BRAM_SIZE_WORDS; i++) {
        addr = BRAM_BASE_ADDR + (i * 4);
        Xil_Out32(addr, value);
    }
}

/**
 * @brief 전체 BRAM 읽기 (요약 출력)
 */
void bram_read_all(void)
{
    u32 i;
    u32 data;
    u32 non_zero_count = 0;
    u32 first_non_zero = 0;
    u32 last_non_zero = 0;

    xil_printf("Reading all BRAM (%d words)...\r\n", BRAM_SIZE_WORDS);

    for (i = 0; i < BRAM_SIZE_WORDS; i++) {
        data = bram_read_single(i);
        if (data != 0) {
            if (non_zero_count == 0) {
                first_non_zero = i;
            }
            last_non_zero = i;
            non_zero_count++;
        }
    }

    xil_printf("Summary:\r\n");
    xil_printf("  - Total words: %d\r\n", BRAM_SIZE_WORDS);
    xil_printf("  - Non-zero words: %d\r\n", non_zero_count);
    if (non_zero_count > 0) {
        xil_printf("  - First non-zero at offset: %d (0x%08X)\r\n",
                   first_non_zero, bram_read_single(first_non_zero));
        xil_printf("  - Last non-zero at offset: %d (0x%08X)\r\n",
                   last_non_zero, bram_read_single(last_non_zero));
    }
}

/*******************************************************************************
 * 테스트 함수 구현
 ******************************************************************************/

/**
 * @brief 단일 워드 쓰기 테스트
 */
void test_write_single(void)
{
    u32 offset, data;

    print_separator();
    xil_printf("=== Write Single Word ===\r\n");
    print_separator();

    offset = get_dec_input("Enter offset (0-%d): ");
    if (!validate_offset(offset)) {
        return;
    }

    data = get_hex_input("Enter data (hex): 0x");

    xil_printf("\r\nWriting 0x%08X to offset %d (addr: 0x%08X)...\r\n",
               data, offset, BRAM_BASE_ADDR + (offset * 4));

    bram_write_single(offset, data);

    /* 검증 읽기 */
    u32 readback = bram_read_single(offset);
    xil_printf("Readback: 0x%08X\r\n", readback);

    if (readback == data) {
        xil_printf("SUCCESS: Write verified!\r\n");
    } else {
        xil_printf("ERROR: Mismatch! Expected 0x%08X, got 0x%08X\r\n", data, readback);
    }
}

/**
 * @brief 여러 워드 쓰기 테스트
 */
void test_write_multiple(void)
{
    u32 start_offset, count, i;
    u32 data_buffer[64];  /* 최대 64 워드 */
    u32 pattern_choice;

    print_separator();
    xil_printf("=== Write Multiple Words ===\r\n");
    print_separator();

    start_offset = get_dec_input("Enter start offset: ");
    if (!validate_offset(start_offset)) {
        return;
    }

    count = get_dec_input("Enter word count (max 64): ");
    if (count > 64) {
        count = 64;
        xil_printf("Limited to 64 words.\r\n");
    }
    if (!validate_offset(start_offset + count - 1)) {
        xil_printf("ERROR: End offset exceeds BRAM size!\r\n");
        return;
    }

    xil_printf("\r\nSelect data pattern:\r\n");
    xil_printf("  1. Manual input for each word\r\n");
    xil_printf("  2. Incrementing (0x00, 0x01, 0x02, ...)\r\n");
    xil_printf("  3. Base value + offset\r\n");
    xil_printf("  4. Same value for all\r\n");
    xil_printf("Choice: ");
    pattern_choice = get_user_input();

    switch (pattern_choice) {
        case 1:
            for (i = 0; i < count; i++) {
                xil_printf("Data[%d]: 0x", i);
                data_buffer[i] = get_hex_input("");
            }
            break;
        case 2:
            for (i = 0; i < count; i++) {
                data_buffer[i] = i;
            }
            xil_printf("Pattern: 0x00, 0x01, 0x02, ...\r\n");
            break;
        case 3:
            {
                u32 base = get_hex_input("Enter base value: 0x");
                for (i = 0; i < count; i++) {
                    data_buffer[i] = base + i;
                }
                xil_printf("Pattern: 0x%08X, 0x%08X, 0x%08X, ...\r\n",
                           data_buffer[0], data_buffer[1], data_buffer[2]);
            }
            break;
        case 4:
            {
                u32 value = get_hex_input("Enter value: 0x");
                for (i = 0; i < count; i++) {
                    data_buffer[i] = value;
                }
            }
            break;
        default:
            xil_printf("Invalid choice, using incrementing pattern.\r\n");
            for (i = 0; i < count; i++) {
                data_buffer[i] = i;
            }
    }

    xil_printf("\r\nWriting %d words starting at offset %d...\r\n", count, start_offset);

    bram_write_multiple(start_offset, data_buffer, count);

    xil_printf("Write complete! Verifying...\r\n");

    /* 검증 */
    u32 errors = 0;
    for (i = 0; i < count; i++) {
        u32 readback = bram_read_single(start_offset + i);
        if (readback != data_buffer[i]) {
            xil_printf("ERROR at offset %d: expected 0x%08X, got 0x%08X\r\n",
                       start_offset + i, data_buffer[i], readback);
            errors++;
        }
    }

    if (errors == 0) {
        xil_printf("SUCCESS: All %d words verified!\r\n", count);
    } else {
        xil_printf("FAILED: %d errors found!\r\n", errors);
    }
}

/**
 * @brief 전체 BRAM을 특정 값으로 채우기 테스트
 */
void test_fill_all(void)
{
    u32 value;

    print_separator();
    xil_printf("=== Fill All BRAM with Value ===\r\n");
    print_separator();

    value = get_hex_input("Enter fill value: 0x");

    xil_printf("\r\nFilling all %d words with 0x%08X...\r\n", BRAM_SIZE_WORDS, value);

    bram_fill_all(value);

    xil_printf("Fill complete!\r\n");

    /* 샘플 검증 */
    xil_printf("Verifying samples...\r\n");
    u32 samples[] = {0, 100, 500, 1000, 1500, 2047};
    int num_samples = sizeof(samples) / sizeof(samples[0]);
    int errors = 0;

    for (int i = 0; i < num_samples; i++) {
        u32 readback = bram_read_single(samples[i]);
        if (readback != value) {
            xil_printf("ERROR at offset %d: expected 0x%08X, got 0x%08X\r\n",
                       samples[i], value, readback);
            errors++;
        }
    }

    if (errors == 0) {
        xil_printf("SUCCESS: Sample verification passed!\r\n");
    } else {
        xil_printf("FAILED: %d sample errors!\r\n", errors);
    }
}

/**
 * @brief 단일 워드 읽기 테스트
 */
void test_read_single(void)
{
    u32 offset, data;

    print_separator();
    xil_printf("=== Read Single Word ===\r\n");
    print_separator();

    offset = get_dec_input("Enter offset (0-%d): ");
    if (!validate_offset(offset)) {
        return;
    }

    data = bram_read_single(offset);

    xil_printf("\r\nAddress: 0x%08X\r\n", BRAM_BASE_ADDR + (offset * 4));
    xil_printf("Offset:  %d\r\n", offset);
    xil_printf("Data:    0x%08X (%u decimal)\r\n", data, data);
}

/**
 * @brief 여러 워드 읽기 테스트
 */
void test_read_multiple(void)
{
    u32 start_offset, count;

    print_separator();
    xil_printf("=== Read Multiple Words ===\r\n");
    print_separator();

    start_offset = get_dec_input("Enter start offset: ");
    if (!validate_offset(start_offset)) {
        return;
    }

    count = get_dec_input("Enter word count (max 64 for display): ");
    if (count > 64) {
        count = 64;
        xil_printf("Limited to 64 words for display.\r\n");
    }
    if (!validate_offset(start_offset + count - 1)) {
        xil_printf("ERROR: End offset exceeds BRAM size!\r\n");
        return;
    }

    xil_printf("\r\n");
    hex_dump(start_offset, count);
}

/**
 * @brief 전체 BRAM 읽기 테스트
 */
void test_read_all(void)
{
    print_separator();
    xil_printf("=== Read All BRAM ===\r\n");
    print_separator();

    bram_read_all();

    xil_printf("\r\nDisplay first 16 and last 16 words:\r\n");
    xil_printf("\r\n--- First 16 words ---\r\n");
    hex_dump(0, 16);
    xil_printf("\r\n--- Last 16 words ---\r\n");
    hex_dump(BRAM_SIZE_WORDS - 16, 16);
}

/**
 * @brief 테스트 패턴 쓰기
 */
void test_pattern_write(void)
{
    u32 pattern_choice;
    u32 i;

    print_separator();
    xil_printf("=== Write Test Pattern ===\r\n");
    print_separator();

    xil_printf("Select pattern:\r\n");
    xil_printf("  1. Incrementing (0, 1, 2, 3, ...)\r\n");
    xil_printf("  2. Address pattern (offset value)\r\n");
    xil_printf("  3. Checkerboard (0x55AA55AA / 0xAA55AA55)\r\n");
    xil_printf("  4. Walking ones\r\n");
    xil_printf("  5. All 0xFFFFFFFF\r\n");
    xil_printf("  6. All 0x00000000\r\n");
    xil_printf("Choice: ");
    pattern_choice = get_user_input();

    xil_printf("Writing pattern to all %d words...\r\n", BRAM_SIZE_WORDS);

    switch (pattern_choice) {
        case 1:
            for (i = 0; i < BRAM_SIZE_WORDS; i++) {
                bram_write_single(i, i);
            }
            xil_printf("Pattern: Incrementing\r\n");
            break;
        case 2:
            for (i = 0; i < BRAM_SIZE_WORDS; i++) {
                bram_write_single(i, BRAM_BASE_ADDR + (i * 4));
            }
            xil_printf("Pattern: Address values\r\n");
            break;
        case 3:
            for (i = 0; i < BRAM_SIZE_WORDS; i++) {
                bram_write_single(i, (i & 1) ? 0xAA55AA55 : 0x55AA55AA);
            }
            xil_printf("Pattern: Checkerboard\r\n");
            break;
        case 4:
            for (i = 0; i < BRAM_SIZE_WORDS; i++) {
                bram_write_single(i, 1 << (i % 32));
            }
            xil_printf("Pattern: Walking ones\r\n");
            break;
        case 5:
            bram_fill_all(0xFFFFFFFF);
            xil_printf("Pattern: All 0xFFFFFFFF\r\n");
            break;
        case 6:
            bram_fill_all(0x00000000);
            xil_printf("Pattern: All 0x00000000\r\n");
            break;
        default:
            xil_printf("Invalid choice!\r\n");
            return;
    }

    xil_printf("Pattern write complete!\r\n");
}

/**
 * @brief 테스트 패턴 검증
 */
void test_verify_pattern(void)
{
    u32 pattern_choice;
    u32 i, expected, actual;
    u32 errors = 0;

    print_separator();
    xil_printf("=== Verify Test Pattern ===\r\n");
    print_separator();

    xil_printf("Select pattern to verify:\r\n");
    xil_printf("  1. Incrementing (0, 1, 2, 3, ...)\r\n");
    xil_printf("  2. Address pattern (offset value)\r\n");
    xil_printf("  3. Checkerboard (0x55AA55AA / 0xAA55AA55)\r\n");
    xil_printf("  4. Walking ones\r\n");
    xil_printf("  5. All 0xFFFFFFFF\r\n");
    xil_printf("  6. All 0x00000000\r\n");
    xil_printf("Choice: ");
    pattern_choice = get_user_input();

    xil_printf("Verifying pattern...\r\n");

    for (i = 0; i < BRAM_SIZE_WORDS; i++) {
        switch (pattern_choice) {
            case 1:
                expected = i;
                break;
            case 2:
                expected = BRAM_BASE_ADDR + (i * 4);
                break;
            case 3:
                expected = (i & 1) ? 0xAA55AA55 : 0x55AA55AA;
                break;
            case 4:
                expected = 1 << (i % 32);
                break;
            case 5:
                expected = 0xFFFFFFFF;
                break;
            case 6:
                expected = 0x00000000;
                break;
            default:
                xil_printf("Invalid choice!\r\n");
                return;
        }

        actual = bram_read_single(i);
        if (actual != expected) {
            if (errors < 10) {  /* 처음 10개 에러만 출력 */
                xil_printf("ERROR at offset %d: expected 0x%08X, got 0x%08X\r\n",
                           i, expected, actual);
            }
            errors++;
        }
    }

    if (errors == 0) {
        xil_printf("SUCCESS: All %d words verified correctly!\r\n", BRAM_SIZE_WORDS);
    } else {
        xil_printf("FAILED: %d errors found!\r\n", errors);
    }
}

/**
 * @brief ILA 버스트 테스트 - 빠른 연속 액세스로 ILA에서 캡처하기 좋음
 */
void test_ila_burst(void)
{
    u32 burst_count;
    u32 i;
    volatile u32 dummy;  /* 최적화 방지 */

    print_separator();
    xil_printf("=== ILA Burst Test ===\r\n");
    print_separator();
    xil_printf("This test performs rapid consecutive accesses\r\n");
    xil_printf("for easy ILA capture. Set ILA trigger before running.\r\n");
    print_separator();

    xil_printf("\r\nSelect burst type:\r\n");
    xil_printf("  1. Write burst (100 consecutive writes)\r\n");
    xil_printf("  2. Read burst (100 consecutive reads)\r\n");
    xil_printf("  3. Mixed read/write burst\r\n");
    xil_printf("  4. Custom burst count\r\n");
    xil_printf("Choice: ");
    burst_count = get_user_input();

    xil_printf("\r\n*** Arm ILA trigger now! Press any key to start burst ***\r\n");
    inbyte();  /* 키 입력 대기 */

    switch (burst_count) {
        case 1:
            xil_printf("Starting write burst...\r\n");
            for (i = 0; i < 100; i++) {
                bram_write_single(i, 0xDEAD0000 | i);
            }
            xil_printf("Write burst complete!\r\n");
            break;

        case 2:
            xil_printf("Starting read burst...\r\n");
            for (i = 0; i < 100; i++) {
                dummy = bram_read_single(i);
            }
            (void)dummy;  /* 사용하지 않는 변수 경고 방지 */
            xil_printf("Read burst complete!\r\n");
            break;

        case 3:
            xil_printf("Starting mixed burst...\r\n");
            for (i = 0; i < 50; i++) {
                bram_write_single(i, 0xBEEF0000 | i);
                dummy = bram_read_single(i);
            }
            (void)dummy;
            xil_printf("Mixed burst complete!\r\n");
            break;

        case 4:
            {
                u32 count = get_dec_input("Enter burst count: ");
                if (count > BRAM_SIZE_WORDS) {
                    count = BRAM_SIZE_WORDS;
                }
                xil_printf("\r\n*** Press any key to start ***\r\n");
                inbyte();
                xil_printf("Starting custom burst (%d operations)...\r\n", count);
                for (i = 0; i < count; i++) {
                    bram_write_single(i % BRAM_SIZE_WORDS, 0xCAFE0000 | i);
                }
                xil_printf("Custom burst complete!\r\n");
            }
            break;

        default:
            xil_printf("Invalid choice!\r\n");
    }
}

/*******************************************************************************
 * 유틸리티 함수
 ******************************************************************************/

/**
 * @brief Hex 덤프 출력
 */
void hex_dump(u32 start_offset, u32 count)
{
    u32 i, j;
    u32 data;

    xil_printf("Offset    Address     Data\r\n");
    xil_printf("------    --------    --------\r\n");

    for (i = 0; i < count; i++) {
        data = bram_read_single(start_offset + i);
        xil_printf("%4d      0x%08X  0x%08X",
                   start_offset + i,
                   BRAM_BASE_ADDR + ((start_offset + i) * 4),
                   data);

        /* ASCII 표현 (printable characters만) */
        xil_printf("  |");
        for (j = 0; j < 4; j++) {
            char c = (data >> (24 - j * 8)) & 0xFF;
            if (c >= 32 && c < 127) {
                xil_printf("%c", c);
            } else {
                xil_printf(".");
            }
        }
        xil_printf("|\r\n");
    }
}

/**
 * @brief 오프셋 유효성 검사
 */
int validate_offset(u32 offset)
{
    if (offset > BRAM_MAX_OFFSET) {
        xil_printf("ERROR: Offset %d exceeds maximum %d!\r\n", offset, BRAM_MAX_OFFSET);
        return 0;
    }
    return 1;
}

/**
 * @brief BRAM 정보 출력
 */
void print_bram_info(void)
{
    xil_printf("BRAM Configuration:\r\n");
    xil_printf("  - Base Address: 0x%08X\r\n", BRAM_BASE_ADDR);
    xil_printf("  - End Address:  0x%08X\r\n", BRAM_BASE_ADDR + BRAM_SIZE_BYTES - 1);
    xil_printf("  - Size:         %d bytes (%d KB)\r\n", BRAM_SIZE_BYTES, BRAM_SIZE_BYTES/1024);
    xil_printf("  - Word Count:   %d (32-bit words)\r\n", BRAM_SIZE_WORDS);
    xil_printf("  - Valid Offset: 0 to %d\r\n", BRAM_MAX_OFFSET);
    xil_printf("\r\n");
    xil_printf("Note: Data Cache is DISABLED for accurate ILA debugging.\r\n");
}
