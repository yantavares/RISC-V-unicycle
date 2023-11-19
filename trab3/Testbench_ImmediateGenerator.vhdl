-- Testbench_ImmediateGenerator.vhdl
-- This file contains the testbench for the ImmediateGenerator.
-- It tests various instruction types to verify the functionality of ImmediateGenerator.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Testbench_ImmediateGenerator is
end entity;

architecture Behavior of Testbench_ImmediateGenerator is
    component ImmediateGenerator
        port (
            instruction : in  std_logic_vector(31 downto 0);
            immediate   : out signed(31 downto 0)
        );
    end component;

    -- Test signals
    signal test_instruction : std_logic_vector(31 downto 0);
    signal test_immediate   : signed(31 downto 0);

begin
    -- Instance of ImmediateGenerator
    uut: ImmediateGenerator port map (instruction => test_instruction, immediate => test_immediate);

    -- Testbench process
    test_process: process
    begin
        -- Test cases with various instruction types
        test_instruction <= X"000002B3"; wait for 10 ns;
        test_instruction <= X"01002283"; wait for 10 ns;
        test_instruction <= X"F9C00313"; wait for 10 ns;
        test_instruction <= X"FFF2C293"; wait for 10 ns;
        test_instruction <= X"16200313"; wait for 10 ns;
        test_instruction <= X"01800067"; wait for 10 ns;
        test_instruction <= X"00002437"; wait for 10 ns;
        test_instruction <= X"02542E23"; wait for 10 ns;
        test_instruction <= X"FE5290E3"; wait for 10 ns;
        test_instruction <= X"00C000EF"; wait for 10 ns;

        wait; -- Terminate the process
    end process;
end Behavior;
