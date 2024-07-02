library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BoothMultiplier_tb is
end BoothMultiplier_tb;

architecture Behavioral of BoothMultiplier_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component BoothMultiplier
        Port ( Q : in  STD_LOGIC_VECTOR (7 downto 0);
               M : in  STD_LOGIC_VECTOR (7 downto 0);
               output : out  STD_LOGIC_VECTOR (15 downto 0);
               start : in STD_LOGIC;
               done : out STD_LOGIC;
               clock : in STD_LOGIC);
    end component;

    -- Signals to connect to UUT
    signal Q : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal M : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal output : STD_LOGIC_VECTOR (15 downto 0);
    signal start : STD_LOGIC := '0';
    signal done : STD_LOGIC;
    signal clock : STD_LOGIC := '0';

    -- Clock period definition
    constant clock_period : time := 1 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: BoothMultiplier
        Port map (
            Q => Q,
            M => M,
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
        -- Test case (-94 * 78 = -7348) 
        Q <= "10100010";
        M <= "01001110";

        start <= '1';
        wait for clock_period;
        start <= '0';

        wait until done = '1';
        
        wait;
    end process;

end Behavioral;
