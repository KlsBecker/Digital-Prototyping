--- Include the necessary libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

--- Define the entity
entity ParkManager is
    port (
        clock                   : in std_logic;
        reset                   : in std_logic;
        inSectorA               : in std_logic;
        inSectorB               : in std_logic;
        outSectorA              : in std_logic;
        outSectorB              : in std_logic;
        displaySectorA_decade   : out std_logic_vector(6 downto 0);
        displaySectorA_unit     : out std_logic_vector(6 downto 0);
        displaySectorB_decade   : out std_logic_vector(6 downto 0);
        displaySectorB_unit     : out std_logic_vector(6 downto 0);
        displayParking_Decade   : out std_logic_vector(6 downto 0);
        displayParking_Unit     : out std_logic_vector(6 downto 0);
        display_led             : out std_logic_vector(9 downto 0)
    );
end entity ParkManager;

--- Define the architecture
architecture Behavioral of ParkManager is
    signal inSectorA_debounced      : std_logic;
    signal inSectorB_debounced      : std_logic;
    signal outSectorA_debounced     : std_logic;
    signal outSectorB_debounced     : std_logic;
    signal counter_sectorA          : integer range 0 to 9 := 0;
    signal counter_sectorB          : integer range 0 to 9 := 0;
    signal counter_parking          : integer range 0 to 18 := 0;
    signal counter_sectorA_decade   : integer range 0 to 9 := 0;
    signal counter_sectorA_unit     : integer range 0 to 9 := 0;
    signal counter_sectorB_decade   : integer range 0 to 9 := 0;
    signal counter_sectorB_unit     : integer range 0 to 9 := 0;
    signal counter_parking_decade   : integer range 0 to 9 := 0;
    signal counter_parking_unit     : integer range 0 to 9 := 0;
    signal event_parking_debounced  : std_logic;
begin
    
debounce: process(clock)
    constant MAX_COUNTER : integer := 1000000;
    variable counter_inSectorA  : integer range 0 to MAX_COUNTER := 0;
    variable counter_inSectorB  : integer range 0 to MAX_COUNTER := 0;
    variable counter_outSectorA : integer range 0 to MAX_COUNTER := 0;
    variable counter_outSectorB : integer range 0 to MAX_COUNTER := 0;
begin
    if rising_edge(clock) then
        if inSectorA = '1' then
            if counter_inSectorA < MAX_COUNTER then
                counter_inSectorA := counter_inSectorA + 1;
            else
                inSectorA_debounced <= '1';
            end if;
        else
            if counter_inSectorA > 0 then
                counter_inSectorA := counter_inSectorA - 1;
            else
                
                inSectorA_debounced <= '0';
            end if;
        end if;

        if inSectorB = '1' then
            if counter_inSectorB < MAX_COUNTER then
                counter_inSectorB := counter_inSectorB + 1;
            else
                inSectorB_debounced <= '1';
            end if;
        else
            if counter_inSectorB > 0 then
                counter_inSectorB := counter_inSectorB - 1;
            else
                inSectorB_debounced <= '0';
            end if;
        end if;

        if outSectorA = '1' then
            if counter_outSectorA < MAX_COUNTER then
                counter_outSectorA := counter_outSectorA + 1;
            else
                outSectorA_debounced <= '1';
            end if;
        else
            if counter_outSectorA > 0 then
                counter_outSectorA := counter_outSectorA - 1;
            else
                outSectorA_debounced <= '0';
            end if;
        end if;

        if outSectorB = '1' then
            if counter_outSectorB < MAX_COUNTER then
                counter_outSectorB := counter_outSectorB + 1;
            else
                outSectorB_debounced <= '1';
            end if;
        else
            if counter_outSectorB > 0 then
                counter_outSectorB := counter_outSectorB - 1;
            else
                outSectorB_debounced <= '0';
            end if;
        end if;
    end if;
end process;

counter_parking <= counter_sectorA + counter_sectorB;

counter_sectorA_decade <= (counter_sectorA / 10) mod 10;
counter_sectorA_unit <= counter_sectorA mod 10;
counter_sectorB_decade <= (counter_sectorB / 10) mod 10;
counter_sectorB_unit <= counter_sectorB mod 10;
counter_parking_decade <= (counter_parking / 10) mod 10;
counter_parking_unit <= counter_parking mod 10;

event_parking_debounced <= inSectorA_debounced xor outSectorA_debounced xor inSectorB_debounced xor outSectorB_debounced;

display_led(9) <= inSectorA_debounced;
display_led(8) <= outSectorA_debounced;
display_led(1) <= inSectorB_debounced;
display_led(0) <= outSectorB_debounced;
display_led(5) <= event_parking_debounced;
display_led(4) <= event_parking_debounced;

