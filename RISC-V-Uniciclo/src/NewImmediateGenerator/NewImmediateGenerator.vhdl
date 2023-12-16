LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY NewImmediateGenerator IS
  PORT (
    instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- instrução completa
    immediate : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));  -- já selecionado
END NewImmediateGenerator;

ARCHITECTURE bdf_type OF NewImmediateGenerator IS

SIGNAL I_type : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- calculados e usados no mux
SIGNAL S_type : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL SB_type : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL UJ_type : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL U_type : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL selector : STD_LOGIC_VECTOR(2 DOWNTO 0);  -- seleciona o mux

SIGNAL zero_bit : STD_LOGIC := '0';
SIGNAL zero_bit_twelve : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
SIGNAL zero_bit_thirtytwo : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";

-- mux de 5 entradas de 32 bits
COMPONENT Mux_8_1
  PORT (
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    C : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    E : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    F : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    G : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    H : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

BEGIN

  zero_bit <= '0';
  zero_bit_twelve <= "000000000000";
  zero_bit_thirtytwo <= "00000000000000000000000000000000";

  I_type(31) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(30) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(29) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(28) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(27) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(26) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(25) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(24) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(23) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(22) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(21) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(20) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(19) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(18) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(17) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(16) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(15) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(14) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(13) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';
  I_type(12) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';  -- daqui pra cima é o sinal extendido
  I_type(11) <= instruction(31) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE '0';  -- sinal
  I_type(10 DOWNTO 5) <= instruction(30 DOWNTO 25) WHEN instruction(14 DOWNTO 12) /= "001" AND instruction(14 DOWNTO 12) /= "101" ELSE "000000";
  I_type(4 DOWNTO 0) <= instruction(24 DOWNTO 20);

  S_type(31) <= instruction(31);
  S_type(30) <= instruction(31);
  S_type(29) <= instruction(31);
  S_type(28) <= instruction(31);
  S_type(27) <= instruction(31);
  S_type(26) <= instruction(31);
  S_type(25) <= instruction(31);
  S_type(24) <= instruction(31);
  S_type(23) <= instruction(31);
  S_type(22) <= instruction(31);
  S_type(21) <= instruction(31);
  S_type(20) <= instruction(31);
  S_type(19) <= instruction(31);
  S_type(18) <= instruction(31);
  S_type(17) <= instruction(31);
  S_type(16) <= instruction(31);
  S_type(15) <= instruction(31);
  S_type(14) <= instruction(31);
  S_type(13) <= instruction(31);
  S_type(12) <= instruction(31);  -- daqui pra cima é o sinal extendido
  S_type(11) <= instruction(31);  -- sinal
  S_type(10 DOWNTO 5) <= instruction(30 DOWNTO 25);
  S_type(4 DOWNTO 0) <= instruction(11 DOWNTO 7);

  SB_type(31) <= instruction(31);
  SB_type(30) <= instruction(31);
  SB_type(29) <= instruction(31);
  SB_type(28) <= instruction(31);
  SB_type(27) <= instruction(31);
  SB_type(26) <= instruction(31);
  SB_type(25) <= instruction(31);
  SB_type(24) <= instruction(31);
  SB_type(23) <= instruction(31);
  SB_type(22) <= instruction(31);
  SB_type(21) <= instruction(31);
  SB_type(20) <= instruction(31);
  SB_type(19) <= instruction(31);
  SB_type(18) <= instruction(31);
  SB_type(17) <= instruction(31);
  SB_type(16) <= instruction(31);
  SB_type(15) <= instruction(31);
  SB_type(14) <= instruction(31);
  SB_type(13) <= instruction(31);  -- daqui pra cima é o sinal extendido
  SB_type(12) <= instruction(31);  -- sinal
  SB_type(11) <= instruction(7);
  SB_type(10 DOWNTO 5) <= instruction(30 DOWNTO 25);
  SB_type(4 DOWNTO 1) <= instruction(11 DOWNTO 8);
  SB_type(0) <= zero_bit;

  UJ_type(31) <= instruction(31);
  UJ_type(30) <= instruction(31);
  UJ_type(29) <= instruction(31);
  UJ_type(28) <= instruction(31);
  UJ_type(27) <= instruction(31);
  UJ_type(26) <= instruction(31);
  UJ_type(25) <= instruction(31);
  UJ_type(24) <= instruction(31);
  UJ_type(23) <= instruction(31);
  UJ_type(22) <= instruction(31);
  UJ_type(21) <= instruction(31);  -- daqui pra cima é o sinal extendido
  UJ_type(20) <= instruction(31);  -- sinal
  UJ_type(19 DOWNTO 12) <= instruction(19 DOWNTO 12);
  UJ_type(11) <= instruction(20);
  UJ_type(10 DOWNTO 5) <= instruction(30 DOWNTO 25);
  UJ_type(4 DOWNTO 1) <= instruction(24 DOWNTO 21);
  UJ_type(0) <= zero_bit;

  U_type(31 DOWNTO 12) <= instruction(31 DOWNTO 12);
  U_type(11 DOWNTO 0) <= zero_bit_twelve;

  selector(2) <= instruction(3);
  selector(1) <= (((instruction(6) AND instruction(5)) AND NOT(instruction(4))) AND NOT(instruction(2))) OR
                 ((instruction(5) AND instruction(4)) AND instruction(2)) OR
                 (NOT instruction(6) AND NOT instruction(5) AND instruction(4) AND NOT instruction(3) AND instruction(2) AND instruction(1) AND instruction(0));
  selector(0) <= ((NOT(instruction(6)) AND instruction(5)) AND NOT(instruction(4))) OR
                 ((instruction(5) AND instruction(4)) AND instruction(2)) OR
                 (NOT instruction(6) AND NOT instruction(5) AND instruction(4) AND NOT instruction(3) AND instruction(2) AND instruction(1) AND instruction(0));

  b2v_inst : Mux_8_1
  PORT MAP (
    A => I_type,  -- 000
    B => S_type,  -- 001
    C => SB_type, -- 010
    D => U_type,  -- 011
    E => UJ_type, -- 100
    F => zero_bit_thirtytwo,
    G => zero_bit_thirtytwo,
    H => zero_bit_thirtytwo,
    Sel => selector,
    Result => immediate);

END bdf_type;