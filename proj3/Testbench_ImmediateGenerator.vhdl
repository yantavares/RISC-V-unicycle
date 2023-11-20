-- Testbench_ImmediateGenerator.vhdl
-- This file contains the testbench for the ImmediateGenerator.
-- It tests various instruction types and prints the results in hexadecimal form.

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

-- Function to convert a signed value to a hexadecimal string representation
function signed_to_hex_string(s : signed) return string is
    variable result : string(1 to s'length / 4) := (others => '0');
    variable temp   : std_logic_vector(s'length - 1 downto 0);
    variable nibble : std_logic_vector(3 downto 0);
begin
    temp := std_logic_vector(s);
    for i in 0 to result'length - 1 loop
        nibble := temp(4 * i + 3 downto 4 * i);
        case nibble is
            when "0000" => result(result'length - i) := '0';
            when "0001" => result(result'length - i) := '1';
            when "0010" => result(result'length - i) := '2';
            when "0011" => result(result'length - i) := '3';
            when "0100" => result(result'length - i) := '4';
            when "0101" => result(result'length - i) := '5';
            when "0110" => result(result'length - i) := '6';
            when "0111" => result(result'length - i) := '7';
            when "1000" => result(result'length - i) := '8';
            when "1001" => result(result'length - i) := '9';
            when "1010" => result(result'length - i) := 'A';
            when "1011" => result(result'length - i) := 'B';
            when "1100" => result(result'length - i) := 'C';
            when "1101" => result(result'length - i) := 'D';
            when "1110" => result(result'length - i) := 'E';
            when others => result(result'length - i) := 'F';
        end case;
    end loop;
    return result;
end function;


begin
    -- Instance of ImmediateGenerator
    uut: ImmediateGenerator port map (instruction => test_instruction, immediate => test_immediate);

    -- Testbench process
    test_process: process
    begin
        -- Test case 1
        test_instruction <= X"000002B3"; wait for 10 ns;
        report "Test Case 1: Immediate = " & signed_to_hex_string(test_immediate);

        -- Test case 2
        test_instruction <= X"01002283"; wait for 10 ns;
        report "Test Case 2: Immediate = " & signed_to_hex_string(test_immediate);

        -- Test case 3
        test_instruction <= X"F9C00313"; wait for 10 ns;
        report "Test Case 3: Immediate = " & signed_to_hex_string(test_immediate);

        -- Test case 4
        test_instruction <= X"FFF2C293"; wait for 10 ns;
        report "Test Case 4: Immediate = " & signed_to_hex_string(test_immediate);

        -- Test case 5
        test_instruction <= X"16200313"; wait for 10 ns;
        report "Test Case 5: Immediate = " & signed_to_hex_string(test_immediate);

        -- Test case 6
        test_instruction <= X"01800067"; wait for 10 ns;
        report "Test Case 6: Immediate = " & signed_to_hex_string(test_immediate);

        -- Test case 7
        test_instruction <= X"00002437"; wait for 10 ns;
        report "Test Case 7: Immediate = " & signed_to_hex_string(test_immediate);

        -- Test case 8
        test_instruction <= X"02542E23"; wait for 10 ns;
        report "Test Case 8: Immediate = " & signed_to_hex_string(test_immediate);

        -- Test case 9
        test_instruction <= X"FE5290E3"; wait for 10 ns;
        report "Test Case 9: Immediate = " & signed_to_hex_string(test_immediate);

        -- Test case 10
        test_instruction <= X"00C000EF"; wait for 10 ns;
        report "Test Case 10: Immediate = " & signed_to_hex_string(test_immediate);

        wait; -- Terminate the process
    end process;
end Behavior;
