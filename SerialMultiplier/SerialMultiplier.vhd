library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Importa a biblioteca necessária para operações aritméticas

entity Multiplier is
    Port ( input_a : in  STD_LOGIC_VECTOR (3 downto 0);
           input_b : in  STD_LOGIC_VECTOR (3 downto 0);
           output : out  STD_LOGIC_VECTOR (7 downto 0);
           start : in STD_LOGIC;
           done : out STD_LOGIC;
           clock : in STD_LOGIC);
end Multiplier;

architecture Behavioral of Multiplier is
    type FSM is (init, add, finish);
    signal state : FSM := init;  -- Inicializa o estado
begin
    process(clock)
        variable temp : unsigned(7 downto 0);
        variable temp_minimum : unsigned(3 downto 0);
        variable temp_maximum : unsigned(3 downto 0);
    begin
        if rising_edge(clock) then
            case state is
                when init =>
                    temp := (others => '0');
                    done <= '0';
                    if start = '1' then
                        if unsigned(input_a) < unsigned(input_b) then
                            temp_minimum := unsigned(input_a);
                            temp_maximum := unsigned(input_b);
                        else
                            temp_minimum := unsigned(input_b);
                            temp_maximum := unsigned(input_a);
                        end if;
                        state <= add;
                    end if;
                when add =>
                    if temp_minimum /= 0 then
                        temp := temp + temp_maximum;
                        temp_minimum := temp_minimum - 1;
                    else
                        state <= finish;
                    end if;
                when finish =>
                    output <= std_logic_vector(temp);
                    done <= '1';
            end case;
        end if;
    end process;
end Behavioral;
