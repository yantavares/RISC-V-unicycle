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

  -- Internal signals
  SIGNAL instruction_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL immOut_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Ain_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Bin_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Zout_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL zeroOut_signal : STD_LOGIC;
  SIGNAL aluOP_signal : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL aluOPout_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL branch_signal : STD_LOGIC;
  SIGNAL memToReg_signal : STD_LOGIC;
  SIGNAL memRead_signal : STD_LOGIC;
  SIGNAL memWrite_signal : STD_LOGIC;
  SIGNAL auipc_signal : STD_LOGIC;
  SIGNAL aluSrc_signal : STD_LOGIC;
  SIGNAL jal_signal : STD_LOGIC;
  SIGNAL regWrite_signal : STD_LOGIC;
  SIGNAL addr_in_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL rst_signal : STD_LOGIC := '0';
  SIGNAL addr_out_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL adderOut_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL adder4Out_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL write_data_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL rs1_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL rs2_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_out_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL adder_in1_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL write_or_jal_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -- Component Declarations
COMPONENT genImm
PORT (
  instr : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
  result_imm : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END COMPONENT;

COMPONENT control_alu
PORT (
  ulaOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
  funct7 : IN STD_LOGIC;
  auipcIn : IN STD_LOGIC;
  funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
  opOut : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END COMPONENT;

COMPONENT control
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

COMPONENT mux2_32bits
PORT (
  Sel : IN STD_LOGIC;
  A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT mux2_5bits
PORT (
  Sel : IN STD_LOGIC;
  A : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
  B : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
  Result : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
END COMPONENT;

COMPONENT adder
PORT (
  A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT adder4
PORT (
  A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT pc
PORT (
  addr_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  rst : IN STD_LOGIC;
  clk : IN STD_LOGIC;
  addr_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT alu
PORT (
  opcode : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  Ain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  Bin : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  Zout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  zeroOut : OUT STD_LOGIC);
END COMPONENT;

COMPONENT mem_reg
PORT (
  clock : IN STD_LOGIC;
  we : IN STD_LOGIC;
  address1x : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
  address2x : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
  write_address : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
  data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  data1_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
  data2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT mem_data
PORT (
  clock : IN STD_LOGIC;
  we : IN STD_LOGIC;
  re : IN STD_LOGIC;
  address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
  data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

COMPONENT mem_instr
PORT (
  address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
  data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END COMPONENT;

BEGIN

  -- Reset signal initialization
  rst_signal <= '0';

  -- Control unit instantiation
  control_inst01 : control
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

  -- Immediate generator instantiation
  genImm_inst02 : genImm
  PORT MAP (
    instr => instruction_signal,
    result_imm => immOut_signal);

  -- ALU instantiation
  alu_inst03 : alu
  PORT MAP (
    opcode => aluOPout_signal,
    Ain => Ain_signal,
    Bin => Bin_signal,
    Zout => Zout_signal,
    zeroOut => zeroOut_signal);

  -- ALU control unit instantiation
  control_alu_inst04 : control_alu
  PORT MAP (
    ulaOp => aluOp_signal,
    funct7 => instruction_signal(30),
    auipcIn => auipc_signal,
    funct3 => instruction_signal(14 DOWNTO 12),
    opOut => aluOPout_signal);

  -- Program counter instantiation
  pc_inst05 : pc
  PORT MAP (
    addr_in => addr_in_signal,
    rst => rst_signal,
    clk => clock,
    addr_out => addr_out_signal);

  -- Adder instantiation
  adder_inst06 : adder
  PORT MAP (
    A => adder_in1_signal,
    B => immOut_signal,
    Z => adderOut_signal);

  -- Adder4 instantiation
  adder4_inst07 : adder4
  PORT MAP (
    A => addr_out_signal,
    Z => adder4Out_signal);

  -- Multiplexer A instantiation
  muxA_inst08 : mux2_32bits
  PORT MAP (
    Sel => branch_signal AND (jal_signal OR zeroOut_signal),
    A => adder4Out_signal,
    B => adderOut_signal,
    Result => addr_in_signal);

  -- Multiplexer B instantiation
  muxB_inst09 : mux2_32bits
  PORT MAP (
    Sel => aluSrc_signal,
    A => rs2_signal,
    B => immOut_signal,
    Result => Bin_signal);

  -- Multiplexer C instantiation
  muxC_inst10 : mux2_32bits
  PORT MAP (
    Sel => memToReg_signal,
    A => Zout_signal,
    B => data_out_signal,
    Result => write_data_signal);

  -- Multiplexer D instantiation
  muxD_inst11 : mux2_32bits
  PORT MAP (
    Sel => auipc_signal,
    A => rs1_signal,
    B => addr_out_signal,
    Result => Ain_signal);

  -- Multiplexer G instantiation
  muxG_inst14 : mux2_32bits
  PORT MAP (
    Sel => jal_signal AND NOT(instruction_signal(3)),
    A => addr_out_signal,
    B => rs1_signal,
    Result => adder_in1_signal);

  -- Multiplexer H instantiation
  muxH_inst15 : mux2_32bits
  PORT MAP (
    Sel => jal_signal AND instruction_signal(3),
    A => write_data_signal,
    B => adder4Out_signal,
    Result => write_or_jal_signal);

  -- Register memory instantiation
  mem_reg_inst16 : mem_reg
  PORT MAP (
    clock => clock,
    we => regWrite_signal,
    address1x => instruction_signal(19 DOWNTO 15),
    address2x => instruction_signal(24 DOWNTO 20),
    write_address => instruction_signal(11 DOWNTO 7),
    data_in => write_or_jal_signal,
    data1_out => rs1_signal,
    data2_out => rs2_signal);

  -- Data memory instantiation
  mem_data_inst17 : mem_data
  PORT MAP (
    clock => clock,
    we => memWrite_signal,
    re => memRead_signal,
    address => Zout_signal(11 DOWNTO 0),
    data_in => rs2_signal,
    data_out => data_out_signal);

  -- Instruction memory instantiation
  mem_instr_inst18 : mem_instr
  PORT MAP (
    address => addr_out_signal(11 DOWNTO 0),
    data_out => instruction_signal);

  -- Output assignments
  instruction <= instruction_signal;
  rs1 <= rs1_signal;
  rs2 <= rs2_signal;
  rd <= write_data_signal;
  immediate <= immOut_signal;

END bdf_type;
