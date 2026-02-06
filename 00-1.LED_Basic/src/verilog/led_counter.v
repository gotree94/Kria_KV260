//==============================================================================
// KV260 LED Counter Module - Verilog
// 
// Description:
//   8비트 바이너리 카운터로 LED 제어
//   - 지정된 주파수로 카운터 증가
//   - LED[7:0]에 카운터 값 출력
//
// Target: Xilinx KRIA KV260
// Tool: Vivado 2022.2
//==============================================================================

`timescale 1ns / 1ps

module led_counter #(
    parameter CLK_FREQ    = 100_000_000,  // 입력 클럭 주파수 (Hz)
    parameter UPDATE_FREQ = 10            // 카운터 업데이트 주파수 (Hz)
)(
    input  wire       clk,                // 시스템 클럭
    input  wire       rst_n,              // Active-low 리셋
    output wire [7:0] led                 // LED 출력
);

    //--------------------------------------------------------------------------
    // 파라미터 계산
    //--------------------------------------------------------------------------
    
    // 업데이트 주기 카운트 값
    localparam UPDATE_PERIOD = CLK_FREQ / UPDATE_FREQ;
    
    // 분주 카운터 비트 폭
    localparam DIV_WIDTH = $clog2(UPDATE_PERIOD);
    
    //--------------------------------------------------------------------------
    // 내부 신호
    //--------------------------------------------------------------------------
    
    reg [DIV_WIDTH-1:0] div_counter;     // 분주 카운터
    reg [7:0]           led_counter;     // LED 값 카운터
    wire                tick;            // 업데이트 펄스
    
    //--------------------------------------------------------------------------
    // 분주 카운터
    //--------------------------------------------------------------------------
    
    assign tick = (div_counter >= UPDATE_PERIOD - 1);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_counter <= {DIV_WIDTH{1'b0}};
        end else begin
            if (tick)
                div_counter <= {DIV_WIDTH{1'b0}};
            else
                div_counter <= div_counter + 1'b1;
        end
    end
    
    //--------------------------------------------------------------------------
    // LED 카운터
    //--------------------------------------------------------------------------
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led_counter <= 8'd0;
        end else begin
            if (tick)
                led_counter <= led_counter + 1'b1;  // 8비트 자동 롤오버
        end
    end
    
    //--------------------------------------------------------------------------
    // 출력 할당
    //--------------------------------------------------------------------------
    
    assign led = led_counter;

endmodule
