library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port (  Op_code : IN std_logic_vector(2 downto 0);
            Input_A : IN std_logic_vector(3 downto 0);
            Input_B : IN std_logic_vector(3 downto 0);
            RST     : IN std_logic;
            CLK     : IN std_logic;
            ALU_out : OUT std_logic_vector(3 downto 0));
end ALU;

architecture Behavioral of ALU is
    signal temp : std_logic_vector(3 downto 0);
begin

process(Op_code, Input_A, Input_B, RST, CLK)
begin
    if RST = '1' then
        temp <= "0000";
    elsif rising_edge(CLK) then
        case Op_code(1 downto 0) is
            when "00" =>
                temp <= Input_A + Input_B;
            when "01" =>
                temp <= Input_A - Input_B;
            when "10" =>
                temp <= Input_A and Input_B;
            when others =>
                temp <= "0000";
        end case;
        
        if Op_code(2) = '1' then
            ALU_out <= tempo(2 downto 0) & temp(0);
        else
            ALU_out <= temp;
        end if;
    end if; 
end process;

LED <= led_temp;

end Behavioral;
