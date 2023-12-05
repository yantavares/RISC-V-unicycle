library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity XREG is
    Port ( clk   : in  STD_LOGIC;
           wren  : in  STD_LOGIC;
           rs1   : in  STD_LOGIC_VECTOR (4 downto 0);
           rs2   : in  STD_LOGIC_VECTOR (4 downto 0);
           rd    : in  STD_LOGIC_VECTOR (4 downto 0);
           data  : in  STD_LOGIC_VECTOR (31 downto 0);
           ro1   : out STD_LOGIC_VECTOR (31 downto 0);
           ro2   : out STD_LOGIC_VECTOR (31 downto 0)
         );
end XREG;

architecture Behavioral of XREG is
    type reg_array is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if wren = '1' and to_integer(unsigned(rd)) /= 0 then
                registers(to_integer(unsigned(rd))) <= data;
            end if;

            ro1 <= registers(to_integer(unsigned(rs1)));
            ro2 <= registers(to_integer(unsigned(rs2)));
        end if;
    end process;
end Behavioral;
