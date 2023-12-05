-- ROM module for RISC-V unicore
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity ROM_RV32 is
    port (
        address : in std_logic_vector(7 downto 0);
        dataout : out std_logic_vector(31 downto 0)
    );
end entity ROM_RV32;

architecture RTL of ROM_RV32 is

    -- Constants for ROM depth and width
    constant rom_depth : natural := 256;
    constant rom_width : natural := 32;

    -- Define the ROM type
    type rom_type is array (0 to rom_depth - 1) of std_logic_vector(rom_width - 1 downto 0);

    -- Function to initialize ROM from a hex file
    impure function init_rom_from_hex return rom_type is
        file hex_file : text open read_mode is "rom_content_hex.txt"; -- Adjust path as needed
        variable line_v : line;
        variable hex_value : std_logic_vector(31 downto 0);
        variable rom_contents : rom_type;
    begin
        for i in 0 to rom_depth - 1 loop
            if not endfile(hex_file) then
                readline(hex_file, line_v);
                hread(line_v, hex_value);
                rom_contents(i) := hex_value;
            else
                rom_contents(i) := (others => '0'); -- Fill remaining with 0s if file ends
            end if;
        end loop;
        return rom_contents;
    end function;

    -- Initialize ROM with data from file
    signal mem : rom_type := init_rom_from_hex;

begin
    -- Read operation for ROM
    process(address)
    begin
        dataout <= mem(to_integer(unsigned(address)));
    end process;

end RTL;
