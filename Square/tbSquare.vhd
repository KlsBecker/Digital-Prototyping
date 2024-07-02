library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_raiz_quadrada is
end tb_raiz_quadrada;

architecture Behavioral of tb_raiz_quadrada is
    -- Component declaration
    component raiz_quadrada is
        Port (  entrada : in STD_LOGIC_VECTOR (7 downto 0);
                saida : out STD_LOGIC_VECTOR (7 downto 0);
                clock : in STD_LOGIC;
                reset : in STD_LOGIC;
                pronto : out STD_LOGIC);
    end component;

    -- Signal declaration
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal in_data : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal out_data : STD_LOGIC_VECTOR (7 downto 0);
    signal ready : STD_LOGIC;

begin
    -- Component instantiation
    dut : raiz_quadrada
        port map (entrada => in_data,
                  saida => out_data,
                  clock => clk,
                  reset => rst,
                  pronto => ready);

    -- Clock process
    clk_process : process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Test 1
        in_data <= "00010000";

        -- Reset
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        
        while ready /= '1' loop
            wait for 10 ns;
        end loop;

        -- Test 2
        in_data <= "00100100";

        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        while ready /= '1' loop
            wait for 10 ns;
        end loop;

        -- Test 3
        in_data <= "01111001";

        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        wait;
    end process;

end Behavioral;
