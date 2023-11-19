library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Testbench for ImmediateValueGenerator
entity TestBench_ImmediateValueGenerator is
end entity;

architecture Behavioral of TestBench_ImmediateValueGenerator is

    component ImmediateValueGenerator
        port (
            instruction : in  std_logic_vector(31 downto 0);
            immediateValue : out signed(31 downto 0)
        );
    end component;

    signal instructionInput : std_logic_vector(31 downto 0);
    signal immediateValueOutput : signed(31 downto 0);

begin
    uut: ImmediateValueGenerator port map (instructionInput, immediateValueOutput);

    stimProcess: process
    begin
        -- Simulating various instructions
        instructionInput <= X"000002B3"; -- Example R-type instruction
        wait for 10 ns;
        -- Additional test cases follow...

        wait; -- Wait indefinitely to prevent process from terminating
    end process;
end Behavioral;
