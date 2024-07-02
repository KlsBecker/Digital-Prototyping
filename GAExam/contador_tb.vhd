LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY contador_tb IS
END contador_tb;

ARCHITECTURE behavior OF contador_tb IS 

    COMPONENT contador
    PORT(
        reset : IN std_logic;
        clock1s : IN std_logic;
        SEL: IN std_logic;
        LED: OUT std_logic_vector(4 downto 1)
    );
    END COMPONENT;

    signal reset: std_logic := '1';
    signal clock1s: std_logic := '0';
    signal SEL: std_logic := '0';
    signal LED: std_logic_vector(4 downto 1);
    constant clock1s_period : time := 20 ns;

BEGIN

    uut: contador PORT MAP(
        reset => reset,
        clock1s => clock1s,
        SEL => SEL,
        LED => LED
    );

    clock_process: process
    begin
        while true loop
            clock1s <= '0';
            wait for clock1s_period/2;
            clock1s <= '1';
            wait for clock1s_period/2;
        end loop;
    end process clock_process;

    stim_process: process
    begin
        SEL <= '0';
        wait for clock1s_period * 4;
        SEL <= '1';
        wait for clock1s_period * 4;
        reset <= '0';
        wait;
    end process stim_process;

END;