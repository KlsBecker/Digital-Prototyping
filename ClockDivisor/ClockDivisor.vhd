--- Klaus Becker 
--- ClockDivisor.vhd

--- Include the necessary libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

--- Define the entity
entity ClockDivisor is
    port (
        switch : in STD_LOGIC;                          --- Switch to select the source of the counter, if switch = 0 then 1Hz clock,
                                                        --- if switch = 1 then press button five times to increment the count
        button : in STD_LOGIC;                          --- Button to increment the count
        reset : in STD_LOGIC;                           --- Button to reset the count
        clock50mhz : in STD_LOGIC;                      --- 50MHz clock input
        display0 : out STD_LOGIC_VECTOR(6 downto 0);    --- 7-segment display unit
        display1 : out STD_LOGIC_VECTOR(6 downto 0);    --- 7-segment display decade
        display2 : out STD_LOGIC_VECTOR(6 downto 0);    --- 7-segment display hundred
        display3 : out STD_LOGIC_VECTOR(6 downto 0);    --- 7-segment display thousand
        led : out STD_LOGIC_VECTOR(9 downto 0)          --- 10 LEDs display
    );
end ClockDivisor;

--- Define the architecture
architecture Behavioral of ClockDivisor is
    signal clk : integer range 0 to 25000000 := 0;
    signal clk1hz : STD_LOGIC := '0';
    signal clkcounter : integer range 0 to 1023 := 0;
    signal buttoncounter : integer range 0 to 1023 := 0;
    signal counter : integer range 0 to 1023 := 0;
    signal counter_unit : integer range 0 to 9 := 0;
    signal counter_decade : integer range 0 to 9 := 0;
    signal counter_hundred : integer range 0 to 9 := 0;
    signal counter_thousand : integer range 0 to 9 := 0;
    signal button_count : integer range 0 to 5 := 0;
begin

counter_unit <= counter mod 10;
counter_decade <= (counter / 10) mod 10;
counter_hundred <= (counter / 100) mod 10;
counter_thousand <= (counter / 1000) mod 10;
led <= conv_std_logic_vector(counter, 10);

--- Define the process for the clock division 50MHz to 1Hz
process (clock50mhz)
begin
    if rising_edge(clock50mhz) then
        if clk = 25000000 then
            clk <= 0;
            clk1hz <= not clk1hz;
        else
            clk <= clk + 1;
        end if;
    end if;
end process;

button_counter: process (button)
begin
    if reset = '0' then
        button_count <= 0;
    elsif falling_edge(button) then
        if button_count < 4 then
            button_count <= button_count + 1;
        else
            button_count <= 0;
            buttoncounter <= buttoncounter + 1;
        end if;
    end if;
end process;

clock_counter: process (clk1hz)
begin
    if reset = '0' then
        clkcounter <= 0;
    elsif rising_edge(clk1hz) then
        clkcounter <= clkcounter + 1;
    end if;
end process;

mux_counter: process (switch, clkcounter, buttoncounter)
begin
    if switch = '0' then
        counter <= clkcounter;
    elsif switch = '1' then
        counter <= buttoncounter;
    end if;
end process;

unit_display: process (counter_unit)
begin
    case counter_unit is
        when 0 => display0 <= "0000001";
        when 1 => display0 <= "1001111";
        when 2 => display0 <= "0010010";
        when 3 => display0 <= "0000110";
        when 4 => display0 <= "1001100";
        when 5 => display0 <= "0100100";
        when 6 => display0 <= "0100000";
        when 7 => display0 <= "0001111";
        when 8 => display0 <= "0000000";
        when 9 => display0 <= "0000100";
        when others => display0 <= "1111111";
    end case;
end process;

decade_display: process (counter_decade)
begin
    case counter_decade is
        when 0 => display1 <= "0000001";
        when 1 => display1 <= "1001111";
        when 2 => display1 <= "0010010";
        when 3 => display1 <= "0000110";
        when 4 => display1 <= "1001100";
        when 5 => display1 <= "0100100";
        when 6 => display1 <= "0100000";
        when 7 => display1 <= "0001111";
        when 8 => display1 <= "0000000";
        when 9 => display1 <= "0000100";
        when others => display1 <= "1111111";
    end case;
end process;

hundred_display: process (counter_hundred)
begin
    case counter_hundred is
        when 0 => display2 <= "0000001";
        when 1 => display2 <= "1001111";
        when 2 => display2 <= "0010010";
        when 3 => display2 <= "0000110";
        when 4 => display2 <= "1001100";
        when 5 => display2 <= "0100100";
        when 6 => display2 <= "0100000";
        when 7 => display2 <= "0001111";
        when 8 => display2 <= "0000000";
        when 9 => display2 <= "0000100";
        when others => display2 <= "1111111";
    end case;
end process;

thousand_display: process (counter_thousand)
begin
    case counter_thousand is
        when 0 => display3 <= "0000001";
        when 1 => display3 <= "1001111";
        when 2 => display3 <= "0010010";
        when 3 => display3 <= "0000110";
        when 4 => display3 <= "1001100";
        when 5 => display3 <= "0100100";
        when 6 => display3 <= "0100000";
        when 7 => display3 <= "0001111";
        when 8 => display3 <= "0000000";
        when 9 => display3 <= "0000100";
        when others => display3 <= "1111111";
    end case;
end process;

end Behavioral;