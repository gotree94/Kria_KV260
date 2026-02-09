`timescale 1ns / 1ps
//==============================================================================
// KV260 LED Top Module - PS+PL Version (Verilog)
// 
// PS에서 AXI GPIO를 통해 모드(sw)를 제어
//==============================================================================

module led_top #(
    parameter CLK_FREQ = 100_000_000   // 100 MHz
)(
    input  wire       clk,              // pl_clk0 from PS
    input  wire       rst_n,            // pl_resetn0 from PS
    input  wire [1:0] sw,               // Mode select from AXI GPIO
    output reg  [7:0] led               // LED output
);

    //--------------------------------------------------------------------------
    // Mode constants
    //--------------------------------------------------------------------------
    localparam MODE_OFF     = 2'b00;
    localparam MODE_BLINK   = 2'b01;
    localparam MODE_COUNTER = 2'b10;
    localparam MODE_KNIGHT  = 2'b11;
    
    // Timing constants
    localparam TICK_1HZ  = CLK_FREQ - 1;
    localparam TICK_10HZ = CLK_FREQ / 10 - 1;
    localparam TICK_20HZ = CLK_FREQ / 20 - 1;
    
    //--------------------------------------------------------------------------
    // Internal signals
    //--------------------------------------------------------------------------
    reg [31:0] blink_cnt;
    reg        blink_state;
    
    reg [31:0] cnt_div;
    reg [7:0]  cnt_val;
    
    reg [31:0] knight_cnt;
    reg [2:0]  knight_pos;
    reg        knight_dir;
    
    //--------------------------------------------------------------------------
    // Blink logic (1Hz)
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            blink_cnt <= 32'd0;
            blink_state <= 1'b0;
        end else begin
            if (blink_cnt >= TICK_1HZ / 2) begin
                blink_cnt <= 32'd0;
                blink_state <= ~blink_state;
            end else begin
                blink_cnt <= blink_cnt + 1'b1;
            end
        end
    end
    
    //--------------------------------------------------------------------------
    // Counter logic (10Hz)
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_div <= 32'd0;
            cnt_val <= 8'd0;
        end else begin
            if (cnt_div >= TICK_10HZ) begin
                cnt_div <= 32'd0;
                cnt_val <= cnt_val + 1'b1;
            end else begin
                cnt_div <= cnt_div + 1'b1;
            end
        end
    end
    
    //--------------------------------------------------------------------------
    // Knight Rider logic (20Hz)
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            knight_cnt <= 32'd0;
            knight_pos <= 3'd0;
            knight_dir <= 1'b0;
        end else begin
            if (knight_cnt >= TICK_20HZ) begin
                knight_cnt <= 32'd0;
                
                if (knight_dir == 1'b0) begin
                    if (knight_pos == 3'd7) begin
                        knight_dir <= 1'b1;
                        knight_pos <= 3'd6;
                    end else begin
                        knight_pos <= knight_pos + 1'b1;
                    end
                end else begin
                    if (knight_pos == 3'd0) begin
                        knight_dir <= 1'b0;
                        knight_pos <= 3'd1;
                    end else begin
                        knight_pos <= knight_pos - 1'b1;
                    end
                end
            end else begin
                knight_cnt <= knight_cnt + 1'b1;
            end
        end
    end
    
    //--------------------------------------------------------------------------
    // Mode multiplexer
    //--------------------------------------------------------------------------
    always @(*) begin
        case (sw)
            MODE_OFF:     led = 8'h00;
            MODE_BLINK:   led = blink_state ? 8'hFF : 8'h00;
            MODE_COUNTER: led = cnt_val;
            MODE_KNIGHT:  led = 8'h01 << knight_pos;
            default:      led = 8'h00;
        endcase
    end

endmodule
