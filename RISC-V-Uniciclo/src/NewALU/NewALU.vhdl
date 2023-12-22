LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY NewALU IS
  PORT (
    opcode : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    zero : OUT STD_LOGIC);
END NewALU;

ARCHITECTURE bdf_type OF NewALU IS

BEGIN

  PROCESS (opcode, A, B)
  BEGIN
    -- Check if opcode is undefined ('UUUU' or similar)
    IF opcode = "UUUU" THEN
        -- Skip processing or assign default values
        Z <= (others => '0');  -- Default or safe value for Z
        zero <= '0';  -- Default or safe value for zero
    ELSE
        -- Original ALU processing
      CASE opcode IS

        WHEN "0000" => -- ADD
          Z <= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B));
          zero <= '0';

        WHEN "0001" => -- SUB
          Z <= STD_LOGIC_VECTOR(SIGNED(A) - SIGNED(B));
          zero <= '0';

        WHEN "0010" => -- AND
          Z <= A AND B;
          zero <= '0';

        WHEN "0011" => -- OR
          Z <= A OR B;
          zero <= '0';

        WHEN "0100" => -- XOR
          Z <= A XOR B;
          zero <= '0';

        WHEN "0101" =>  -- SLL
          Z <= STD_LOGIC_VECTOR(SIGNED(A) SLL TO_INTEGER(SIGNED(B)));
          zero <= '0';
        
        WHEN "0110" => -- SRL
          Z <= STD_LOGIC_VECTOR(SIGNED(A) SRL TO_INTEGER(SIGNED(B)));
          zero <= '0';

        WHEN "0111" => -- SRA
          Z <= STD_LOGIC_VECTOR(SHIFT_RIGHT(SIGNED(A), TO_INTEGER(SIGNED(B))));
          zero <= '0';

        WHEN "1000" => -- SLT
          IF SIGNED(A) < SIGNED(B) THEN
            Z <= x"00000001";
            zero <= '1';
          ELSE
            Z <= x"00000000";
            zero <= '0';
          END IF;

        WHEN "1001" => -- SLTU
          IF UNSIGNED(A) < UNSIGNED(B) THEN
            Z <= x"00000001";
            zero <= '1';
          ELSE
            Z <= x"00000000";
            zero <= '0';
          END IF;

        WHEN "1010" => -- SGT
          IF SIGNED(A) < SIGNED(B) THEN
            Z <= x"00000000";
            zero <= '0';
          ELSE
            Z <= x"00000001";
            zero <= '1';
          END IF;

        WHEN "1011" => -- SGTU
          IF UNSIGNED(A) < UNSIGNED(B) THEN
            Z <= x"00000000";
            zero <= '0';
          ELSE
            Z <= x"00000001";
            zero <= '1';
          END IF;

        WHEN "1100" => -- SEQ
          IF SIGNED(A) = SIGNED(B) THEN
            Z <= x"00000001";
            zero <= '1';
          ELSE
            Z <= x"00000000";
            zero <= '0';
          END IF;

        WHEN "1101" => -- SNE
          IF SIGNED(A) = SIGNED(B) THEN
            Z <= x"00000000";
            zero <= '0';
          ELSE
            Z <= x"00000001";
            zero <= '1';
          END IF;

        WHEN "1110" => -- LUI
          Z <= STD_LOGIC_VECTOR(SIGNED(B));
          zero <= '0';

        WHEN "1111" => -- AUIPC
          Z <= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B));
          zero <= '0';

        WHEN OTHERS =>
          report "Invalid opcode" & to_string(opcode) severity error;
          Z <= x"00000000";
          zero <= '0';

      END CASE;
    END IF;
  END PROCESS;

END bdf_type;