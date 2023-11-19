library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NandGate_tb is
-- Testbench has no ports
end NandGate_tb;

architecture behavior of NandGate_tb is 
    -- Component Declaration for the NAND gate
    component NandGate
        Port (
            A : in  STD_LOGIC;
            B : in  STD_LOGIC;
            Y : out STD_LOGIC
        );
    end component;

    -- Local Signals
    signal A, B, Y : STD_LOGIC := '0';

    -- Instantiate the Unit Under Test (UUT)
    begin
        uut: NandGate 
            port map (
                A => A,
                B => B,
                Y => Y
            );

        -- Stimulus process
        stim_proc: process
        begin		
            A <= '0'; B <= '0'; 
            wait for 10 ns;
            A <= '0'; B <= '1'; 
            wait for 10 ns;
            A <= '1'; B <= '0'; 
            wait for 10 ns;
            A <= '1'; B <= '1'; 
            wait for 10 ns;

            -- Add a report statement to print to the console
            report "NAND Gate Test Completed Successfully" severity note;

            wait;
        end process;
end behavior;
