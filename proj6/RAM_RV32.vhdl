-- RAM module for RISC-V unicore
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM_RV32 is
    port (
        clock   : in std_logic;
        we      : in std_logic;
        address : in std_logic_vector(7 downto 0);
        datain  : in std_logic_vector(31 downto 0) := (others => '0'); -- Default value (Avoid undefined value)
        dataout : out std_logic_vector(31 downto 0)
    );
end entity RAM_RV32;

architecture RTL of RAM_RV32 is
    type mem_type is array (0 to 255) of std_logic_vector(31 downto 0);
    signal mem : mem_type;
    signal read_address : std_logic_vector(7 downto 0) := (others => '0');
begin
    -- Read and write process
    process(clock)
    begin
        if rising_edge(clock) then
            if we = '1' then
                -- Write operation
                mem(to_integer(unsigned(address))) <= datain;
            else
                -- Read operation
                read_address <= address;
            end if;
        end if;
    end process;

    -- Data output
    dataout <= mem(to_integer(unsigned(read_address)));

end RTL;
