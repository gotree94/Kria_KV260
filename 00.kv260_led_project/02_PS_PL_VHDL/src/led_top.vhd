--==============================================================================
-- KV260 LED Top Module - PS+PL Version (VHDL)
-- 
-- PS에서 AXI GPIO를 통해 모드(sw)를 제어
--==============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_top is
    generic (
        CLK_FREQ : integer := 100_000_000   -- 100 MHz
    );
    port (
        clk   : in  std_logic;
        rst_n : in  std_logic;
        sw    : in  std_logic_vector(1 downto 0);
        led   : out std_logic_vector(7 downto 0)
    );
end entity led_top;

architecture rtl of led_top is
    
    -- Mode constants
    constant MODE_OFF     : std_logic_vector(1 downto 0) := "00";
    constant MODE_BLINK   : std_logic_vector(1 downto 0) := "01";
    constant MODE_COUNTER : std_logic_vector(1 downto 0) := "10";
    constant MODE_KNIGHT  : std_logic_vector(1 downto 0) := "11";
    
    -- Timing constants
    constant TICK_1HZ  : integer := CLK_FREQ - 1;
    constant TICK_10HZ : integer := CLK_FREQ / 10 - 1;
    constant TICK_20HZ : integer := CLK_FREQ / 20 - 1;
    
    -- Blink signals
    signal blink_cnt   : unsigned(31 downto 0) := (others => '0');
    signal blink_state : std_logic := '0';
    
    -- Counter signals
    signal cnt_div     : unsigned(31 downto 0) := (others => '0');
    signal cnt_val     : unsigned(7 downto 0) := (others => '0');
    
    -- Knight Rider signals
    signal knight_cnt  : unsigned(31 downto 0) := (others => '0');
    signal knight_pos  : unsigned(2 downto 0) := (others => '0');
    signal knight_dir  : std_logic := '0';
    
    -- Output register
    signal led_reg     : std_logic_vector(7 downto 0) := (others => '0');

begin

    -- Blink logic (1Hz)
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            blink_cnt <= (others => '0');
            blink_state <= '0';
        elsif rising_edge(clk) then
            if blink_cnt >= TICK_1HZ / 2 then
                blink_cnt <= (others => '0');
                blink_state <= not blink_state;
            else
                blink_cnt <= blink_cnt + 1;
            end if;
        end if;
    end process;
    
    -- Counter logic (10Hz)
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            cnt_div <= (others => '0');
            cnt_val <= (others => '0');
        elsif rising_edge(clk) then
            if cnt_div >= TICK_10HZ then
                cnt_div <= (others => '0');
                cnt_val <= cnt_val + 1;
            else
                cnt_div <= cnt_div + 1;
            end if;
        end if;
    end process;
    
    -- Knight Rider logic (20Hz)
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            knight_cnt <= (others => '0');
            knight_pos <= (others => '0');
            knight_dir <= '0';
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
        end if;
    end process;
    
    -- Mode multiplexer
    process(sw, blink_state, cnt_val, knight_pos)
    begin
        case sw is
            when MODE_OFF =>
                led_reg <= (others => '0');
            when MODE_BLINK =>
                if blink_state = '1' then
                    led_reg <= (others => '1');
                else
                    led_reg <= (others => '0');
                end if;
            when MODE_COUNTER =>
                led_reg <= std_logic_vector(cnt_val);
            when MODE_KNIGHT =>
                led_reg <= std_logic_vector(shift_left(to_unsigned(1, 8), to_integer(knight_pos)));
            when others =>
                led_reg <= (others => '0');
        end case;
    end process;
    
    -- Output assignment
    led <= led_reg;

end architecture rtl;
