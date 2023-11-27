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
            A <= std_logic_vector(to_signed(5, 32));
            B <= std_logic_vector(to_signed(3, 32));
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(8, 32)) REPORT "ADD failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "ADD failed - zero" SEVERITY FAILURE;
            REPORT "ADD OK";

            -- ADD (Zero)
            opcode <= "0000"; -- ADD
            A <= std_logic_vector(to_signed(0, 32));
            B <= std_logic_vector(to_signed(0, 32));
            WAIT FOR 10 ns;          
            ASSERT Z = std_logic_vector(to_signed(0, 32)) REPORT "ADD (Zero) failed - Z" SEVERITY FAILURE;
            ASSERT zero = '1' REPORT "ADD (Zero) failed - zero" SEVERITY FAILURE;
            REPORT "ADD (Zero) OK";

            -- SUB
            opcode <= "0001"; -- SUB
            A <= std_logic_vector(to_signed(10, 32));
            B <= std_logic_vector(to_signed(4, 32));
            WAIT FOR 10 ns;    
            ASSERT Z = std_logic_vector(to_signed(6, 32)) REPORT "SUB failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SUB failed - zero" SEVERITY FAILURE;
            REPORT "SUB OK";

            -- AND
            opcode <= "0010"; -- AND
            A <= std_logic_vector(to_signed(15, 32));
            B <= std_logic_vector(to_signed(7, 32));
            WAIT FOR 10 ns;       
            ASSERT Z = std_logic_vector(to_signed(7, 32)) REPORT "AND failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "AND failed - zero" SEVERITY FAILURE;
            REPORT "AND OK";

            -- OR
            opcode <= "0011"; -- OR
            A <= std_logic_vector(to_signed(12, 32));
            B <= std_logic_vector(to_signed(5, 32));
            WAIT FOR 10 ns;    
            ASSERT Z = std_logic_vector(to_signed(13, 32)) REPORT "OR failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "OR failed - zero" SEVERITY FAILURE;
            REPORT "OR OK";

            -- XOR
            opcode <= "0100"; -- XOR
            A <= std_logic_vector(to_signed(9, 32));
            B <= std_logic_vector(to_signed(3, 32));
            WAIT FOR 10 ns;          
            ASSERT Z = std_logic_vector(to_signed(10, 32)) REPORT "XOR failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "XOR failed - zero" SEVERITY FAILURE;
            REPORT "XOR OK";

            -- SLL
            opcode <= "0101"; -- SLL
            A <= std_logic_vector(to_signed(8, 32));
            B <= std_logic_vector(to_signed(2, 32)); -- Shift amount
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(32, 32)) REPORT "SLL failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SLL failed - zero" SEVERITY FAILURE;
            REPORT "SLL OK";

            -- SRL
            opcode <= "0110"; -- SRL
            A <= std_logic_vector(to_signed(16, 32));
            B <= std_logic_vector(to_signed(1, 32)); -- Shift amount
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(8, 32)) REPORT "SRL failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SRL failed - zero" SEVERITY FAILURE;
            REPORT "SRL OK";

            -- SRA
            opcode <= "0111"; -- SRA
            A <= std_logic_vector(to_signed(32, 32));
            B <= std_logic_vector(to_signed(2, 32)); -- Shift amount
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(8, 32)) REPORT "SRA failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SRA failed - zero" SEVERITY FAILURE;
            REPORT "SRA OK";

            -- SLT
            opcode <= "1000"; -- SLT
            A <= std_logic_vector(to_signed(5, 32));
            B <= std_logic_vector(to_signed(7, 32));
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(1, 32)) REPORT "SLT failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SLT failed - zero" SEVERITY FAILURE;
            REPORT "SLT OK";

            -- SLTU
            opcode <= "1001"; -- SLTU
            A <= std_logic_vector(to_signed(6, 32));
            B <= std_logic_vector(to_signed(8, 32));
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(1, 32)) REPORT "SLTU failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SLTU failed - zero" SEVERITY FAILURE;
            REPORT "SLTU OK";

            -- SGE
            opcode <= "1010"; -- SGE
            A <= std_logic_vector(to_signed(9, 32));
            B <= std_logic_vector(to_signed(3, 32));
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(1, 32)) REPORT "SGE failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SGE failed - zero" SEVERITY FAILURE;
            REPORT "SGE OK";

            -- SGEU
            opcode <= "1011"; -- SGEU
            A <= std_logic_vector(to_signed(10, 32));
            B <= std_logic_vector(to_signed(5, 32));
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(1, 32)) REPORT "SGEU failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SGEU failed - zero" SEVERITY FAILURE;
            REPORT "SGEU OK";

            -- SEQ
            opcode <= "1100"; -- SEQ
            A <= std_logic_vector(to_signed(4, 32));
            B <= std_logic_vector(to_signed(4, 32));
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(1, 32)) REPORT "SEQ failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SEQ failed- zero" SEVERITY FAILURE;
            REPORT "SEQ OK";

            -- SEQ (Zero)
            opcode <= "1100"; -- SEQ
            A <= std_logic_vector(to_signed(2, 32));
            B <= std_logic_vector(to_signed(4, 32));
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(0, 32)) REPORT "SEQ (Zero) failed - Z" SEVERITY FAILURE;
            ASSERT zero = '1' REPORT "SEQ (Zero) failed- zero" SEVERITY FAILURE;
            REPORT "SEQ (Zero) OK";

            -- SNE
            opcode <= "1101"; -- SNE
            A <= std_logic_vector(to_signed(5, 32));
            B <= std_logic_vector(to_signed(6, 32));
            WAIT FOR 10 ns;
            ASSERT Z = std_logic_vector(to_signed(1, 32)) REPORT "SNE failed - Z" SEVERITY FAILURE;
            ASSERT zero = '0' REPORT "SNE failed - zero" SEVERITY FAILURE;
            REPORT "SNE OK";

            WAIT;
        END PROCESS;
END tb_arch;