manage_parking: process(reset, event_parking_debounced)
begin
    if reset = '0' then
        counter_sectorA <= 0;
        counter_sectorB <= 0;
    elsif rising_edge(event_parking_debounced) then        
        if inSectorA_debounced = '1' then
            if counter_sectorA < 9 then
                counter_sectorA <= counter_sectorA + 1;
            end if;
        elsif outSectorA_debounced = '1' then
            if counter_sectorA > 0 then
                counter_sectorA <= counter_sectorA - 1;
            end if;
        elsif inSectorB_debounced = '1' then
            if counter_sectorB < 9 and counter_sectorA > 0 then
                counter_sectorB <= counter_sectorB + 1;
                counter_sectorA <= counter_sectorA - 1;
            end if;
        elsif outSectorB_debounced = '1' then
            if counter_sectorB > 0 and counter_sectorA < 9 then
                counter_sectorB <= counter_sectorB - 1;
                counter_sectorA <= counter_sectorA + 1;
            end if;
        end if;
    end if;
end process;

display_sectorA_decade: process(counter_sectorA_decade)
begin
    case counter_sectorA_decade is
        when 0 => displaySectorA_decade <= "0000001";
        when 1 => displaySectorA_decade <= "1001111";
        when 2 => displaySectorA_decade <= "0010010";
        when 3 => displaySectorA_decade <= "0000110";
        when 4 => displaySectorA_decade <= "1001100";
        when 5 => displaySectorA_decade <= "0100100";
        when 6 => displaySectorA_decade <= "0100000";
        when 7 => displaySectorA_decade <= "0001111";
        when 8 => displaySectorA_decade <= "0000000";
        when 9 => displaySectorA_decade <= "0000100";
        when others => displaySectorA_decade <= "1111111";
    end case;
end process;

display_sectorA_unit: process(counter_sectorA_unit)
begin
    case counter_sectorA_unit is
        when 0 => displaySectorA_unit <= "0000001";
        when 1 => displaySectorA_unit <= "1001111";
        when 2 => displaySectorA_unit <= "0010010";
        when 3 => displaySectorA_unit <= "0000110";
        when 4 => displaySectorA_unit <= "1001100";
        when 5 => displaySectorA_unit <= "0100100";
        when 6 => displaySectorA_unit <= "0100000";
        when 7 => displaySectorA_unit <= "0001111";
        when 8 => displaySectorA_unit <= "0000000";
        when 9 => displaySectorA_unit <= "0000100";
        when others => displaySectorA_unit <= "1111111";
    end case;
end process;

display_sectorB_decade: process(counter_sectorB_decade)
begin
    case counter_sectorB_decade is
        when 0 => displaySectorB_decade <= "0000001";
        when 1 => displaySectorB_decade <= "1001111";
        when 2 => displaySectorB_decade <= "0010010";
        when 3 => displaySectorB_decade <= "0000110";
        when 4 => displaySectorB_decade <= "1001100";
        when 5 => displaySectorB_decade <= "0100100";
        when 6 => displaySectorB_decade <= "0100000";
        when 7 => displaySectorB_decade <= "0001111";
        when 8 => displaySectorB_decade <= "0000000";
        when 9 => displaySectorB_decade <= "0000100";
        when others => displaySectorB_decade <= "1111111";
    end case;
end process;

display_sectorB_unit: process(counter_sectorB_unit)
begin
    case counter_sectorB_unit is
        when 0 => displaySectorB_unit <= "0000001";
        when 1 => displaySectorB_unit <= "1001111";
        when 2 => displaySectorB_unit <= "0010010";
        when 3 => displaySectorB_unit <= "0000110";
        when 4 => displaySectorB_unit <= "1001100";
        when 5 => displaySectorB_unit <= "0100100";
        when 6 => displaySectorB_unit <= "0100000";
        when 7 => displaySectorB_unit <= "0001111";
        when 8 => displaySectorB_unit <= "0000000";
        when 9 => displaySectorB_unit <= "0000100";
        when others => displaySectorB_unit <= "1111111";
    end case;
end process;

display_parking_decade: process(counter_parking_decade)
begin
    if counter_parking = 18 then
        displayParking_decade <= "0111000";
    else
        case counter_parking_decade is
            when 0 => displayParking_decade <= "0000001";
            when 1 => displayParking_decade <= "1001111";
            when 2 => displayParking_decade <= "0010010";
            when 3 => displayParking_decade <= "0000110";
            when 4 => displayParking_decade <= "1001100";
            when 5 => displayParking_decade <= "0100100";
            when 6 => displayParking_decade <= "0100000";
            when 7 => displayParking_decade <= "0001111";
            when 8 => displayParking_decade <= "0000000";
            when 9 => displayParking_decade <= "0000100";
            when others => displayParking_decade <= "1111111";
        end case;
    end if;
end process;

display_parking_unit: process(counter_parking_unit)
begin
    if counter_parking = 18 then
        displayParking_unit <= "0111000";
    else
        case counter_parking_unit is
            when 0 => displayParking_unit <= "0000001";
            when 1 => displayParking_unit <= "1001111";
            when 2 => displayParking_unit <= "0010010";
            when 3 => displayParking_unit <= "0000110";
            when 4 => displayParking_unit <= "1001100";
            when 5 => displayParking_unit <= "0100100";
            when 6 => displayParking_unit <= "0100000";
            when 7 => displayParking_unit <= "0001111";
            when 8 => displayParking_unit <= "0000000";
            when 9 => displayParking_unit <= "0000100";
            when others => displayParking_unit <= "1111111";
        end case;
    end if;
end process;

end architecture Behavioral;
