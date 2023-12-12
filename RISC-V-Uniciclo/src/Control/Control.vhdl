LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;

ENTITY Control IS
  PORT (
    op : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    branch : OUT STD_LOGIC;  -- Ligado caso haja uma instrucao de branch
    memRead : OUT STD_LOGIC;  -- Permite a escrita na memoria
    memToReg : OUT STD_LOGIC;  -- O valor que vem da memoria de dados para se escrita no registrador
    auipc : OUT STD_LOGIC;
    jal : OUT STD_LOGIC;
    aluOp : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);  -- 2 bits da aluOp
    memWrite : OUT STD_LOGIC;  -- Permite a escrita na memoria
    aluSrc : OUT STD_LOGIC;  -- Se a     segunda entrada na ula vira do imediato ou nao
    regWrite : OUT STD_LOGIC);  -- Permite escrever na memoria de registradores
END Control;

ARCHITECTURE bdf_type OF Control IS

SIGNAL op_signal : STD_LOGIC_VECTOR (6 DOWNTO 0);
SIGNAL branch_signal : STD_LOGIC;
SIGNAL memRead_signal : STD_LOGIC;
SIGNAL memToReg_signal : STD_LOGIC;
SIGNAL aluOp_signal : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL memWrite_signal : STD_LOGIC;
SIGNAL aluSrc_signal : STD_LOGIC;
SIGNAL auipc_signal : STD_LOGIC;
SIGNAL jal_signal : STD_LOGIC;
SIGNAL regWrite_signal : STD_LOGIC;

BEGIN

  op_signal <= op;
  branch <= branch_signal;
  memRead <= memRead_signal;
  memToReg <= memToReg_signal;
  aluOp <= aluOp_signal;
  auipc <= auipc_signal;
  jal <= jal_signal;
  memWrite <= memWrite_signal;
  aluSrc <= aluSrc_signal;
  regWrite <= regWrite_signal;

PROCESS (op_signal)
  BEGIN

    CASE op_signal IS

      -- type R
      WHEN "0110011" =>
        branch_signal <= '0';
        memRead_signal <= '0';
        memToReg_signal <= '0';
        memWrite_signal <= '0';
        auipc_signal <= '0';
        jal_signal <= '0';
        regWrite_signal <= '1';
        aluSrc_signal <= '0';
        aluOp_signal <= "00";

      -- tipo I
      WHEN "0010011" =>
        branch_signal <= '0';
        memRead_signal <= '0';
        memToReg_signal <= '0';
        memWrite_signal <= '0';
        auipc_signal <= '0';
        jal_signal <= '0';
        regWrite_signal <= '1';
        aluSrc_signal <= '1';
        aluOp_signal <= "01";

      -- Branches
      WHEN "1100011" =>
        branch_signal <= '1';
        memRead_signal <= '0';
        memToReg_signal <= '0';
        memWrite_signal <= '0';
        auipc_signal <= '0';
        jal_signal <= '0';
        regWrite_signal <= '0';
        aluSrc_signal <= '0';
        aluOp_signal <= "10";

      -- LW
      WHEN "0000011" =>
        branch_signal <= '0';
        memRead_signal <= '1';
        memToReg_signal <= '1';
        memWrite_signal <= '0';
        auipc_signal <= '0';
        jal_signal <= '0';
        regWrite_signal <= '1';
        aluSrc_signal <= '1';
        aluOp_signal <= "11";

      -- SW
      WHEN "0100011" =>
        branch_signal <= '0';
        memRead_signal <= '0';
        memToReg_signal <= '0';
        memWrite_signal <= '1';
        auipc_signal <= '0';
        jal_signal <= '0';
        regWrite_signal <= '0';
        aluSrc_signal <= '1';
        aluOp_signal <= "11";

      -- LUi
      WHEN "0110111" =>
        branch_signal <= '0';
        memRead_signal <= '0';
        memToReg_signal <= '0';
        memWrite_signal <= '0';
        auipc_signal <= '0';
        jal_signal <= '0';
        regWrite_signal <= '1';
        aluSrc_signal <= '1';
        aluOp_signal <= "11";

      -- AUiPC
      WHEN "0010111" =>
        branch_signal <= '0';
        memRead_signal <= '0';
        memToReg_signal <= '0';
        memWrite_signal <= '0';
        auipc_signal <= '1';
        jal_signal <= '0';
        regWrite_signal <= '1';
        aluSrc_signal <= '1';
        aluOp_signal <= "11";

      -- JAL
      WHEN "1101111" =>
        branch_signal <= '1';
        memRead_signal <= '0';
        memToReg_signal <= '0';
        memWrite_signal <= '0';
        auipc_signal <= '0';
        jal_signal <= '1';
        regWrite_signal <= '1';
        aluSrc_signal <= '1';
        aluOp_signal <= "11";

      -- JALR
      WHEN "1100111" =>
        branch_signal <= '1';
        memRead_signal <= '0';
        memToReg_signal <= '0';
        memWrite_signal <= '0';
        auipc_signal <= '0';
        jal_signal <= '1';
        regWrite_signal <= '0';
        aluSrc_signal <= '1';
        aluOp_signal <= "11";

      WHEN OTHERS =>
        branch_signal <= '0';
        memRead_signal <= '0';
        memToReg_signal <= '0';
        jal_signal <= '0';
        aluOp_signal <= "00";
        memWrite_signal <= '0';
        auipc_signal <= '0';
        aluSrc_signal <= '0';
        regWrite_signal <= '0';

    END CASE;
  END PROCESS;

END bdf_type;