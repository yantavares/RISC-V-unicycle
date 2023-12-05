library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Testbench_XREG is
end Testbench_XREG;

architecture behavior of Testbench_XREG is 
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

    -- Test control
    signal test_finished : boolean := false;

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
    clk_process : process
    begin
        while not test_finished loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;  -- Terminate the process after the test is finished
    end process;

    -- Test process
    stim_proc: process
    begin
        -- Initialize
        wren <= '0';
        wait for clk_period;

        -- Write to register
        rd <= "00001"; -- Register 1
        data <= X"12345678";
        wren <= '1';
        wait for clk_period;
        wren <= '0';
        wait for clk_period; -- Ensure a full clock cycle before reading

        -- Read from register
        rs1 <= "00001"; -- Read from register 1
        wait for clk_period;
        assert (ro1 = X"12345678") report "Write and read from register test failed" severity failure;
        report "Write and read from register test passed" severity note;

        -- Ensure register 0 is constant
        -- Write to register 0 (should have no effect)
        rd <= "00000"; -- Register 0 (constant)
        data <= X"FFFFFFFF";
        wren <= '1';
        wait for clk_period;
        wren <= '0';
        wait for clk_period; -- Ensure a full clock cycle before reading

        -- Read from register 0 (should still be zero)
        rs1 <= "00000"; -- Read from register 0
        wait for clk_period;
        assert (ro1 = X"00000000") report "Ensure register 0 is constant test failed" severity failure;
        report "Ensure register 0 is constant test passed" severity note;

        -- Read from unwritten registers
        rs1 <= "00010"; -- Unwritten register
        rs2 <= "00011"; -- Another unwritten register
        wait for clk_period;
        assert (ro1 = X"00000000") report "Unwritten register test failed - register 1" severity failure;
        report "Unwritten register test passed - rs1" severity note;

        assert (ro2 = X"00000000") report "Unwritten register test failed - register 2" severity failure;
        report "Unwritten register test passed - rs2" severity note;

        -- Multiple writes and reads
        -- Write to registers
        for i in 1 to 31 loop
            rd <= std_logic_vector(to_unsigned(i, 5));
            data <= std_logic_vector(to_unsigned(i*111, 32)); -- Some arbitrary data
            wren <= '1';
            wait for clk_period;
            wren <= '0';
            wait for clk_period;
        end loop;

        -- Read from registers and check values
        for i in 1 to 31 loop
            rs1 <= std_logic_vector(to_unsigned(i, 5));
            wait for clk_period;
            assert (ro1 = std_logic_vector(to_unsigned(i*111, 32))) report "Multiple writes/reads test failed for register" & integer'image(i) severity failure;
            report "Multiple writes/reads test passed - register " & integer'image(i) severity note;
        end loop;

        -- Simultaneous read from two registers
        rd <= "00100"; -- Register 4
        data <= X"A5A5A5A5";
        wren <= '1';
        wait for clk_period;
        wren <= '0';

        rd <= "00101"; -- Register 5
        data <= X"5A5A5A5A";
        wren <= '1';
        wait for clk_period;
        wren <= '0';

        rs1 <= "00100"; -- Read from register 4
        rs2 <= "00101"; -- Read from register 5
        wait for clk_period;
        assert (ro1 = X"A5A5A5A5") report "Simultaneous read test failed - register 4" severity failure;
        report "Simultaneous read test passed - register 4" severity note;

        assert (ro2 = X"5A5A5A5A") report "Simultaneous read test failed - register 5" severity failure;
        report "Simultaneous read test passed - register 5" severity note;

        -- End of test
        test_finished <= true;
        wait;
    end process;
end behavior;
