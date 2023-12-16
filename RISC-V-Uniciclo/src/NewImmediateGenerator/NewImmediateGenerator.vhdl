LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; -- For numeric conversions

ENTITY NewImmediateGenerator IS
  PORT (
    instruction : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    immediate     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END NewImmediateGenerator;

ARCHITECTURE behavior OF NewImmediateGenerator IS

  SIGNAL I_type, S_type, SB_type, UJ_type, U_type : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL imm_selector : STD_LOGIC_VECTOR(2 DOWNTO 0);

  -- Component for multiplexer
  COMPONENT Mux_8_1
    PORT (
      A, B, C, D, E, F, G, H : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      Sel                    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      Result                 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  -- Function to extend sign bit
  FUNCTION SignExtend(signal bit : STD_LOGIC; size : NATURAL) RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
  BEGIN
    result := (others => bit);
    RETURN result;
  END FUNCTION SignExtend;

BEGIN

  -- Compute Immediate Types
  I_type <= SignExtend(instruction(31), 20) & instruction(31 DOWNTO 20); -- I-Type
  S_type <= SignExtend(instruction(31), 20) & instruction(31 DOWNTO 25) & instruction(11 DOWNTO 7); -- S-Type
  SB_type <= SignExtend(instruction(31), 19) & instruction(7) & instruction(30 DOWNTO 25) & instruction(11 DOWNTO 8) & '0'; -- SB-Type
  UJ_type <= SignExtend(instruction(31), 12) & instruction(19 DOWNTO 12) & instruction(20) & instruction(30 DOWNTO 21) & '0'; -- UJ-Type
  U_type <= instruction(31 DOWNTO 12) & "00000000000000000000"; -- U-Type

  -- Compute selector based on instruction
  imm_selector <= instruction(3) & 
                  ((instruction(6) AND instruction(5) AND NOT instruction(4) AND NOT instruction(2)) OR
                   (instruction(5) AND instruction(4) AND instruction(2)) OR
                   (NOT instruction(6) AND NOT instruction(5) AND instruction(4) AND NOT instruction(3) AND instruction(2) AND instruction(1) AND instruction(0))) &
                  ((NOT instruction(6) AND instruction(5) AND NOT instruction(4)) OR
                   (instruction(5) AND instruction(4) AND instruction(2)) OR
                   (NOT instruction(6) AND NOT instruction(5) AND instruction(4) AND NOT instruction(3) AND instruction(2) AND instruction(1) AND instruction(0)));

  -- Instantiate Multiplexer
  mux_inst : Mux_8_1
    PORT MAP (
      A => I_type,
      B => S_type,
      C => SB_type,
      D => U_type,
      E => UJ_type,
      F => (others => '0'),
      G => (others => '0'),
      H => (others => '0'),
      Sel => imm_selector,
      Result => immediate
    );

END behavior;
