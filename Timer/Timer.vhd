-- File: Timer.vhd
-- Description: Digital Timer Embedded in DE10-Lite EVB
-- Universidade do Vale do Rio dos Sinos - UNISINOS
-- Digital Prototyping
-- Professor: Sandro Binsfeld Ferreira
-- Student: Klaus Becker

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Timer is
  port
  (
	CLK              : in std_logic;
	KEY              : in std_logic_vector (1 downto 0);
	SW               : in std_logic_vector (4 downto 0);
	LEDR             : out std_logic_vector (9 downto 0);
	DISPLAY_MIN_UNIT : out std_logic_vector (6 downto 0);
	DISPLAY_MIN_TENS : out std_logic_vector (6 downto 0);
	DISPLAY_SEC_UNIT : out std_logic_vector (6 downto 0);
	DISPLAY_SEC_TENS : out std_logic_vector (6 downto 0);
	DISPLAY_DOT      : out std_logic
  );
end Timer;

architecture Behavioral of Timer is
  constant PRESCALER : integer := 50000000; -- Constant for 1-second prescaler
  constant TIMER_MAX : integer := 3599; 	-- Constant for 1-hour timer

  signal reset               : std_logic                     := '0';
  signal upcount             : std_logic                     := '0';
  signal running             : std_logic                     := '0';
  signal clk_timer           : std_logic                     := '0';
  signal start_stop_button   : std_logic                     := '0';
  signal write_memory_button : std_logic                     := '0';
  signal timer_expired       : std_logic                     := '0';
  signal psc_count           : integer range 0 to PRESCALER  := 0;
  signal count               : integer range 0 to TIMER_MAX  := 0;
  signal count_aux           : integer range 0 to TIMER_MAX  := 0;
  signal mem1                : integer range 0 to TIMER_MAX  := 0;
  signal mem2                : integer range 0 to TIMER_MAX  := 0;
  signal mem3                : integer range 0 to TIMER_MAX  := 0;
  signal time_set            : integer                       := 30;
  signal display_select      : std_logic_vector (1 downto 0) := "00";
  signal timer_select        : std_logic_vector (1 downto 0) := "00";

  -- Function to convert a number to a 7-segment display pattern
  function to_7segment(num : integer) return std_logic_vector is
	variable seg             : std_logic_vector (6 downto 0);
  begin
	case num is
	  when 0      => seg      := "1000000"; -- 0
	  when 1      => seg      := "1111001"; -- 1
	  when 2      => seg      := "0100100"; -- 2
	  when 3      => seg      := "0110000"; -- 3
	  when 4      => seg      := "0011001"; -- 4
	  when 5      => seg      := "0010010"; -- 5
	  when 6      => seg      := "0000010"; -- 6
	  when 7      => seg      := "1111000"; -- 7
	  when 8      => seg      := "0000000"; -- 8
	  when 9      => seg      := "0010000"; -- 9
	  when others => seg 	  := "0000000"; -- Blank
	end case;
	return seg;
  end function;
begin

  start_stop_button   <= KEY(0);
  write_memory_button <= KEY(1);
  upcount             <= SW(0);
  timer_select        <= SW(4 downto 3);
  display_select      <= SW(2 downto 1);
  LEDR(2 downto 1)	  <= display_select;

  clock_divisor : process (CLK, start_stop_button)
  begin
	if start_stop_button = '0' then
	  psc_count <= 0;
	  clk_timer <= '0';
	elsif rising_edge(CLK) then
	  if psc_count = PRESCALER then
		psc_count <= 0;
		clk_timer <= not clk_timer;
	  else
		psc_count <= psc_count + 1;
	  end if;
	end if;
  end process;

  control_timer : process (start_stop_button, write_memory_button, display_select)
  begin
	if start_stop_button = '0' and write_memory_button = '0' then
	  reset   <= '1';
	  running <= '0';
	  count   <= time_set;
	  mem1    <= 0;
	  mem2    <= 0;
	  mem3    <= 0;
	else
	  reset <= '0';
	  if falling_edge(start_stop_button) then
		running <= not running;
	  end if;

	  if falling_edge(write_memory_button) then
		if mem1 = 0 then
		  mem1 <= count;
		elsif mem2 = 0 then
		  mem2 <= count;
		else
		  mem3 <= count;
		end if;
	  end if;
	end if;

	case display_select is
	  when "00" =>
		count <= count_aux;
	  when "01" =>
		count <= mem1;
	  when "10" =>
		count <= mem2;
	  when "11" =>
		count <= mem3;
	  when others =>
		count <= count_aux;
	end case;

	case timer_select is
	  when "00" =>
		time_set         <= 30;
		LEDR(7 downto 5) <= "000";
	  when "01" =>
		time_set         <= 60;
		LEDR(7 downto 5) <= "001";
	  when "10" =>
		time_set         <= 120;
		LEDR(7 downto 5) <= "011";
	  when "11" =>
		time_set         <= 300;
		LEDR(7 downto 5) <= "111";
	  when others =>
		time_set         <= 30;
		LEDR(7 downto 5) <= "000";
	end case;
  end process;

  counter_process : process (clk_timer, reset)
  begin
	if reset = '1' then
	  if upcount = '1' then
		count_aux <= 0;
	  else
		count_aux <= time_set;
	  end if;
	  timer_expired <= '0';
	elsif rising_edge(clk_timer) then
	  if running = '1' then
		if upcount = '1' then
		  if count_aux < time_set then
			count_aux <= count_aux + 1;
		  else
			timer_expired <= '1';
		  end if;
		else
		  if count_aux > 0 then
			count_aux <= count_aux - 1;
		  else
			timer_expired <= '1';
		  end if;
		end if;
	  end if;
	end if;
  end process;

  display_process : process (count, clk_timer)
  begin
	if timer_expired = '1' then
	  if clk_timer = '1' then
		DISPLAY_MIN_TENS <= "1111111";
		DISPLAY_MIN_UNIT <= "1111111";
		DISPLAY_SEC_TENS <= "1111111";
		DISPLAY_SEC_UNIT <= "1111111";
		DISPLAY_DOT      <= '1';
	  else
		DISPLAY_MIN_TENS <= to_7segment(time_set / 600); 			-- Minutes tens
		DISPLAY_MIN_UNIT <= to_7segment((time_set / 60) mod 10); 	-- Minutes unit
		DISPLAY_SEC_TENS <= to_7segment((time_set mod 60) / 10); 	-- Seconds tens
		DISPLAY_SEC_UNIT <= to_7segment(time_set mod 10); 			-- Seconds unit
		DISPLAY_DOT      <= '0';
	  end if;
	else
	  DISPLAY_MIN_TENS <= to_7segment(count / 600); 			-- Minutes tens
	  DISPLAY_MIN_UNIT <= to_7segment((count / 60) mod 10); 	-- Minutes unit
	  DISPLAY_SEC_TENS <= to_7segment((count mod 60) / 10); 	-- Seconds tens
	  DISPLAY_SEC_UNIT <= to_7segment(count mod 10); 			-- Seconds unit
	  DISPLAY_DOT      <= running and clk_timer;
	end if;
  end process;
end Behavioral;