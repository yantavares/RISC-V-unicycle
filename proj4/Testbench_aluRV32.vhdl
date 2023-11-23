LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ula_tb IS
END ula_tb;

ARCHITECTURE tb_arch OF ula_tb IS
    -- Declaração de sinais
    SIGNAL opcode: std_logic_vector(3 DOWNTO 0);
    SIGNAL A, B, Z: std_logic_vector(31 DOWNTO 0);
    SIGNAL zero: std_logic;

    -- Declaração do componente ULA
    COMPONENT ulaRV
        PORT (
            opcode : IN  std_logic_vector(3 DOWNTO 0);
            A, B   : IN  std_logic_vector(31 DOWNTO 0);
            Z      : OUT std_logic_vector(31 DOWNTO 0);
            zero   : OUT std_logic
        );
    END COMPONENT;

    -- Instanciação da ULA
    BEGIN
        ULA: ulaRV PORT MAP (opcode => opcode, A => A, B => B, Z => Z, zero => zero);

        -- Processo de Estímulo
        PROCESS
        BEGIN
            -- Teste para cada operação
            -- Exemplo: ADD
            opcode <= "0000"; -- ADD
            A <= std_logic_vector(to_unsigned(5, 32));
            B <= std_logic_vector(to_unsigned(3, 32));
            WAIT FOR 10 ns;

            -- SUB
            -- E assim por diante para todas as operações...

            WAIT;
        END PROCESS;
END tb_arch;
