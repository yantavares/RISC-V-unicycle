LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY AluRV32 IS
    PORT (
        opcode : IN  std_logic_vector(3 DOWNTO 0);
        A, B   : IN  std_logic_vector(31 DOWNTO 0);
        Z      : OUT std_logic_vector(31 DOWNTO 0);
        zero   : OUT std_logic
    );
END AluRV32;

ARCHITECTURE behavior OF AluRV32 IS
BEGIN
    PROCESS (opcode, A, B)
    BEGIN
        CASE opcode IS
            WHEN "0000" => -- ADD
                Z <= std_logic_vector(signed(A) + signed(B));
            WHEN "0001" => -- SUB
                Z <= std_logic_vector(signed(A) - signed(B));
            WHEN "0010" => -- AND
                Z <= A AND B;
            WHEN "0011" => -- OR
                Z <= A OR B;
            WHEN "0100" => -- XOR
                Z <= A XOR B;
            WHEN "0101" => -- SLL
                Z <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
            WHEN "0110" => -- SRL
                Z <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
            WHEN "0111" => -- SRA
                Z <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
            WHEN "1000" => -- SLT
                Z <= (others => '0');
                Z(0) <= '1' WHEN signed(A) < signed(B) ELSE '0';
            WHEN "1001" => -- SLTU
                Z <= (others => '0');
                Z(0) <= '1' WHEN unsigned(A) < unsigned(B) ELSE '0';
            WHEN "1010" => -- SGE
                Z <= (others => '0');
                Z(0) <= '1' WHEN signed(A) >= signed(B) ELSE '0';
            WHEN "1011" => -- SGEU
                Z <= (others => '0');
                Z(0) <= '1' WHEN unsigned(A) >= unsigned(B) ELSE '0';
            WHEN "1100" => -- SEQ
                Z <= (others => '0');
                Z(0) <= '1' WHEN A = B ELSE '0';
            WHEN "1101" => -- SNE
                Z <= (others => '0');
                Z(0) <= '1' WHEN A /= B ELSE '0';
            WHEN OTHERS =>
                ASSERT opcode = "UUUU" REPORT "Invalid opcode - " & to_string(unsigned(opcode)) severity FAILURE;
                NULL;
        END CASE;
    END PROCESS;

    -- Necessary to make zero update in the same cycle as Z
    PROCESS (Z)
    BEGIN
        zero <= '1' WHEN Z = std_logic_vector(to_unsigned(0, 32)) ELSE '0';
    END PROCESS;

END behavior;
