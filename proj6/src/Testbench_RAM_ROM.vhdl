library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_ram_rom is
end entity testbench_ram_rom;

architecture behavior of testbench_ram_rom is
    -- Component declaration for the RAM and ROM
    component RAM_RV32
        port (
            clock   : in std_logic;
            we      : in std_logic;
            address : in std_logic_vector(7 downto 0);
            datain  : in std_logic_vector(31 downto 0);
            dataout : out std_logic_vector(31 downto 0)
        );
    end component;

    component ROM_RV32
        port (
            address : in std_logic_vector(7 downto 0);
            dataout : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals for interfacing with the RAM and ROM
    signal clock   : std_logic := '0';
    signal we      : std_logic := '0'; 
    signal address : std_logic_vector(7 downto 0) := (others => '0'); 
    signal datain  : std_logic_vector(31 downto 0) := (others => '0'); 
    signal dataout_ram : std_logic_vector(31 downto 0) := (others => '0'); 
    signal dataout_rom : std_logic_vector(31 downto 0) := (others => '0'); 
    signal test_finished : boolean := false;

begin
    -- Instantiate the RAM and ROM
    uut_ram: component RAM_RV32
        port map (
            clock   => clock,
            we      => we,
            address => address,
            datain  => datain,
            dataout => dataout_ram
        );

    uut_rom: component ROM_RV32
        port map (
            address => address,
            dataout => dataout_rom
        );

    -- Clock process
    clock_process: process
    begin
        while not test_finished loop
            clock <= '0';
            wait for 5 ns;
            clock <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Testbench stimulus process
    stimulus_process: process
    begin
        wait for 20 ns; -- Wait for initial stabilization

        -- RAM test: Write and read sequence
        for i in 0 to 255 loop
            -- Write operation
            we <= '1';
            address <= std_logic_vector(to_unsigned(i, 8));
            datain <= std_logic_vector(to_unsigned(i, 32));
            wait for 10 ns;
            
            -- Read operation
            we <= '0';
            address <= std_logic_vector(to_unsigned(i, 8));
            wait for 10 ns;
            
            -- Assertion to check if the read data matches the written data
            assert dataout_ram = std_logic_vector(to_unsigned(i, 32))
            report "RAM test failed at address " & integer'image(i)
            severity error;

            report "RAM test passed at address " & integer'image(i) severity note;
        
        end loop;

        -- ROM test: Read and verify contents
        for i in 0 to 255 loop
            address <= std_logic_vector(to_unsigned(i, 8));
            wait for 10 ns; -- Wait for the ROM to output the data

            -- Assertion to check if the ROM data matches the expected value
            assert dataout_rom = std_logic_vector(to_unsigned(i, 32))
            report "ROM test failed at address " & integer'image(i) & 
                " Expected: " & to_string(std_logic_vector(to_unsigned(i, 32))) & 
                " Got: " & to_string(dataout_rom)
            severity error;

            report "ROM test passed at address " & integer'image(i) severity note;

        end loop;
        
        test_finished <= true;
        wait; 
    end process;

end architecture behavior;
