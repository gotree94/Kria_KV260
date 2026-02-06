--==============================================================================
-- KV260 LED Top Module - VHDL
-- 
-- Description:
--   최상위 LED 제어 엔티티
--   - 모드 선택에 따른 다양한 LED 패턴 출력
--   - ILA 디버깅 포트 포함
--
-- Target: Xilinx KRIA KV260
-- Tool: Vivado 2022.2
--==============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_top is
    generic (
        CLK_FREQ   : integer := 100_000_000;  -- 100 MHz
        BLINK_FREQ : integer := 1;            -- 1 Hz LED 블링크
        COUNT_FREQ : integer := 10            -- 10 Hz 카운터 업데이트
    );
    port (
        -- Clock and Reset
        clk        : in  std_logic;           -- 100 MHz 시스템 클럭
        rst_n      : in  std_logic;           -- Active-low 리셋
        
        -- Mode Selection
        sw         : in  std_logic_vector(1 downto 0);  -- 모드 선택 스위치
        
        -- LED Output
        led        : out std_logic_vector(7 downto 0);  -- 8비트 LED 출력
        
        -- ILA Debug Ports
        dbg_counter : out std_logic_vector(31 downto 0); -- 디버그: 카운터 값
        dbg_led_reg : out std_logic_vector(7 downto 0);  -- 디버그: LED 레지스터
        dbg_state   : out std_logic_vector(3 downto 0)   -- 디버그: FSM 상태
    );
end entity led_top;

