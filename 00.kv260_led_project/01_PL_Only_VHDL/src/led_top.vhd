--==============================================================================
-- KV260 LED Top Module - PL Only Version (VHDL)
-- 
-- PS에서 클럭만 공급받고, LED 패턴은 자동 생성
-- 모드는 제네릭으로 변경 (MODE generic)
--==============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_top is
    generic (
        CLK_FREQ : integer := 100_000_000;  -- 100 MHz
        MODE     : integer := 2              -- 0:OFF, 1:BLINK, 2:COUNTER, 3:KNIGHT
    );
    port (
        clk   : in  std_logic;
        rst_n : in  std_logic;
        led   : out std_logic_vector(7 downto 0)
    );
end entity led_top;

architecture rtl of led_top is
    
    -- Timing constants
    constant TICK_1HZ  : integer := CLK_FREQ / 2 - 1;      -- 0.5s (1Hz toggle)
    constant TICK_10HZ : integer := CLK_FREQ / 10 - 1;     -- 0.1s
    constant TICK_20HZ : integer := CLK_FREQ / 20 - 1;     -- 0.05s
    
    -- Internal signals
    signal led_reg     : std_logic_vector(7 downto 0) := (others => '0');
    signal div_cnt     : unsigned(31 downto 0) := (others => '0');
    signal cnt_val     : unsigned(7 downto 0) := (others => '0');
    signal blink_state : std_logic := '0';
    signal knight_pos  : integer range 0 to 7 := 0;
    signal knight_dir  : std_logic := '0';

begin

    -- Single process for all modes
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            div_cnt <= (others => '0');
            cnt_val <= (others => '0');
            blink_state <= '0';
            knight_pos <= 0;
            knight_dir <= '0';
            led_reg <= (others => '0');
            
        elsif rising_edge(clk) then
            
            -- Mode 0: All OFF
            if MODE = 0 then
                led_reg <= (others => '0');
            
            -- Mode 1: Blink at 1Hz
            elsif MODE = 1 then
                if div_cnt >= TICK_1HZ then
                    div_cnt <= (others => '0');
                    blink_state <= not blink_state;
                else
                    div_cnt <= div_cnt + 1;
                end if;
                
                if blink_state = '1' then
                    led_reg <= (others => '1');
                else
                    led_reg <= (others => '0');
                end if;
            
            -- Mode 2: Binary counter at 10Hz
            elsif MODE = 2 then
                if div_cnt >= TICK_10HZ then
                    div_cnt <= (others => '0');
                    cnt_val <= cnt_val + 1;
                else
                    div_cnt <= div_cnt + 1;
                end if;
                led_reg <= std_logic_vector(cnt_val);
            
            -- Mode 3: Knight Rider at 20Hz
            elsif MODE = 3 then
                if div_cnt >= TICK_20HZ then
                    div_cnt <= (others => '0');
                    
                    if knight_dir = '0' then
                        if knight_pos = 7 then
                            knight_dir <= '1';
                            knight_pos <= 6;
                        else
                            knight_pos <= knight_pos + 1;
                        end if;
                    else
                        if knight_pos = 0 then
                            knight_dir <= '0';
                            knight_pos <= 1;
                        else
                            knight_pos <= knight_pos - 1;
                        end if;
                    end if;
                else
                    div_cnt <= div_cnt + 1;
                end if;
                
                -- Set LED based on position
                led_reg <= (others => '0');
                led_reg(knight_pos) <= '1';
            
            -- Default: slow counter
            else
                div_cnt <= div_cnt + 1;
                led_reg <= std_logic_vector(div_cnt(26 downto 19));
            end if;
            
        end if;
    end process;
    
    -- Output assignment
    led <= led_reg;

end architecture rtl;
