LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Alu_Control IS
    PORT (
        ulaOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        funct7 : IN STD_LOGIC;
        auipcIn : IN STD_LOGIC;
        funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        opOut : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY Alu_Control;

ARCHITECTURE behavior OF Alu_Control IS
BEGIN
    PROCESS (ulaOp, funct7, funct3, auipcIn)
    BEGIN
        CASE ulaOp IS
            WHEN "00" =>
                CASE funct3 IS
                    WHEN "000" => 
                        opOut <= "0000" WHEN funct7 = '0' ELSE "0001"; -- ADD or SUB
                    WHEN "001" => opOut <= "0101";  -- SLL
                    WHEN "010" => opOut <= "1000";  -- SLT
                    WHEN "011" => opOut <= "1001";  -- SLTU
                    WHEN "100" => opOut <= "0100";  -- XOR
                    WHEN "101" => 
                        opOut <= "0110" WHEN funct7 = '0' ELSE "0111"; -- SRL or SRA
                    WHEN "110" => opOut <= "0011";  -- OR
                    WHEN "111" => opOut <= "0010";  -- AND
                    WHEN OTHERS => opOut <= "0000";
                END CASE;

            WHEN "01" =>
                CASE funct3 IS
                    WHEN "000" => opOut <= "0000";  -- ADDI
                    WHEN "001" => opOut <= "0101";  -- SLLI
                    WHEN "010" => opOut <= "1000";  -- SLTI
                    WHEN "011" => opOut <= "1001";  -- SLTUI
                    WHEN "100" => opOut <= "0100";  -- XORI
                    WHEN "101" =>
                      opOut <= "0110" WHEN funct7 = '0' ELSE "0111"; -- SRLI or SRAI
                    WHEN "110" => opOut <= "0011";  -- ORI
                    WHEN "111" => opOut <= "0010";  -- ANDI
                    WHEN OTHERS => opOut <= "0000";
                END CASE;

            WHEN "10" =>
                CASE funct3 IS
                    WHEN "000" => opOut <= "1100";  -- BEQ
                    WHEN "001" => opOut <= "1101";  -- BNE
                    WHEN "100" => opOut <= "1000";  -- BLT
                    WHEN "101" => opOut <= "1010";  -- BGE
                    WHEN OTHERS => opOut <= "0000";
                END CASE;

            WHEN "11" =>
                opOut <= "1110" WHEN auipcIn = '0' ELSE "1111"; -- LUI or AUIPC

            WHEN OTHERS =>
                opOut <= "0000";
        END CASE;
    END PROCESS;
END behavior;
