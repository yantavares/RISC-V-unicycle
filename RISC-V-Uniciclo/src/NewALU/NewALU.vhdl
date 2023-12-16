LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY NewALU IS
  PORT (
    opcode  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    A       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    B       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    Z       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    zero    : OUT STD_LOGIC
  );
END NewALU;

ARCHITECTURE bdf_type OF NewALU IS
BEGIN

  PROCESS (opcode, A, B)
  BEGIN
    CASE opcode IS
      WHEN "0000" =>  -- Add
        Z <= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B));
        zero <= '0';

      WHEN "0001" =>  -- Subtract
        Z <= STD_LOGIC_VECTOR(SIGNED(A) - SIGNED(B));
        zero <= '0';

      WHEN "0010" =>  -- AND
        Z <= A AND B;
        zero <= '0';

      WHEN "0011" =>  -- OR
        Z <= A OR B;
        zero <= '0';

      WHEN "0100" =>  -- XOR
        Z <= A XOR B;
        zero <= '0';

      WHEN "0101" =>  -- Shift Left Logical
        Z <= STD_LOGIC_VECTOR(UNSIGNED(A) SLL TO_INTEGER(UNSIGNED(B)));
        zero <= '0';

      WHEN "0110" =>  -- Shift Right Logical
        Z <= STD_LOGIC_VECTOR(UNSIGNED(A) SRL TO_INTEGER(UNSIGNED(B)));
        zero <= '0';

      WHEN "0111" =>  -- Shift Right Arithmetic
        Z <= STD_LOGIC_VECTOR(SHIFT_RIGHT(SIGNED(A), TO_INTEGER(UNSIGNED(B))));
        zero <= '0';

      WHEN "1000" =>  -- Set if Less Than (Signed)
        IF SIGNED(A) < SIGNED(B) THEN
          Z <= (others => '1');
        ELSE
          Z <= (others => '0');
        END IF;
        zero <= NOT Z(0);

      WHEN "1001" =>  -- Set if Less Than (Unsigned)
        IF UNSIGNED(A) < UNSIGNED(B) THEN
          Z <= (others => '1');
        ELSE
          Z <= (others => '0');
        END IF;
        zero <= NOT Z(0);

      WHEN "1100" =>  -- Set if Equal
        Z <= (others => '0') WHEN A /= B ELSE (others => '1');
        zero <= Z(0);

      WHEN "1101" =>  -- Set if Not Equal
        Z <= (others => '0') WHEN A = B ELSE (others => '1');
        zero <= Z(0);

      WHEN "1110" =>  -- Pass B
        Z <= STD_LOGIC_VECTOR(UNSIGNED(B));
        zero <= '0';

      WHEN "1111" =>  -- Add (Alternative)
        Z <= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B));
        zero <= '0';

      WHEN OTHERS =>
        Z <= (others => '0');
        zero <= '0';
    END CASE;
  END PROCESS;

END bdf_type;
