library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity XREG_TB is
-- Testbench entities do not have ports.
end XREG_TB;

architecture behavior of XREG_TB is 
    -- Component Declaration for the Unit Under Test (UUT)
    component XREG
    Port ( clk   : in  STD_LOGIC;
           wren  : in  STD_LOGIC;
           rs1   : in  STD_LOGIC_VECTOR (4 downto 0);
           rs2   : in  STD_LOGIC_VECTOR (4 downto 0);
           rd    : in  STD_LOGIC_VECTOR (4 downto 0);
           data  : in  STD_LOGIC_VECTOR (31 downto 0);
           ro1   : out STD_LOGIC_VECTOR (31 downto 0);
           ro2   : out STD_LOGIC_VECTOR (31 downto 0)
         );
    end component;

    --Inputs
    signal clk   : STD_LOGIC := '0';
    signal wren  : STD_LOGIC := '0';
    signal rs1   : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal rs2   : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal rd    : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal data  : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

    --Outputs
    signal ro1   : STD_LOGIC_VECTOR (31 downto 0);
    signal ro2   : STD_LOGIC_VECTOR (31 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: XREG Port Map (
          clk => clk,
          wren => wren,
          rs1 => rs1,
          rs2 => rs2,
          rd => rd,
          data => data,
          ro1 => ro1,
          ro2 => ro2
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Test process
    stim_proc: process
    begin		
        -- Test case 1: Write and read from register
        rd <= "00001"; -- Register 1
        data <= X"12345678";
        wren <= '1';
        wait for clk_period*10;
        wren <= '0';
        rs1 <= "00001"; -- Read from register 1
        wait for clk_period*10;
        

        -- Test case 2: Ensure register 0 is constant
        rd <= "00000"; -- Register 0 (constant)
        data <= X"FFFFFFFF";
        wren <= '1';
        wait for clk_period*10;
        wren <= '0';
        rs1 <= "00000"; -- Read from register 0
        wait for clk_period*10;

        -- Test completed
        assert (ro1 = X"12345678") report "Test case 1 failed" severity error;
        assert (ro2 = X"00000000") report "Test case 2 failed" severity error;

        wait;
    end process;
end behavior;
