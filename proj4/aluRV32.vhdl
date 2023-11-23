LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY AluRV32 IS
    GENERIC (WSIZE : NATURAL := 32);
    PORT (
        opcode : IN  std_logic_vector(3 DOWNTO 0);
        A, B   : IN  std_logic_vector(WSIZE-1 DOWNTO 0);
        Z      : OUT std_logic_vector(WSIZE-1 DOWNTO 0);
        zero   : OUT std_logic
    );
END AluRV32;

ARCHITECTURE behavior OF AluRV32 IS
BEGIN
    PROCESS (opcode, A, B)
    BEGIN
        CASE opcode IS
            WHEN "0000" => -- ADD
                Z <= std_logic_vector(unsigned(A) + unsigned(B));
            WHEN "0001" => -- SUB
                Z <= std_logic_vector(unsigned(A) - unsigned(B));
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
                -- Implementação de SRA
            WHEN "1000" => -- SLT
                -- Implementação de SLT
            WHEN "1001" => -- SLTU
                -- Implementação de SLTU
            WHEN "1010" => -- SGE
                -- Implementação de SGE
            WHEN "1011" => -- SGEU
                -- Implementação de SGEU
            WHEN "1100" => -- SEQ
                Z <= '1' WHEN A = B ELSE '0';
            WHEN "1101" => -- SNE
                Z <= '1' WHEN A /= B ELSE '0';
            WHEN OTHERS =>
                Z <= (others => '0');
        END CASE;
        zero <= '1' WHEN Z = (others => '0') ELSE '0';
    END PROCESS;
END behavior;
