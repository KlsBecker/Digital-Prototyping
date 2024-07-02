library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_logic_signed.ALL;

entity BoothMultiplier is
    Port (
        Q : in  STD_LOGIC_VECTOR (7 downto 0);
        M : in  STD_LOGIC_VECTOR (7 downto 0);
        output : out  STD_LOGIC_VECTOR (15 downto 0);
        start : in STD_LOGIC;
        done : out STD_LOGIC;
        clock : in STD_LOGIC
    );
end BoothMultiplier;

architecture Behavioral of BoothMultiplier is
    signal Count: integer range 8 downto -1;
    signal A: STD_LOGIC_VECTOR(7 downto 0);
    signal Q_local: STD_LOGIC_VECTOR(7 downto 0);
    signal M_local: STD_LOGIC_VECTOR(7 downto 0);
    signal Q_bit: STD_LOGIC;
    type state_type is (IDLE, ADD_SUB, SHIFT, FINISH);
    signal state : state_type := IDLE;
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if start = '1' then
                A <= (others => '0');
                Q_local <= Q;
                M_local <= M;
                Q_bit <= '0';
                Count <= 8;
                done <= '0';
                state <= ADD_SUB;
            end if;

            case state is
                when IDLE =>
                    done <= '0';

                when ADD_SUB =>
                    if Q_local(0) = '0' and Q_bit = '1' then
                        A <= A + M_local;
                    elsif Q_local(0) = '1' and Q_bit = '0' then
                        A <= A - M_local;
                    end if;
                    state <= SHIFT;
                
                when SHIFT =>
                    Q_bit <= Q_local(0);
                    Q_local <= A(0) & Q_local(7 downto 1);
                    A <= A(7) & A(7 downto 1);
                    
                    if Count > 1 then
                        Count <= Count - 1;
                        state <= ADD_SUB;
                    else
                        state <= FINISH;
                    end if;
                
                when FINISH =>
                    output <= A & Q_local;
                    state <= IDLE;
            end case;
        else
            state <= state;
        end if;
    end process;
end Behavioral;
