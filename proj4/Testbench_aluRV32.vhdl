LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Testbench_AluRV32 IS
END Testbench_AluRV32;

ARCHITECTURE tb_arch OF Testbench_AluRV32 IS
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
            -- ADD
            opcode <= "0000"; -- ADD
            A <= std_logic_vector(to_unsigned(5, 32));
            B <= std_logic_vector(to_unsigned(3, 32));
            WAIT FOR 10 ms;
            -- REPORT "ADD: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(8, 32)) REPORT "ADD failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "ADD failed - zero" SEVERITY ERROR;

            REPORT "ADD OK";

            -- ADD (Zero)
            opcode <= "0000"; -- ADD
            A <= std_logic_vector(to_unsigned(0, 32));
            B <= std_logic_vector(to_unsigned(0, 32));
            WAIT FOR 10 ms;
            -- REPORT "ADD (Zero): " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(0, 32)) REPORT "ADD (Zero) failed - Z" SEVERITY ERROR;
            ASSERT zero = '1' REPORT "ADD (Zero) failed - zero" SEVERITY ERROR;

            REPORT "ADD (Zero) OK";

            -- SUB
            opcode <= "0001"; -- SUB
            A <= std_logic_vector(to_unsigned(10, 32));
            B <= std_logic_vector(to_unsigned(4, 32));
            WAIT FOR 10 ms;
            -- REPORT "SUB: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(6, 32)) REPORT "SUB failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SUB failed - zero" SEVERITY ERROR;

            REPORT "SUB OK";

            -- AND
            opcode <= "0010"; -- AND
            A <= std_logic_vector(to_unsigned(15, 32));
            B <= std_logic_vector(to_unsigned(7, 32));
            WAIT FOR 10 ms;
            -- REPORT "AND: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(7, 32)) REPORT "AND failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "AND failed - zero" SEVERITY ERROR;

            REPORT "AND OK";

            -- OR
            opcode <= "0011"; -- OR
            A <= std_logic_vector(to_unsigned(12, 32));
            B <= std_logic_vector(to_unsigned(5, 32));
            WAIT FOR 10 ms;
            -- REPORT "OR: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(13, 32)) REPORT "OR failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "OR failed - zero" SEVERITY ERROR;

            REPORT "OR OK";

            -- XOR
            opcode <= "0100"; -- XOR
            A <= std_logic_vector(to_unsigned(9, 32));
            B <= std_logic_vector(to_unsigned(3, 32));
            WAIT FOR 10 ms;
            -- REPORT "XOR: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(10, 32)) REPORT "XOR failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "XOR failed - zero" SEVERITY ERROR;

            REPORT "XOR OK";

            -- SLL
            opcode <= "0101"; -- SLL
            A <= std_logic_vector(to_unsigned(8, 32));
            B <= std_logic_vector(to_unsigned(2, 32)); -- Shift amount
            WAIT FOR 10 ms;
            -- REPORT "SLL: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(32, 32)) REPORT "SLL failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SLL failed - zero" SEVERITY ERROR;

            REPORT "SLL OK";

            -- SRL
            opcode <= "0110"; -- SRL
            A <= std_logic_vector(to_unsigned(16, 32));
            B <= std_logic_vector(to_unsigned(1, 32)); -- Shift amount
            WAIT FOR 10 ms;
            -- REPORT "SRL: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(8, 32)) REPORT "SRL failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SRL failed - zero" SEVERITY ERROR;

            REPORT "SRL OK";

            -- SRA
            opcode <= "0111"; -- SRA
            A <= std_logic_vector(to_unsigned(32, 32));
            B <= std_logic_vector(to_unsigned(2, 32)); -- Shift amount
            WAIT FOR 10 ms;
            -- REPORT "SRA: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(8, 32)) REPORT "SRA failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SRA failed - zero" SEVERITY ERROR;

            REPORT "SRA OK";

            -- SLT
            opcode <= "1000"; -- SLT
            A <= std_logic_vector(to_unsigned(5, 32));
            B <= std_logic_vector(to_unsigned(7, 32));
            WAIT FOR 10 ms;
            -- REPORT "SLT: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(1, 32)) REPORT "SLT failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SLT failed - zero" SEVERITY ERROR;

            REPORT "SLT OK";

            -- SLTU
            opcode <= "1001"; -- SLTU
            A <= std_logic_vector(to_unsigned(6, 32));
            B <= std_logic_vector(to_unsigned(8, 32));
            WAIT FOR 10 ms;
            -- REPORT "SLTU: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(1, 32)) REPORT "SLTU failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SLTU failed - zero" SEVERITY ERROR;

            REPORT "SLTU OK";

            -- SGE
            opcode <= "1010"; -- SGE
            A <= std_logic_vector(to_unsigned(9, 32));
            B <= std_logic_vector(to_unsigned(3, 32));
            WAIT FOR 10 ms;
            -- REPORT "SGE: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(1, 32)) REPORT "SGE failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SGE failed - zero" SEVERITY ERROR;

            REPORT "SGE OK";

            -- SGEU
            opcode <= "1011"; -- SGEU
            A <= std_logic_vector(to_unsigned(10, 32));
            B <= std_logic_vector(to_unsigned(5, 32));
            WAIT FOR 10 ms;
            -- REPORT "SGEU: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(1, 32)) REPORT "SGEU failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SGEU failed - zero" SEVERITY ERROR;

            REPORT "SGEU OK";

            -- SEQ
            opcode <= "1100"; -- SEQ
            A <= std_logic_vector(to_unsigned(4, 32));
            B <= std_logic_vector(to_unsigned(4, 32));
            WAIT FOR 10 ms;
            -- REPORT "SEQ: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(1, 32)) REPORT "SEQ failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SEQ failed- zero" SEVERITY ERROR;

            REPORT "SEQ OK";

            -- SNE
            opcode <= "1101"; -- SNE
            A <= std_logic_vector(to_unsigned(5, 32));
            B <= std_logic_vector(to_unsigned(6, 32));
            WAIT FOR 10 ms;
            -- REPORT "SNE: " & to_string(unsigned(Z)) & ", Zero flag: " & std_logic'image(zero);
            ASSERT Z = std_logic_vector(to_unsigned(1, 32)) REPORT "SNE failed - Z" SEVERITY ERROR;
            ASSERT zero = '0' REPORT "SNE failed - zero" SEVERITY ERROR;

            REPORT "SNE OK";


            WAIT;
        END PROCESS;
END tb_arch;
