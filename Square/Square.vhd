----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:19:23 08/19/2014 
-- Design Name: 
-- Module Name:    raiz_quadrada - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_logic_signed.ALL;
--use IEEE.numeric_std.ALL;

entity raiz_quadrada is
    Port ( entrada : in  STD_LOGIC_VECTOR (7 downto 0);
           clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           saida : out  STD_LOGIC_VECTOR (7 downto 0);
           pronto : out  STD_LOGIC);
end raiz_quadrada;

architecture Behavioral of raiz_quadrada is
	type FSM is (inicio, operacao, final);
	signal estado_atual : FSM;
	signal n,d,r : STD_LOGIC_VECTOR (7 downto 0); 
	
begin

-- Estrutura de um processo:
-- <nome_do_processo>  :  process (lista_de_sensitividade)
-- lista_sensitividade : s�o todos os sinais que quando alterarem o seu valor, o processo deve ser atualizado

p1 : process (entrada, clock, reset)
	begin
		if clock'event and clock = '1' then  -- SE houve borda de subida do clock
			if reset = '1' then  -- se houve o reset
				estado_atual <= inicio;
			else  -- sen�o	
				case estado_atual is
					when inicio =>
						n <= entrada;
						d <= "00000001";
						r <= "00000000"; -- (others => '0')
						pronto <= '0';
						estado_atual <= operacao;
					when operacao =>
						if n > 0 then
							n <= n - d;
							r <= r + 1;
							d <= d + 2;
							estado_atual <= operacao;
						else
							estado_atual <= final;
						end if;
					when final =>
						pronto <= '1';
						saida <= r;
						estado_atual <= inicio;
				end case;
			end if;	
		else
			estado_atual <= estado_atual;
		end if;					
					
	end process;

end Behavioral;
