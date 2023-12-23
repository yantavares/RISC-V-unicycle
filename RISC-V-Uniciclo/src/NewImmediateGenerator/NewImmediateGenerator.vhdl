
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity NewImmediateGenerator is
    port (
        instruction : in std_logic_vector(31 downto 0);
        immediate : out std_logic_vector(31 downto 0)
    );
end NewImmediateGenerator;

architecture hardware of NewImmediateGenerator is

    type FORMAT_RV is (R_type, I_type, I_type_shift, S_type, SB_type, UJ_type, U_type, Error_type);

    signal instruction_format : FORMAT_RV;

    signal opcode : std_logic_vector(6 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);

    -- signal rs1 : std_logic_vector(4 downto 0); HINT: lembrar de deixar linhas aqui para utilizar no projeto final
    -- signal rs1 : std_logic_vector(4 downto 0);
    -- signal rd : std_logic_vector(4 downto 0);

begin
    opcode <= instruction(6 downto 0);
    funct7 <= instruction(31 downto 25);
    funct3 <= instruction(14 downto 12);

    process(opcode, funct7, funct3, instruction)
    begin
        case opcode is
            when "0110011" =>
                instruction_format <= R_type;

            when "1100111" | "0000011" | "0010011" | "1110011"  =>
                if opcode = "0010011" and (funct3 = "101" or funct3 = "001") then
                    instruction_format <= I_type_shift;
                else
                    instruction_format <= I_type;
                end if;

            when "0100011" =>
                instruction_format <= S_type;

            when "1100011" =>
                instruction_format <= SB_type;

            when "0110111" | "0010111" =>
                instruction_format <= U_type;

            when "1101111" =>
                instruction_format <= UJ_type;

            when others =>
                instruction_format <= Error_type; 
        end case;
    end process;

    process(instruction_format, instruction)
    begin
        case instruction_format is
            when R_type => 
                immediate <= (others => '0');  -- HINT: (others => '0') atribui 0 para todos os bits

            when I_type =>
                immediate <= std_logic_vector(resize(signed(instruction(31 downto 20)), 32));

            when I_type_shift =>
                immediate <= std_logic_vector(resize(signed(instruction(24 downto 20)), 32));

            when S_type =>
                immediate <= std_logic_vector(resize(signed(instruction(31 downto 25) & instruction(11 downto 7)), 32));

            when SB_type =>
                immediate <= std_logic_vector(resize(signed(instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0'), 32));

            when UJ_type =>
                immediate <= std_logic_vector(resize(signed(instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0'), 32));

            when U_type =>
                immediate <= std_logic_vector(resize(signed(instruction(31 downto 12) & "000000000000"), 32));

            when others =>
                immediate <= (others => '0');

        end case;
    end process;
end hardware;
