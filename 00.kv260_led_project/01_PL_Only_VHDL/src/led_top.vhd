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
    constant TICK_1HZ  : integer := CLK_FREQ - 1;
    constant TICK_10HZ : integer := CLK_FREQ / 10 - 1;
    constant TICK_20HZ : integer := CLK_FREQ / 20 - 1;
    
    -- Internal signals
    signal counter     : unsigned(31 downto 0) := (others => '0');
    signal led_reg     : std_logic_vector(7 downto 0) := (others => '0');
    
    -- For blink mode
    signal blink_cnt   : unsigned(31 downto 0) := (others => '0');
    signal blink_state : std_logic := '0';
    
    -- For counter mode
    signal cnt_div     : unsigned(31 downto 0) := (others => '0');
    signal cnt_val     : unsigned(7 downto 0) := (others => '0');
    
    -- For knight rider mode
    signal knight_cnt  : unsigned(31 downto 0) := (others => '0');
    signal knight_pos  : unsigned(2 downto 0) := (others => '0');
    signal knight_dir  : std_logic := '0';

begin

    -- Mode 0: All OFF
    gen_mode_off: if MODE = 0 generate
        process(clk, rst_n)
        begin
            if rst_n = '0' then
                led_reg <= (others => '0');
            elsif rising_edge(clk) then
                led_reg <= (others => '0');
            end if;
        end process;
    end generate;
    
    -- Mode 1: Blink at 1Hz
    gen_mode_blink: if MODE = 1 generate
        process(clk, rst_n)
        begin
            if rst_n = '0' then
                blink_cnt <= (others => '0');
                blink_state <= '0';
                led_reg <= (others => '0');
            elsif rising_edge(clk) then
                if blink_cnt >= TICK_1HZ / 2 then
                    blink_cnt <= (others => '0');
                    blink_state <= not blink_state;
                else
                    blink_cnt <= blink_cnt + 1;
                end if;
                
                if blink_state = '1' then
                    led_reg <= (others => '1');
                else
                    led_reg <= (others => '0');
                end if;
            end if;
        end process;
    end generate;
    
    -- Mode 2: Binary counter at 10Hz
    gen_mode_counter: if MODE = 2 generate
        process(clk, rst_n)
        begin
            if rst_n = '0' then
                cnt_div <= (others => '0');
                cnt_val <= (others => '0');
                led_reg <= (others => '0');
            elsif rising_edge(clk) then
                if cnt_div >= TICK_10HZ then
                    cnt_div <= (others => '0');
                    cnt_val <= cnt_val + 1;
                else
                    cnt_div <= cnt_div + 1;
                end if;
                led_reg <= std_logic_vector(cnt_val);
            end if;
        end process;
    end generate;
    
    -- Mode 3: Knight Rider at 20Hz
    gen_mode_knight: if MODE = 3 generate
        process(clk, rst_n)
        begin
            if rst_n = '0' then
                knight_cnt <= (others => '0');
                knight_pos <= (others => '0');
                knight_dir <= '0';
                led_reg <= "00000001";
            elsif rising_edge(clk) then
                if knight_cnt >= TICK_20HZ then
                    knight_cnt <= (others => '0');
                    
                    if knight_dir = '0' then
                        if knight_pos = 7 then
                            knight_dir <= '1';
                            knight_pos <= to_unsigned(6, 3);
                        else
                            knight_pos <= knight_pos + 1;
                        end if;
                    else
                        if knight_pos = 0 then
                            knight_dir <= '0';
                            knight_pos <= to_unsigned(1, 3);
                        else
                            knight_pos <= knight_pos - 1;
                        end if;
                    end if;
                else
                    knight_cnt <= knight_cnt + 1;
                end if;
                
                led_reg <= std_logic_vector(shift_left(to_unsigned(1, 8), to_integer(knight_pos)));
            end if;
        end process;
    end generate;
    
    -- Default mode (same as counter)
    gen_mode_default: if MODE < 0 or MODE > 3 generate
        process(clk, rst_n)
        begin
            if rst_n = '0' then
                counter <= (others => '0');
                led_reg <= (others => '0');
            elsif rising_edge(clk) then
                counter <= counter + 1;
                led_reg <= std_logic_vector(counter(26 downto 19));
            end if;
        end process;
    end generate;
    
    -- Output assignment
    led <= led_reg;

end architecture rtl;
