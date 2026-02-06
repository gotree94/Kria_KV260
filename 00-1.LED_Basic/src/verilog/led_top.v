//==============================================================================
// KV260 LED Top Module - Verilog
// 
// Description:
//   최상위 LED 제어 모듈
//   - 모드 선택에 따른 다양한 LED 패턴 출력
//   - ILA 디버깅 포트 포함
//
// Target: Xilinx KRIA KV260
// Tool: Vivado 2022.2
//==============================================================================

`timescale 1ns / 1ps

module led_top #(
    parameter CLK_FREQ   = 100_000_000,  // 100 MHz
    parameter BLINK_FREQ = 1,            // 1 Hz LED 블링크
    parameter COUNT_FREQ = 10            // 10 Hz 카운터 업데이트
)(
    // Clock and Reset
    input  wire        clk,              // 100 MHz 시스템 클럭
    input  wire        rst_n,            // Active-low 리셋
    
    // Mode Selection
    input  wire [1:0]  sw,               // 모드 선택 스위치
    
    // LED Output
    output wire [7:0]  led,              // 8비트 LED 출력
    
    // ILA Debug Ports (optional - synthesis attribute로 보존)
    output wire [31:0] dbg_counter,      // 디버그: 카운터 값
    output wire [7:0]  dbg_led_reg,      // 디버그: LED 레지스터
    output wire [3:0]  dbg_state         // 디버그: FSM 상태
);

    //--------------------------------------------------------------------------
    // 내부 신호 선언
    //--------------------------------------------------------------------------
    
    // 모드 상수
    localparam MODE_OFF     = 2'b00;
    localparam MODE_BLINK   = 2'b01;
    localparam MODE_COUNTER = 2'b10;
    localparam MODE_KNIGHT  = 2'b11;
    
    // FSM 상태 (Knight Rider 모드용)
    localparam ST_IDLE      = 4'd0;
    localparam ST_LEFT      = 4'd1;
    localparam ST_RIGHT     = 4'd2;
    
    // 레지스터
    reg [31:0] counter;                  // 범용 카운터
    reg [7:0]  led_reg;                  // LED 출력 레지스터
    reg [3:0]  state;                    // FSM 상태
    reg [2:0]  knight_pos;               // Knight Rider 위치
    reg        knight_dir;               // 0: 좌→우, 1: 우→좌
    
    // 분주 클럭
    wire       tick_1hz;                 // 1Hz 펄스
    wire       tick_10hz;                // 10Hz 펄스
    wire       tick_20hz;                // 20Hz 펄스 (Knight Rider용)
    
    // 서브모듈 출력
    wire [7:0] blink_led;
    wire [7:0] counter_led;
    
    //--------------------------------------------------------------------------
    // 클럭 분주기
    //--------------------------------------------------------------------------
    
    // 1Hz 타이밍 생성
    reg [31:0] div_1hz;
    assign tick_1hz = (div_1hz == CLK_FREQ - 1);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_1hz <= 32'd0;
        end else begin
            if (tick_1hz)
                div_1hz <= 32'd0;
            else
                div_1hz <= div_1hz + 1'b1;
        end
    end
    
    // 10Hz 타이밍 생성
    reg [31:0] div_10hz;
    assign tick_10hz = (div_10hz == CLK_FREQ/10 - 1);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_10hz <= 32'd0;
        end else begin
            if (tick_10hz)
                div_10hz <= 32'd0;
            else
                div_10hz <= div_10hz + 1'b1;
        end
    end
    
    // 20Hz 타이밍 생성 (Knight Rider)
    reg [31:0] div_20hz;
    assign tick_20hz = (div_20hz == CLK_FREQ/20 - 1);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_20hz <= 32'd0;
        end else begin
            if (tick_20hz)
                div_20hz <= 32'd0;
            else
                div_20hz <= div_20hz + 1'b1;
        end
    end
    
    //--------------------------------------------------------------------------
    // LED Blink 인스턴스
    //--------------------------------------------------------------------------
    
    led_blink #(
        .CLK_FREQ(CLK_FREQ),
        .BLINK_FREQ(BLINK_FREQ)
    ) u_led_blink (
        .clk(clk),
        .rst_n(rst_n),
        .led(blink_led)
    );
    
    //--------------------------------------------------------------------------
    // LED Counter 인스턴스
    //--------------------------------------------------------------------------
    
    led_counter #(
        .CLK_FREQ(CLK_FREQ),
        .UPDATE_FREQ(COUNT_FREQ)
    ) u_led_counter (
        .clk(clk),
        .rst_n(rst_n),
        .led(counter_led)
    );
    
    //--------------------------------------------------------------------------
    // Knight Rider FSM
    //--------------------------------------------------------------------------
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            knight_pos <= 3'd0;
            knight_dir <= 1'b0;
            state <= ST_IDLE;
        end else begin
            if (sw == MODE_KNIGHT && tick_20hz) begin
                case (state)
                    ST_IDLE: begin
                        knight_pos <= 3'd0;
                        knight_dir <= 1'b0;
                        state <= ST_LEFT;
                    end
                    
                    ST_LEFT: begin
                        if (knight_pos == 3'd7) begin
                            knight_dir <= 1'b1;
                            state <= ST_RIGHT;
                        end else begin
                            knight_pos <= knight_pos + 1'b1;
                        end
                    end
                    
                    ST_RIGHT: begin
                        if (knight_pos == 3'd0) begin
                            knight_dir <= 1'b0;
                            state <= ST_LEFT;
                        end else begin
                            knight_pos <= knight_pos - 1'b1;
                        end
                    end
                    
                    default: state <= ST_IDLE;
                endcase
            end else if (sw != MODE_KNIGHT) begin
                state <= ST_IDLE;
            end
        end
    end
    
    //--------------------------------------------------------------------------
    // 모드 멀티플렉서
    //--------------------------------------------------------------------------
    
    always @(*) begin
        case (sw)
            MODE_OFF:     led_reg = 8'h00;
            MODE_BLINK:   led_reg = blink_led;
            MODE_COUNTER: led_reg = counter_led;
            MODE_KNIGHT:  led_reg = 8'h01 << knight_pos;
            default:      led_reg = 8'h00;
        endcase
    end
    
    //--------------------------------------------------------------------------
    // 카운터 (ILA 디버그용)
    //--------------------------------------------------------------------------
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 32'd0;
        else
            counter <= counter + 1'b1;
    end
    
    //--------------------------------------------------------------------------
    // 출력 할당
    //--------------------------------------------------------------------------
    
    assign led = led_reg;
    
    // ILA 디버그 포트
    assign dbg_counter = counter;
    assign dbg_led_reg = led_reg;
    assign dbg_state   = state;
    
    //--------------------------------------------------------------------------
    // ILA 보존을 위한 속성 (합성 시 최적화 방지)
    //--------------------------------------------------------------------------
    
    (* mark_debug = "true" *) reg [31:0] ila_counter;
    (* mark_debug = "true" *) reg [7:0]  ila_led_reg;
    (* mark_debug = "true" *) reg [3:0]  ila_state;
    (* mark_debug = "true" *) reg [1:0]  ila_mode;
    
    always @(posedge clk) begin
        ila_counter <= counter;
        ila_led_reg <= led_reg;
        ila_state   <= state;
        ila_mode    <= sw;
    end

endmodule
