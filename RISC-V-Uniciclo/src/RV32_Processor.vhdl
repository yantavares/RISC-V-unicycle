LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY RV32_Processor IS
  PORT (
    clock : IN STD_LOGIC;
    instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rs1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rs2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rd : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    immediate : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END RV32_Processor;

ARCHITECTURE bdf_type OF RV32_Processor IS




-- mem
SIGNAL instruction_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
-- immgen
SIGNAL immOut_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
-- NewALU
SIGNAL Ain_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Bin_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Zout_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL zeroOut_signal : STD_LOGIC;
SIGNAL aluOP_signal : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL aluOPout_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
-- Control
SIGNAL branch_signal : STD_LOGIC;
SIGNAL memToReg_signal : STD_LOGIC;
SIGNAL memRead_signal : STD_LOGIC;
SIGNAL memWrite_signal : STD_LOGIC;
SIGNAL auipc_signal : STD_LOGIC;
SIGNAL aluSrc_signal : STD_LOGIC;
SIGNAL jal_signal : STD_LOGIC;
SIGNAL regWrite_signal : STD_LOGIC;
-- PC
SIGNAL addr_in_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL rst_signal : STD_LOGIC := '0';
SIGNAL addr_out_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
-- adders
SIGNAL adderOut_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL adder4Out_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL write_data_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL rs1_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL rs2_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL data_out_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL adder_in1_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL write_or_jal_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);


COMPONENT NewImmediateGenerator
  PORT (
    instruction : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    immediate : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END COMPONENT;

COMPONENT Alu_Control
  PORT (
    ulaOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    funct7 : IN STD_LOGIC;
    auipcIn : IN STD_LOGIC;
    funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    opOut : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END COMPONENT;

COMPONENT Control
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
    regWrite : OUT STD_LOGIC);
END COMPONENT;

COMPONENT Mux_2_1
  PORT (
    Sel : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT mux_2_5bits
  PORT (
    Sel : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    Result : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
END COMPONENT;

COMPONENT Adder
  PORT (
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT Add_4
  PORT (
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT PC
  PORT (
    addr_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    rst : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT NewALU
  PORT (
    opcode : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    zero : OUT STD_LOGIC);
END COMPONENT;

COMPONENT NewXREG
  PORT (
    wren : IN STD_LOGIC;
    rs1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    rs2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ro1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    ro2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT NewRAM
  PORT (
    we : IN STD_LOGIC;
    re : IN STD_LOGIC;
    address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT NewROM
  PORT (
    address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

BEGIN

  rst_signal <= '0';

  control_inst01 : Control
  PORT MAP (
    op => instruction_signal(6 DOWNTO 0),
    aluOp => aluOp_signal,
    branch => branch_signal,
    memToReg => memToReg_signal,
    memWrite => memWrite_signal,
    auipc => auipc_signal,
    jal => jal_signal,
    memRead => memRead_signal,
    aluSrc => aluSrc_signal,
    regWrite => regWrite_signal);

  genImm_inst02 : NewImmediateGenerator
  PORT MAP (
    instruction => instruction_signal,
    immediate => immOut_signal);

  alu_inst03 : NewALU
  PORT MAP (
    opcode => aluOPout_signal,
    A => Ain_signal,
    B => Bin_signal,
    Z => Zout_signal,
    zero => zeroOut_signal);

  control_alu_inst04 : Alu_Control
  PORT MAP (
    ulaOp => aluOp_signal,
    funct7 => instruction_signal(30),
    auipcIn => auipc_signal,
    funct3 => instruction_signal(14 DOWNTO 12),
    opOut => aluOPout_signal);

  pc_inst05 : PC
  PORT MAP (
    addr_in => addr_in_signal,
    rst => rst_signal,
    clk => clock,
    addr_out => addr_out_signal);

  adder_inst06 : Adder
  PORT MAP (
    A => adder_in1_signal,
    B => immOut_signal,
    Z => adderOut_signal);

  adder4_inst07 : Add_4
  PORT MAP (
    A => addr_out_signal,
    Z => adder4Out_signal);

  -- mux A
  muxA_inst08 : Mux_2_1
  PORT MAP (
    Sel => branch_signal AND (jal_signal OR zeroOut_signal),
    A => adder4Out_signal,
    B => adderOut_signal,
    Result => addr_in_signal);

  -- mux B
  muxB_inst09 : Mux_2_1
  PORT MAP (
    Sel => aluSrc_signal,
    A => rs2_signal,
    B => immOut_signal,
    Result => Bin_signal);

  -- mux C
  muxC_inst10 : Mux_2_1
  PORT MAP (
    Sel => memToReg_signal,
    A => Zout_signal,
    B => data_out_signal,
    Result => write_data_signal);

  -- mux D
  muxD_inst11 : Mux_2_1
  PORT MAP (
    Sel => auipc_signal,
    A => rs1_signal,
    B => addr_out_signal,
    Result => Ain_signal);

  -- mux G
  muxG_inst14 : Mux_2_1
  PORT MAP (
    Sel => jal_signal AND NOT(instruction_signal(3)),
    A => addr_out_signal,
    B => rs1_signal,
    Result => adder_in1_signal);

  -- mux H
  muxH_inst15 : Mux_2_1
  PORT MAP (
    Sel => jal_signal AND instruction_signal(3),
    A => write_data_signal,
    B => adder4Out_signal,
    Result => write_or_jal_signal);

  mem_reg_inst16 : NewXREG
  PORT MAP (
    wren => regWrite_signal,
    rs1 => instruction_signal(19 DOWNTO 15),
    rs2 => instruction_signal(24 DOWNTO 20),
    rd => instruction_signal(11 DOWNTO 7),
    data => write_or_jal_signal,
    ro1 => rs1_signal,
    ro2 => rs2_signal);

  mem_data_inst17 : NewRAM
  PORT MAP (
    we => memWrite_signal,
    re => memRead_signal,
    address => Zout_signal(11 DOWNTO 0),
    datain => rs2_signal,
    dataout => data_out_signal);

  mem_instr_inst18 : NewROM
  PORT MAP (
    address => addr_out_signal(11 DOWNTO 0),
    dataout => instruction_signal);

  instruction <= instruction_signal;
  rs1 <= rs1_signal;
  rs2 <= rs2_signal;
  rd <= write_data_signal;
  immediate <= immOut_signal;

END bdf_type;