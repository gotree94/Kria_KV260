--==============================================================================
-- KV260 LED Counter Module - VHDL
-- 
-- Description:
--   8비트 바이너리 카운터로 LED 제어
--   - 지정된 주파수로 카운터 증가
--   - LED[7:0]에 카운터 값 출력
--
-- Target: Xilinx KRIA KV260
-- Tool: Vivado 2022.2
--==============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_counter is
    generic (
        CLK_FREQ    : integer := 100_000_000;  -- 입력 클럭 주파수 (Hz)
        UPDATE_FREQ : integer := 10            -- 카운터 업데이트 주파수 (Hz)
    );
    port (
        clk   : in  std_logic;                     -- 시스템 클럭
        rst_n : in  std_logic;                     -- Active-low 리셋
        led   : out std_logic_vector(7 downto 0)   -- LED 출력
    );
end entity led_counter;

architecture rtl of led_counter is

    ----------------------------------------------------------------------------
    -- 상수 계산
    ----------------------------------------------------------------------------
    
    -- 업데이트 주기 카운트 값
    constant UPDATE_PERIOD : integer := CLK_FREQ / UPDATE_FREQ;
    
    ----------------------------------------------------------------------------
    -- 신호 선언
    ----------------------------------------------------------------------------
    
    signal div_counter : unsigned(31 downto 0);   -- 분주 카운터
    signal led_counter : unsigned(7 downto 0);    -- LED 값 카운터
    signal tick        : std_logic;               -- 업데이트 펄스

begin

    ----------------------------------------------------------------------------
    -- 분주 카운터
    ----------------------------------------------------------------------------
    
    tick <= '1' when div_counter >= UPDATE_PERIOD - 1 else '0';
    
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            div_counter <= (others => '0');
        elsif rising_edge(clk) then
            if tick = '1' then
                div_counter <= (others => '0');
            else
                div_counter <= div_counter + 1;
            end if;
        end if;
    end process;
    
    ----------------------------------------------------------------------------
    -- LED 카운터
    ----------------------------------------------------------------------------
    
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            led_counter <= (others => '0');
        elsif rising_edge(clk) then
            if tick = '1' then
                led_counter <= led_counter + 1;  -- 8비트 자동 롤오버
            end if;
        end if;
    end process;
    
    ----------------------------------------------------------------------------
    -- 출력 할당
    ----------------------------------------------------------------------------
    
    led <= std_logic_vector(led_counter);

end architecture rtl;
