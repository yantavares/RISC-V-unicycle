-- ImmediateGenerator.vhdl
-- This file defines the immGen entity and its architecture.
-- It is responsible for generating immediate values from instruction codes.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ImmediateGenerator is 
    port (
        instruction : in  std_logic_vector(31 downto 0);  -- Input instruction
        immediate   : out signed(31 downto 0)             -- Output immediate value
    );
end entity;

architecture Behavior of ImmediateGenerator is
    -- Define the type for instruction format
    type InstructionFormat is (R_type, I_type, S_type, SB_type, UJ_type, U_type, Unknown_type);

    -- Intermediate signals for various instruction types
    signal I, S, SB, U, UJ, R : signed(31 downto 0);

    -- Detect the instruction type
    signal instrType : InstructionFormat;
    signal opcode    : unsigned(7 downto 0);
    signal funct3    : std_logic_vector(2 downto 0);

begin
    -- Immediate value extraction for different instruction formats
    I  <= resize(signed(instruction(31 downto 20)), 32);
    R  <= (others => '0');
    S  <= resize(signed(instruction(31 downto 25) & instruction(11 downto 7)), 32);
    SB <= resize(signed(instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0'), 32);
    UJ <= resize(signed(instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0'), 32);
    U  <= resize(signed(instruction(31 downto 12) & x"000"), 32);

    opcode  <= resize(unsigned(instruction(6 downto 0)), 8);
    funct3  <= instruction(14 downto 12);

    -- Determine instruction type based on opcode
    with opcode select
        instrType <= R_type  when x"33",
                    I_type  when x"03" | x"13" | x"67",
                    S_type  when x"23",
                    SB_type when x"63",
                    U_type  when x"17" | x"37",
                    UJ_type when x"6F",
                    Unknown_type when others;

    -- Output the immediate value based on instruction type
    with instrType select
        immediate <= I  when I_type,
                     S  when S_type,
                     SB when SB_type,
                     U  when U_type,
                     UJ when UJ_type,
                     R  when others;
end Behavior;
