//==============================================================================
// KV260 LED Blink Module - Verilog
// 
// Description:
//   간단한 LED 점멸 모듈
//   - 지정된 주파수로 LED ON/OFF 반복
//   - 모든 8개 LED가 동시에 점멸
//
// Target: Xilinx KRIA KV260
// Tool: Vivado 2022.2
//==============================================================================

`timescale 1ns / 1ps

module led_blink #(
    parameter CLK_FREQ   = 100_000_000,  // 입력 클럭 주파수 (Hz)
    parameter BLINK_FREQ = 1             // LED 점멸 주파수 (Hz)
)(
    input  wire       clk,               // 시스템 클럭
    input  wire       rst_n,             // Active-low 리셋
    output wire [7:0] led                // LED 출력
);

    //--------------------------------------------------------------------------
    // 파라미터 계산
    //--------------------------------------------------------------------------
    
    // 반주기 카운트 값 (50% 듀티 사이클)
    localparam HALF_PERIOD = CLK_FREQ / (BLINK_FREQ * 2);
    
    // 카운터 비트 폭 계산
    localparam CNT_WIDTH = $clog2(HALF_PERIOD);
    
    //--------------------------------------------------------------------------
    // 내부 신호
    //--------------------------------------------------------------------------
    
    reg [CNT_WIDTH-1:0] counter;         // 분주 카운터
    reg                 led_state;       // LED 상태 (0: OFF, 1: ON)
    
    //--------------------------------------------------------------------------
    // 카운터 로직
    //--------------------------------------------------------------------------
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= {CNT_WIDTH{1'b0}};
            led_state <= 1'b0;
        end else begin
            if (counter >= HALF_PERIOD - 1) begin
                counter <= {CNT_WIDTH{1'b0}};
                led_state <= ~led_state;  // 상태 토글
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end
    
    //--------------------------------------------------------------------------
    // 출력 할당
    //--------------------------------------------------------------------------
    
    // 모든 LED가 동시에 ON/OFF
    assign led = led_state ? 8'hFF : 8'h00;

endmodule
