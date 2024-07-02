-- Klaus Becker - ALU Design
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ALU is
	port(
	Op_code: in std_logic_vector(2 downto 0);
    Input_A, Input_B: in std_logic_vector(3 downto 0);
	ALU_output: out std_logic_vector(3 downto 0)
    );
end ALU;

Architecture Arq_ALU of ALU is
signal temp: std_logic_vector(3 downto 0);
begin
process(Op_code, Input_A, Input_B)
begin
 	case Op_code(2 downto 1) is
 		when "00" =>
 			temp <= Input_A + Input_B;
 		when "01" =>
 			temp <= Input_A - Input_B;
 		when "10" =>
 			temp <= Input_A and Input_B;
 		when "11" =>
 			temp <= Input_A or Input_B;
 		when others=>
 			temp <= "0000";
 	end case;
        
 	if Op_code(0) = '0' then
 		ALU_output <= temp(2 downto 0) & '0';
 	else
 		ALU_output <= temp;
 	end if;
end process;
end;