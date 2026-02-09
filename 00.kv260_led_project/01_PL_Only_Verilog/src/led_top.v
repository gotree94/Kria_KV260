`timescale 1ns / 1ps
//==============================================================================
// KV260 LED Top Module - PL Only Version (Verilog)
// 
// PS에서 클럭만 공급받고, LED 패턴은 자동 생성
// 모드는 하드코딩 (MODE 파라미터로 변경)
//==============================================================================

module led_top #(
    parameter CLK_FREQ = 100_000_000,  // 100 MHz
    parameter MODE = 2                  // 0:OFF, 1:BLINK, 2:COUNTER, 3:KNIGHT
)(
    input  wire       clk,              // pl_clk0 from PS
    input  wire       rst_n,            // pl_resetn0 from PS
    output reg  [7:0] led               // LED output
);

    //--------------------------------------------------------------------------
    // Internal signals
    //--------------------------------------------------------------------------
    reg [31:0] counter;
    reg [2:0]  knight_pos;
    reg        knight_dir;
    
    // Timing constants
    localparam TICK_1HZ  = CLK_FREQ - 1;           // 1 Hz
    localparam TICK_10HZ = CLK_FREQ / 10 - 1;      // 10 Hz
    localparam TICK_20HZ = CLK_FREQ / 20 - 1;      // 20 Hz
    
    //--------------------------------------------------------------------------
    // Main counter
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 32'd0;
        else
            counter <= counter + 1'b1;
    end
    
    //--------------------------------------------------------------------------
    // LED pattern generation based on MODE
    //--------------------------------------------------------------------------
    generate
        case (MODE)
            //------------------------------------------------------------------
            // MODE 0: All LEDs OFF
            //------------------------------------------------------------------
            0: begin
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n)
                        led <= 8'h00;
                    else
                        led <= 8'h00;
                end
            end
            
            //------------------------------------------------------------------
            // MODE 1: Blink all LEDs at 1Hz
            //------------------------------------------------------------------
            1: begin
                reg [31:0] blink_cnt;
                reg        blink_state;
                
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        blink_cnt <= 32'd0;
                        blink_state <= 1'b0;
                        led <= 8'h00;
                    end else begin
                        if (blink_cnt >= TICK_1HZ / 2) begin
                            blink_cnt <= 32'd0;
                            blink_state <= ~blink_state;
                        end else begin
                            blink_cnt <= blink_cnt + 1'b1;
                        end
                        led <= blink_state ? 8'hFF : 8'h00;
                    end
                end
            end
            
            //------------------------------------------------------------------
            // MODE 2: Binary counter at 10Hz
            //------------------------------------------------------------------
            2: begin
                reg [31:0] cnt_div;
                reg [7:0]  cnt_val;
                
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        cnt_div <= 32'd0;
                        cnt_val <= 8'd0;
                        led <= 8'h00;
                    end else begin
                        if (cnt_div >= TICK_10HZ) begin
                            cnt_div <= 32'd0;
                            cnt_val <= cnt_val + 1'b1;
                        end else begin
                            cnt_div <= cnt_div + 1'b1;
                        end
                        led <= cnt_val;
                    end
                end
            end
            
            //------------------------------------------------------------------
            // MODE 3: Knight Rider effect at 20Hz
            //------------------------------------------------------------------
            3: begin
                reg [31:0] knight_cnt;
                reg [2:0]  pos;
                reg        dir;
                
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        knight_cnt <= 32'd0;
                        pos <= 3'd0;
                        dir <= 1'b0;
                        led <= 8'h01;
                    end else begin
                        if (knight_cnt >= TICK_20HZ) begin
                            knight_cnt <= 32'd0;
                            
                            if (dir == 1'b0) begin
                                if (pos == 3'd7) begin
                                    dir <= 1'b1;
                                    pos <= 3'd6;
                                end else begin
                                    pos <= pos + 1'b1;
                                end
                            end else begin
                                if (pos == 3'd0) begin
                                    dir <= 1'b0;
                                    pos <= 3'd1;
                                end else begin
                                    pos <= pos - 1'b1;
                                end
                            end
                        end else begin
                            knight_cnt <= knight_cnt + 1'b1;
                        end
                        led <= 8'h01 << pos;
                    end
                end
            end
            
            //------------------------------------------------------------------
            // Default: Binary counter
            //------------------------------------------------------------------
            default: begin
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n)
                        led <= 8'h00;
                    else
                        led <= counter[26:19];  // Slow counter display
                end
            end
        endcase
    endgenerate

endmodule
