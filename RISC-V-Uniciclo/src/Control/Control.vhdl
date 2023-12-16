LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;

ENTITY Control IS
    PORT (
        op : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        branch : OUT STD_LOGIC;
        memRead : OUT STD_LOGIC;
        memToReg : OUT STD_LOGIC;
        auipc : OUT STD_LOGIC;
        jal : OUT STD_LOGIC;
        aluOp : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        memWrite : OUT STD_LOGIC;
        aluSrc : OUT STD_LOGIC;
        regWrite : OUT STD_LOGIC
    );
END Control;

ARCHITECTURE behavior OF Control IS
BEGIN
    PROCESS (op)
    BEGIN
        CASE op IS
            WHEN "0110011" =>  -- R-Type
                branch <= '0'; memRead <= '0'; memToReg <= '0'; memWrite <= '0';
                auipc <= '0'; jal <= '0'; regWrite <= '1'; aluSrc <= '0'; aluOp <= "00";

            WHEN "0010011" =>  -- I-Type
                branch <= '0'; memRead <= '0'; memToReg <= '0'; memWrite <= '0';
                auipc <= '0'; jal <= '0'; regWrite <= '1'; aluSrc <= '1'; aluOp <= "01";

            WHEN "1100011" =>  -- Branches
                branch <= '1'; memRead <= '0'; memToReg <= '0'; memWrite <= '0';
                auipc <= '0'; jal <= '0'; regWrite <= '0'; aluSrc <= '0'; aluOp <= "10";

            WHEN "0000011" =>  -- LW
                branch <= '0'; memRead <= '1'; memToReg <= '1'; memWrite <= '0';
                auipc <= '0'; jal <= '0'; regWrite <= '1'; aluSrc <= '1'; aluOp <= "11";

            WHEN "0100011" =>  -- SW
                branch <= '0'; memRead <= '0'; memToReg <= '0'; memWrite <= '1';
                auipc <= '0'; jal <= '0'; regWrite <= '0'; aluSrc <= '1'; aluOp <= "11";

            WHEN "0110111" =>  -- LUI
                branch <= '0'; memRead <= '0'; memToReg <= '0'; memWrite <= '0';
                auipc <= '0'; jal <= '0'; regWrite <= '1'; aluSrc <= '1'; aluOp <= "11";

            WHEN "0010111" =>  -- AUIPC
                branch <= '0'; memRead <= '0'; memToReg <= '0'; memWrite <= '0';
                auipc <= '1'; jal <= '0'; regWrite <= '1'; aluSrc <= '1'; aluOp <= "11";

            WHEN "1101111" =>  -- JAL
                branch <= '1'; memRead <= '0'; memToReg <= '0'; memWrite <= '0';
                auipc <= '0'; jal <= '1'; regWrite <= '1'; aluSrc <= '1'; aluOp <= "11";

            WHEN "1100111" =>  -- JALR
                branch <= '1'; memRead <= '0'; memToReg <= '0'; memWrite <= '0';
                auipc <= '0'; jal <= '1'; regWrite <= '0'; aluSrc <= '1'; aluOp <= "11";

            WHEN OTHERS =>
                branch <= '0'; memRead <= '0'; memToReg <= '0'; memWrite <= '0';
                auipc <= '0'; jal <= '0'; regWrite <= '0'; aluSrc <= '0'; aluOp <= "00";
        END CASE;
    END PROCESS;
END behavior;
