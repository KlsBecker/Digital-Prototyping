library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador is
    Port (  reset : in  STD_LOGIC;
            clock1s : in  STD_LOGIC;
            SEL: in STD_LOGIC;
            LED: out STD_LOGIC_VECTOR(4 downto 1));
end contador;

architecture Behavioral of contador is
    signal cont: integer range 0 to 250000000 := 0;
    signal led_temp: STD_LOGIC_VECTOR(4 downto 1) := "0000";
begin

process(clock1s, reset)
begin
    if reset = '1' then
        cont <= 0;
        led_temp <= "0000";
    elsif (clock1s'event and clock1s = '1') then
        if cont < 250000000 then
            cont <= cont + 1;
        else
            cont <= 0;
            if SEL = '0' then
                led_temp <= led_temp(3 downto 0) & '1';
            elsif SEL = '1' then
                led_temp <= led_temp(3 downto 0) & '0';
            end if;
        end if;
    end if;
end process;

LED <= led_temp;

end Behavioral;
