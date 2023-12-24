
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity NewXREG is
    generic (WSIZE : natural := 32);
    port (
        wren : in std_logic;
        rs1, rs2, rd : in std_logic_vector(4 downto 0);
        data : in std_logic_vector(WSIZE-1 downto 0);
        ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
    );
end NewXREG;


architecture hardware of NewXREG is
    type array_of_register is array (0 to 31) of std_logic_vector(WSIZE-1 downto 0); 
    signal registers_array : array_of_register := (others => (others => '0'));  --todos os regs sao inicializados com o valor 0 no formato de array de 32 bits

begin

    process(wren, rd, rs1, rs2)
    begin

          if wren = '1' then
              if to_integer(unsigned(rd)) /= 0 then registers_array(to_integer(unsigned(rd))) <= data; --XREG[rd] = data, apenas se rd não for 0
              end if;
          end if;

          ro1 <= X"00000000" when rs1 = "00000" else registers_array(to_integer(unsigned(rs1))); --essa e a proxima linha tambem grantem que o reg0 sempre vai ser 0
          ro2 <= X"00000000" when rs2 = "00000" else registers_array(to_integer(unsigned(rs2))); --para fornecer uma garantia extra do tratamento do reg0

    end process;
end hardware;