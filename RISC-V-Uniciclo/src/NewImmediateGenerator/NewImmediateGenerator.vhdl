LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY NewImmediateGenerator IS
  PORT (
    instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    immediate    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END NewImmediateGenerator;

ARCHITECTURE bdf_type OF NewImmediateGenerator IS
  SIGNAL I_type, S_type, SB_type, UJ_type, U_type : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL selector : STD_LOGIC_VECTOR(2 DOWNTO 0);

  -- Function to extend sign bit
  FUNCTION SignExtend(signal bit : STD_LOGIC; size : NATURAL) RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
  BEGIN
    result := (others => bit);
    RETURN result;
  END FUNCTION SignExtend;

  FUNCTION SignExtendTo32(signal bit : STD_LOGIC; n : NATURAL) RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(31 DOWNTO n);
  BEGIN
      result := (others => bit);
      RETURN result;
  END FUNCTION;

  -- Component for multiplexer
  COMPONENT Mux_8_1
    PORT (
      A, B, C, D, E, F, G, H : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      Sel                    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      Result                 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

BEGIN
  -- Compute Immediate Types
  I_type <= SignExtend(instruction(31), 20) & instruction(31 DOWNTO 20); -- I-Type
  S_type <= SignExtend(instruction(31), 20) & instruction(31 DOWNTO 25) & instruction(11 DOWNTO 7); -- S-Type
  SB_type <= SignExtendTo32(instruction(31), 12) & -- Sign-extend bit 31 to bits 31 down to 12
  instruction(7) &                     -- Bit 11
  instruction(30 DOWNTO 25) &          -- Bits 10 down to 5
  instruction(11 DOWNTO 8) &           -- Bits 4 down to 1
  '0';    

  UJ_type <= SignExtend(instruction(31), 12) & instruction(19 DOWNTO 12) & instruction(20) & instruction(30 DOWNTO 21) & '0'; -- UJ-Type
  U_type <= instruction(31 DOWNTO 12) & "000000000000"; -- Corrected U-Type

  -- Compute selector based on instruction
  selector <= "000"; -- Default value, adjust based on your instruction format

  -- Instantiate Multiplexer
  mux_inst : Mux_8_1 PORT MAP (
    A => I_type,
    B => S_type,
    C => SB_type,
    D => U_type,
    E => UJ_type,
    F => (others => '0'),
    G => (others => '0'),
    H => (others => '0'),
    Sel => selector,
    Result => immediate
  );
END bdf_type;
