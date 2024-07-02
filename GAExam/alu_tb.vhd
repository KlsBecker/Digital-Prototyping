LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ALU_tb IS
END ALU_tb;

ARCHITECTURE behavior OF ALU_tb IS 

    COMPONENT ALU
    PORT(
        Op_code : IN std_logic_vector(2 downto 0);
        Input_A : IN std_logic_vector(3 downto 0);
        Input_B : IN std_logic_vector(3 downto 0);
        RST     : IN std_logic;
        CLK     : IN std_logic;
    );
    END COMPONENT;

    signal Op_code : std_logic_vector(2 downto 0) := (others => '0');
    signal Input_A : std_logic_vector(3 downto 0) := (others => "0110");
    signal Input_B : std_logic_vector(3 downto 0) := (others => "0111");
    signal RST : std_logic := '1';
    signal CLK : std_logic := '0';

BEGIN

    uut: ALU PORT MAP(
        Op_code => Op_code,
        Input_A => Input_A,
        Input_B => Input_B,
        RST => RST,
        CLK => CLK
    );

    clock_process: process
    begin
        while true loop
            CLK <= '0';
            wait for 10 ns;
            CLK <= '1';
            wait for 10 ns;
        end loop;
    end process clock_process;

    stim_process: process
    begin
        RST <= '1';
        RST <= '0';
        Op_code <= "000";
        wait for 20 ns;
        Op_code <= "001";
        wait for 20 ns;
        Op_code <= "010";
        wait for 20 ns;
        Op_code <= "011";
        wait for 20 ns;
        Op_code <= "100";
        wait for 20 ns;
        Op_code <= "101";
        wait for 20 ns;
        Op_code <= "110";
        wait for 20 ns;
        Op_code <= "111";
        wait for 20 ns;
        RST <= '0';
        wait;
    end process stim_process;

END;