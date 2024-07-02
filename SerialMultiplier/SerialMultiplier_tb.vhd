library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Multiplier_tb is
end Multiplier_tb;

architecture Behavioral of Multiplier_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component Multiplier
        Port ( input_a : in  STD_LOGIC_VECTOR (3 downto 0);
               input_b : in  STD_LOGIC_VECTOR (3 downto 0);
               output : out  STD_LOGIC_VECTOR (7 downto 0);
               start : in STD_LOGIC;
               done : out STD_LOGIC;
               clock : in STD_LOGIC);
    end component;

    -- Signals to connect to UUT
    signal input_a : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal input_b : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal output : STD_LOGIC_VECTOR (7 downto 0);
    signal start : STD_LOGIC := '0';
    signal done : STD_LOGIC;
    signal clock : STD_LOGIC := '0';

    -- Clock period definition
    constant clock_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Multiplier
        Port map (
            input_a => input_a,
            input_b => input_b,
            output => output,
            start => start,
            done => done,
            clock => clock
        );

    -- Clock process definitions
    clock_process :process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin	
        -- Test case 1
        input_a <= "0011";  -- 3
        input_b <= "0110";  -- 6

        start <= '1';
        wait for clock_period;
        start <= '0';
        
        wait until done = '1';
        
        wait;
    end process;

end Behavioral;
