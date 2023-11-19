library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NandGate is
    Port (
        A : in  STD_LOGIC;
        B : in  STD_LOGIC;
        Y : out STD_LOGIC
    );
end NandGate;

architecture Behavioral of NandGate is
begin
    Y <= not (A and B);
end Behavioral;
