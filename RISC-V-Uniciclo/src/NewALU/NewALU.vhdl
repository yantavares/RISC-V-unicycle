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
          WHEN "0000" =>
            Z <= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B));
            zero <= '0';

        WHEN "0001" =>
          Z <= STD_LOGIC_VECTOR(SIGNED(A) - SIGNED(B));
          zero <= '0';

        WHEN "0010" =>
          Z <= A AND B;
          zero <= '0';

        WHEN "0011" =>
          Z <= A OR B;
          zero <= '0';

        WHEN "0100" =>
          Z <= A XOR B;
          zero <= '0';

        WHEN "0101" =>  -- Shift Left Logical
          -- Set to zero if shift amount is too large
          Z <= (others => '0') WHEN TO_INTEGER(SIGNED(B)) >= A'LENGTH ELSE
              STD_LOGIC_VECTOR(SIGNED(A) SLL TO_INTEGER(SIGNED(B)));
          zero <= '0';
        
        WHEN "0110" =>
          Z <= STD_LOGIC_VECTOR(SIGNED(A) SRL TO_INTEGER(SIGNED(B)));
          zero <= '0';

        WHEN "0111" =>
          Z <= STD_LOGIC_VECTOR(SHIFT_RIGHT(SIGNED(A), TO_INTEGER(SIGNED(B))));
          zero <= '0';

        WHEN "1000" =>
          IF SIGNED(A) < SIGNED(B) THEN
            Z <= x"00000001";
            zero <= '1';
          ELSE
            Z <= x"00000000";
            zero <= '0';
          END IF;

        WHEN "1001" =>
          IF SIGNED(A) < SIGNED(B) THEN
            Z <= x"00000001";
            zero <= '1';
          ELSE
            Z <= x"00000000";
            zero <= '0';
          END IF;

        WHEN "1010" =>
          IF SIGNED(A) < SIGNED(B) THEN
            Z <= x"00000000";
            zero <= '0';
          ELSE
            Z <= x"00000001";
            zero <= '1';
          END IF;

        WHEN "1011" =>
          IF SIGNED(A) < SIGNED(B) THEN
            Z <= x"00000000";
            zero <= '0';
          ELSE
            Z <= x"00000001";
            zero <= '1';
          END IF;

        WHEN "1100" =>
          IF SIGNED(A) = SIGNED(B) THEN
            Z <= x"00000001";
            zero <= '1';
          ELSE
            Z <= x"00000000";
            zero <= '0';
          END IF;

        WHEN "1101" =>
          IF SIGNED(A) = SIGNED(B) THEN
            Z <= x"00000000";
            zero <= '0';
          ELSE
            Z <= x"00000001";
            zero <= '1';
          END IF;

        WHEN "1110" =>
          Z <= STD_LOGIC_VECTOR(SIGNED(B));
          zero <= '0';

        WHEN "1111" =>
          Z <= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B));
          zero <= '0';

        WHEN OTHERS =>
          report "Invalid opcode" & to_string(opcode) severity error;
          Z <= "00000000000000000000000000000000";
          zero <= '0';

      END CASE;
    END IF;
  END PROCESS;

END bdf_type;