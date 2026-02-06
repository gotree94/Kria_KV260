--==============================================================================
-- KV260 LED Blink Module - VHDL
-- 
-- Description:
--   간단한 LED 점멸 엔티티
--   - 지정된 주파수로 LED ON/OFF 반복
--   - 모든 8개 LED가 동시에 점멸
--
-- Target: Xilinx KRIA KV260
-- Tool: Vivado 2022.2
--==============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_blink is
    generic (
        CLK_FREQ   : integer := 100_000_000;  -- 입력 클럭 주파수 (Hz)
        BLINK_FREQ : integer := 1             -- LED 점멸 주파수 (Hz)
    );
    port (
        clk   : in  std_logic;                -- 시스템 클럭
        rst_n : in  std_logic;                -- Active-low 리셋
        led   : out std_logic_vector(7 downto 0)  -- LED 출력
    );
end entity led_blink;

architecture rtl of led_blink is

    ----------------------------------------------------------------------------
    -- 상수 계산
    ----------------------------------------------------------------------------
    
    -- 반주기 카운트 값 (50% 듀티 사이클)
    constant HALF_PERIOD : integer := CLK_FREQ / (BLINK_FREQ * 2);
    
    ----------------------------------------------------------------------------
    -- 신호 선언
    ----------------------------------------------------------------------------
    
    signal counter   : unsigned(31 downto 0);  -- 분주 카운터
    signal led_state : std_logic;              -- LED 상태 (0: OFF, 1: ON)

begin

    ----------------------------------------------------------------------------
    -- 카운터 로직
    ----------------------------------------------------------------------------
    
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            counter <= (others => '0');
            led_state <= '0';
        elsif rising_edge(clk) then
            if counter >= HALF_PERIOD - 1 then
                counter <= (others => '0');
                led_state <= not led_state;  -- 상태 토글
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    ----------------------------------------------------------------------------
    -- 출력 할당
    ----------------------------------------------------------------------------
    
    -- 모든 LED가 동시에 ON/OFF
    led <= (others => '1') when led_state = '1' else (others => '0');

end architecture rtl;
