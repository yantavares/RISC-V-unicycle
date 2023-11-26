LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Testbench_AluRV32 IS
END Testbench_AluRV32;

ARCHITECTURE tb_arch OF Testbench_AluRV32 IS
    -- Declaration of signals
    SIGNAL opcode: std_logic_vector(3 DOWNTO 0);
    SIGNAL A, B, Z: std_logic_vector(31 DOWNTO 0);
    SIGNAL zero: std_logic;

    -- Declaration of the ALU component
    COMPONENT AluRV32
        PORT (
            opcode : IN  std_logic_vector(3 DOWNTO 0);
            A, B   : IN  std_logic_vector(31 DOWNTO 0);
            Z      : OUT std_logic_vector(31 DOWNTO 0);
            zero   : OUT std_logic
        );
    END COMPONENT;

    -- Instantiation of the ALU
    BEGIN
        ULA: AluRV32 PORT MAP (opcode => opcode, A => A, B => B, Z => Z, zero => zero);

        -- Stimulus process
        PROCESS
        BEGIN
            -- Testing for each operation

            -- ADD
            opcode <= "0000"; -- ADD
            A <= std_logic_vector(to_unsigned(5, 32));
            B <= std_logic_vector(to_unsigned(3, 32));
            WAIT FOR 10 ns;
            REPORT "ADD: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SUB
            opcode <= "0001"; -- SUB
            A <= std_logic_vector(to_unsigned(10, 32));
            B <= std_logic_vector(to_unsigned(4, 32));
            WAIT FOR 10 ns;
            REPORT "SUB: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- AND
            opcode <= "0010"; -- AND
            A <= std_logic_vector(to_unsigned(15, 32));
            B <= std_logic_vector(to_unsigned(7, 32));
            WAIT FOR 10 ns;
            REPORT "AND: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- OR
            opcode <= "0011"; -- OR
            A <= std_logic_vector(to_unsigned(12, 32));
            B <= std_logic_vector(to_unsigned(5, 32));
            WAIT FOR 10 ns;
            REPORT "OR: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- XOR
            opcode <= "0100"; -- XOR
            A <= std_logic_vector(to_unsigned(9, 32));
            B <= std_logic_vector(to_unsigned(3, 32));
            WAIT FOR 10 ns;
            REPORT "XOR: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SLL
            opcode <= "0101"; -- SLL
            A <= std_logic_vector(to_unsigned(8, 32));
            B <= std_logic_vector(to_unsigned(2, 32)); -- Shift amount
            WAIT FOR 10 ns;
            REPORT "SLL: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SRL
            opcode <= "0110"; -- SRL
            A <= std_logic_vector(to_unsigned(16, 32));
            B <= std_logic_vector(to_unsigned(1, 32)); -- Shift amount
            WAIT FOR 10 ns;
            REPORT "SRL: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SRA
            opcode <= "0111"; -- SRA
            A <= std_logic_vector(to_unsigned(32, 32));
            B <= std_logic_vector(to_unsigned(2, 32)); -- Shift amount
            WAIT FOR 10 ns;
            REPORT "SRA: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SLT
            opcode <= "1000"; -- SLT
            A <= std_logic_vector(to_unsigned(5, 32));
            B <= std_logic_vector(to_unsigned(7, 32));
            WAIT FOR 10 ns;
            REPORT "SLT: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SLTU
            opcode <= "1001"; -- SLTU
            A <= std_logic_vector(to_unsigned(6, 32));
            B <= std_logic_vector(to_unsigned(8, 32));
            WAIT FOR 10 ns;
            REPORT "SLTU: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SGE
            opcode <= "1010"; -- SGE
            A <= std_logic_vector(to_unsigned(9, 32));
            B <= std_logic_vector(to_unsigned(3, 32));
            WAIT FOR 10 ns;
            REPORT "SGE: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SGEU
            opcode <= "1011"; -- SGEU
            A <= std_logic_vector(to_unsigned(10, 32));
            B <= std_logic_vector(to_unsigned(5, 32));
            WAIT FOR 10 ns;
            REPORT "SGEU: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SEQ
            opcode <= "1100"; -- SEQ
            A <= std_logic_vector(to_unsigned(4, 32));
            B <= std_logic_vector(to_unsigned(4, 32));
            WAIT FOR 10 ns;
            REPORT "SEQ: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);

            -- SNE
            opcode <= "1101"; -- SNE
            A <= std_logic_vector(to_unsigned(5, 32));
            B <= std_logic_vector(to_unsigned(6, 32));
            WAIT FOR 10 ns;
            REPORT "SNEs: " & SLV_to_string(Z) & ", Zero flag: " & std_logic'image(zero);


            WAIT;
        END PROCESS;
END tb_arch;