architecture rtl of led_top is

    ----------------------------------------------------------------------------
    -- 상수 정의
    ----------------------------------------------------------------------------
    
    -- 모드 상수
    constant MODE_OFF     : std_logic_vector(1 downto 0) := "00";
    constant MODE_BLINK   : std_logic_vector(1 downto 0) := "01";
    constant MODE_COUNTER : std_logic_vector(1 downto 0) := "10";
    constant MODE_KNIGHT  : std_logic_vector(1 downto 0) := "11";
    
    -- FSM 상태
    type state_type is (ST_IDLE, ST_LEFT, ST_RIGHT);
    
    -- 분주 카운터 최대값
    constant DIV_1HZ_MAX  : integer := CLK_FREQ - 1;
    constant DIV_10HZ_MAX : integer := CLK_FREQ/10 - 1;
    constant DIV_20HZ_MAX : integer := CLK_FREQ/20 - 1;
    
    ----------------------------------------------------------------------------
    -- 신호 선언
    ----------------------------------------------------------------------------
    
    -- 레지스터
    signal counter     : unsigned(31 downto 0);
    signal led_reg     : std_logic_vector(7 downto 0);
    signal state       : state_type;
    signal knight_pos  : unsigned(2 downto 0);
    signal knight_dir  : std_logic;
    
    -- 분주 카운터
    signal div_1hz     : unsigned(31 downto 0);
    signal div_10hz    : unsigned(31 downto 0);
    signal div_20hz    : unsigned(31 downto 0);
    
    -- 분주 클럭 펄스
    signal tick_1hz    : std_logic;
    signal tick_10hz   : std_logic;
    signal tick_20hz   : std_logic;
    
    -- 서브 컴포넌트 출력
    signal blink_led   : std_logic_vector(7 downto 0);
    signal counter_led : std_logic_vector(7 downto 0);
    
    -- ILA 디버그 신호 (MARK_DEBUG 속성)
    signal ila_counter : std_logic_vector(31 downto 0);
    signal ila_led_reg : std_logic_vector(7 downto 0);
    signal ila_state   : std_logic_vector(3 downto 0);
    signal ila_mode    : std_logic_vector(1 downto 0);
    
    -- 속성 선언
    attribute MARK_DEBUG : string;
    attribute MARK_DEBUG of ila_counter : signal is "TRUE";
    attribute MARK_DEBUG of ila_led_reg : signal is "TRUE";
    attribute MARK_DEBUG of ila_state   : signal is "TRUE";
    attribute MARK_DEBUG of ila_mode    : signal is "TRUE";
    
    ----------------------------------------------------------------------------
    -- 컴포넌트 선언
    ----------------------------------------------------------------------------
    
    component led_blink is
        generic (
            CLK_FREQ   : integer;
            BLINK_FREQ : integer
        );
        port (
            clk   : in  std_logic;
            rst_n : in  std_logic;
            led   : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component led_counter is
        generic (
            CLK_FREQ    : integer;
            UPDATE_FREQ : integer
        );
        port (
            clk   : in  std_logic;
            rst_n : in  std_logic;
            led   : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    ----------------------------------------------------------------------------
    -- 클럭 분주기
    ----------------------------------------------------------------------------
    
    -- 1Hz 타이밍 생성
    tick_1hz <= '1' when div_1hz = DIV_1HZ_MAX else '0';
    
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            div_1hz <= (others => '0');
        elsif rising_edge(clk) then
            if tick_1hz = '1' then
                div_1hz <= (others => '0');
            else
                div_1hz <= div_1hz + 1;
            end if;
        end if;
    end process;
    
    -- 10Hz 타이밍 생성
    tick_10hz <= '1' when div_10hz = DIV_10HZ_MAX else '0';
    
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            div_10hz <= (others => '0');
        elsif rising_edge(clk) then
            if tick_10hz = '1' then
                div_10hz <= (others => '0');
            else
                div_10hz <= div_10hz + 1;
            end if;
        end if;
    end process;
    
    -- 20Hz 타이밍 생성
    tick_20hz <= '1' when div_20hz = DIV_20HZ_MAX else '0';
    
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            div_20hz <= (others => '0');
        elsif rising_edge(clk) then
            if tick_20hz = '1' then
                div_20hz <= (others => '0');
            else
                div_20hz <= div_20hz + 1;
            end if;
        end if;
    end process;
    
    ----------------------------------------------------------------------------
    -- LED Blink 인스턴스
    ----------------------------------------------------------------------------
    
    u_led_blink : led_blink
        generic map (
            CLK_FREQ   => CLK_FREQ,
            BLINK_FREQ => BLINK_FREQ
        )
        port map (
            clk   => clk,
            rst_n => rst_n,
            led   => blink_led
        );
    
    ----------------------------------------------------------------------------
    -- LED Counter 인스턴스
    ----------------------------------------------------------------------------
    
    u_led_counter : led_counter
        generic map (
            CLK_FREQ    => CLK_FREQ,
            UPDATE_FREQ => COUNT_FREQ
        )
        port map (
            clk   => clk,
            rst_n => rst_n,
            led   => counter_led
        );
    
    ----------------------------------------------------------------------------
    -- Knight Rider FSM
    ----------------------------------------------------------------------------
    
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            knight_pos <= (others => '0');
            knight_dir <= '0';
            state <= ST_IDLE;
        elsif rising_edge(clk) then
            if sw = MODE_KNIGHT and tick_20hz = '1' then
                case state is
                    when ST_IDLE =>
                        knight_pos <= (others => '0');
                        knight_dir <= '0';
                        state <= ST_LEFT;
                    
                    when ST_LEFT =>
                        if knight_pos = 7 then
                            knight_dir <= '1';
                            state <= ST_RIGHT;
                        else
                            knight_pos <= knight_pos + 1;
                        end if;
                    
                    when ST_RIGHT =>
                        if knight_pos = 0 then
                            knight_dir <= '0';
                            state <= ST_LEFT;
                        else
                            knight_pos <= knight_pos - 1;
                        end if;
                    
                    when others =>
                        state <= ST_IDLE;
                end case;
            elsif sw /= MODE_KNIGHT then
                state <= ST_IDLE;
            end if;
        end if;
    end process;
    
    ----------------------------------------------------------------------------
    -- 모드 멀티플렉서
    ----------------------------------------------------------------------------
    
    process(sw, blink_led, counter_led, knight_pos)
    begin
        case sw is
            when MODE_OFF =>
                led_reg <= (others => '0');
            when MODE_BLINK =>
                led_reg <= blink_led;
            when MODE_COUNTER =>
                led_reg <= counter_led;
            when MODE_KNIGHT =>
                led_reg <= std_logic_vector(shift_left(to_unsigned(1, 8), to_integer(knight_pos)));
            when others =>
                led_reg <= (others => '0');
        end case;
    end process;
    
    ----------------------------------------------------------------------------
    -- 범용 카운터 (ILA 디버그용)
    ----------------------------------------------------------------------------
    
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            counter <= (others => '0');
        elsif rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;
    
    ----------------------------------------------------------------------------
    -- ILA 디버그 레지스터
    ----------------------------------------------------------------------------
    
    process(clk)
    begin
        if rising_edge(clk) then
            ila_counter <= std_logic_vector(counter);
            ila_led_reg <= led_reg;
            ila_mode    <= sw;
            
            case state is
                when ST_IDLE  => ila_state <= "0000";
                when ST_LEFT  => ila_state <= "0001";
                when ST_RIGHT => ila_state <= "0010";
                when others   => ila_state <= "1111";
            end case;
        end if;
    end process;
    
    ----------------------------------------------------------------------------
    -- 출력 할당
    ----------------------------------------------------------------------------
    
    led <= led_reg;
    dbg_counter <= std_logic_vector(counter);
    dbg_led_reg <= led_reg;
    
    -- 상태를 std_logic_vector로 변환
    process(state)
    begin
        case state is
            when ST_IDLE  => dbg_state <= "0000";
            when ST_LEFT  => dbg_state <= "0001";
            when ST_RIGHT => dbg_state <= "0010";
            when others   => dbg_state <= "1111";
        end case;
    end process;

end architecture rtl;
