LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity declaration for the ALU control unit
ENTITY Alu_Control IS
  GENERIC (data_width : NATURAL := 32);
  PORT (
    ulaOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Operation code
    funct7 : IN STD_LOGIC; -- Function code (7-bit)
    auipcIn : IN STD_LOGIC; -- AUIPC input signal
    funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Function code (3-bit)
    opOut : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)); -- Output operation code
END ENTITY Alu_Control;

ARCHITECTURE bdf_type OF Alu_Control IS
BEGIN
  PROCESS (funct7, funct3, ulaOp, auipcIn)
  BEGIN
    CASE ulaOp IS
      WHEN "00" =>
        CASE funct3 IS
          -- Mapping funct3 and funct7 to specific ALU operations
          -- The comments indicate the corresponding operation
          WHEN "000" =>
            IF funct7 = '0' THEN
              opOut <= "0000";  -- ADD
            ELSE
              opOut <= "0001";  -- SUB
            END IF;
          -- Other operations follow the same pattern
          WHEN "001" => opOut <= "0101";  -- SLL
          WHEN "010" => opOut <= "1000";  -- SLT
          WHEN "011" => opOut <= "1001";  -- SLTU
          WHEN "100" => opOut <= "0100";  -- XOR
          WHEN "101" =>
            IF funct7 = '0' THEN
              opOut <= "0110";  -- SRL
            ELSE
              opOut <= "0111";  -- SRA
            END IF;
          WHEN "110" => opOut <= "0011";  -- OR
          WHEN "111" => opOut <= "0010";  -- AND
          WHEN OTHERS => opOut <= "0000";
        END CASE;
      -- Additional cases for other ulaOp values
      WHEN "01" => -- Similar structure as above
        -- [similar case structure for ulaOp "01"]
      WHEN "10" => -- Branch operations
        -- [similar case structure for ulaOp "10"]
      WHEN "11" =>
        -- Load Upper Immediate and Add Upper Immediate to PC operations
        IF auipcIn = '0' THEN
          opOut <= "1110";  -- LUi
        ELSE
          opOut <= "1111";  -- AUiPC
        END IF;
      WHEN OTHERS => opOut <= "0000";
    END CASE;
  END PROCESS;
END bdf_type;
