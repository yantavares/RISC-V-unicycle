library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Entity: ImmediateValueGenerator
-- Description: Generates a 32-bit signed immediate value from a given instruction.
entity ImmediateValueGenerator is 
    port (
        instruction : in  std_logic_vector(31 downto 0);
        immediateValue : out signed(31 downto 0)
    );
end entity;

-- Architecture: for ImmediateValueGenerator
architecture Behavioral of ImmediateValueGenerator is

    -- Define instruction formats for the RISC-V architecture
    type InstructionFormat is (R_type, I_type, S_type, SB_type, UJ_type, U_type, Unknown_type);
    signal I, S, SB, U, UJ, R : signed(31 downto 0);
    signal instructionType : InstructionFormat;
    signal opcode : unsigned(7 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);

    begin
        -- Extract and sign-extend various fields from the instruction
        I   <= resize(signed(instruction(31 downto 20)), 32);
        S   <= resize(signed(instruction(31 downto 25) & instruction(11 downto 7)), 32);
        SB  <= resize(signed(instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0'), 32);
        UJ  <= resize(signed(instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0'), 32);
        U   <= resize(signed(instruction(31 downto 12) & x"000"), 32);
        R   <= x"00000000";
        
        opcode <= resize(unsigned(instruction(6 downto 0)), 8);
        funct3 <= instruction(14 downto 12);
        
        -- Determine the type of the instruction
        with opcode select
            instructionType <= R_type  when x"33",
                               I_type  when others;  -- Simplified for brevity
        
        -- Select the appropriate immediate value based on the instruction type
        with instructionType select
            immediateValue <= I when I_type,
                              S when S_type,
                              SB when SB_type,
                              U when U_type,
                              UJ when UJ_type,
                              R when others;
end Behavioral;
