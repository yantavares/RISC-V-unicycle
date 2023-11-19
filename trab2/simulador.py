import numpy as np
from collections import namedtuple


class simulador:

    type_R = namedtuple('type_R', ['opcode', 'funct3', 'funct7'])
    type_I = namedtuple('type_I', ['opcode', 'funct3'])
    type_I_shift = namedtuple('type_I', ['opcode', 'funct3', 'funct7'])
    type_I_ecall = namedtuple(
        'type_I', ['opcode', 'funct3', 'instruction_minus_opcode'])
    type_S = namedtuple('type_S', ['opcode', 'funct3'])
    type_SB = namedtuple('type_SB', ['opcode', 'funct3'])
    type_U = namedtuple('type_U', ['opcode'])
    type_UJ = namedtuple('type_UJ', ['opcode'])

    dict_opcodes = {
        type_R(opcode=np.uint32(0b0110011),
               funct3=np.uint32(0b000),
               funct7=np.uint32(0b0000000)): 'add',

        type_I(opcode=np.uint32(0b0010011),
               funct3=np.uint32(0b000)): 'addi',

        type_R(opcode=np.uint32(0b0110011),
               funct3=np.uint32(0b111),
               funct7=np.uint32(0b0000000)): 'and_',  # coloquei o underline porque o and é uma palavra reservada do python

        type_I(opcode=np.uint32(0b0010011),
               funct3=np.uint32(0b111)): 'andi',

        type_U(opcode=np.uint32(0b0010111)): 'auipc',

        type_SB(opcode=np.uint32(0b1100011),
                funct3=np.uint32(0b000)): 'beq',

        type_SB(opcode=np.uint32(0b1100011),
                funct3=np.uint32(0b001)): 'bne',

        type_SB(opcode=np.uint32(0b1100011),
                funct3=np.uint32(0b101)): 'bge',

        type_SB(opcode=np.uint32(0b1100011),
                funct3=np.uint32(0b111)): 'bgeu',

        type_SB(opcode=np.uint32(0b1100011),
                funct3=np.uint32(0b100)): 'blt',

        type_SB(opcode=np.uint32(0b1100011),
                funct3=np.uint32(0b110)): 'bltu',

        type_UJ(opcode=np.uint32(0b1101111)): 'jal',

        type_I(opcode=np.uint32(0b1100111),
               funct3=np.uint32(0b000)): 'jalr',

        type_I(opcode=np.uint32(0b0000011),
               funct3=np.uint32(0b000)): 'lb',

        type_R(opcode=np.uint32(0b0110011),
               funct3=np.uint32(0b110),
               funct7=np.uint32(0b0000000)): 'or_',  # coloquei o underline porque o or é uma palavra reservada do python

        type_I(opcode=np.uint32(0b0000011),
               funct3=np.uint32(0b100)): 'lbu',

        type_I(opcode=np.uint32(0b0000011),
               funct3=np.uint32(0b010)): 'lw',

        type_U(opcode=np.uint32(0b0110111)): 'lui',

        type_R(opcode=np.uint32(0b0110011),
               funct3=np.uint32(0b010),
               funct7=np.uint32(0b0000000)): 'slt',

        type_R(opcode=np.uint32(0b0110011),
               funct3=np.uint32(0b011),
               funct7=np.uint32(0b0000000)): 'sltu',

        type_I(opcode=np.uint32(0b0010011),
               funct3=np.uint32(0b110)): 'ori',

        type_S(opcode=np.uint32(0b0100011),
               funct3=np.uint32(0b000)): 'sb',

        type_I_shift(opcode=np.uint32(0b0010011),
                     funct3=np.uint32(0b001),
                     funct7=np.uint32(0b0000000)): 'slli',

        type_I_shift(opcode=np.uint32(0b0010011),
                     funct3=np.uint32(0b101),
                     funct7=np.uint32(0b0100000)): 'srai',

        type_I_shift(opcode=np.uint32(0b0010011),
                     funct3=np.uint32(0b101),
                     funct7=np.uint32(0b0000000)): 'srli',

        type_R(opcode=np.uint32(0b0110011),
               funct3=np.uint32(0b000),
               funct7=np.uint32(0b0100000)): 'sub',

        type_S(opcode=np.uint32(0b0100011),
               funct3=np.uint32(0b010)): 'sw',

        type_R(opcode=np.uint32(0b0110011),
               funct3=np.uint32(0b100),
               funct7=np.uint32(0b0000000)): 'xor',

        type_I_ecall(opcode=np.uint32(0b1110011),
                     funct3=np.uint32(0b000),
                     instruction_minus_opcode=np.uint32(0b0)): 'ecall',
    }

    def __init__(self, text_bin_file_text, data_bin_file_path):
        self.text_file_path = text_bin_file_text
        self.data_file_path = data_bin_file_path

        self.memory = self._gen_mem(16384)

        self.registers = np.zeros(32, dtype=np.int32)

        self.pc = np.uint32(0)
        self.ri = np.uint32(0)
        self.sp = np.uint32(0x00003ffc)
        self.gp = np.uint32(0x00001800)

        # salvar o endereco de memoria do stack pointer no registrador x2
        self.registers[2] = self.sp
        # salvar o endereco de memoria do global pointer no registrador x3
        self.registers[3] = self.gp

        self.opcode = np.uint32(0)
        self.rs1 = np.uint32(0)
        self.rs2 = np.uint32(0)
        self.rd = np.uint32(0)
        self.shamt = np.uint32(0)
        self.funct3 = np.uint32(0)
        self.funct7 = np.uint8(0)

        self.flag_jump = False
        self.flag_exit = False

        self._8bit_list_text = self.turn_bin_file_to_numpy_array(
            self.text_file_path)
        self._8bit_list_data = self.turn_bin_file_to_numpy_array(
            self.data_file_path)

        self.load_mem(self._8bit_list_text, self._8bit_list_data)

        self.run()

    def __dict_has_value(self, dictionary, key):
        return dictionary.get(key, None) is not None

    def turn_bin_file_to_numpy_array(self, file_path):
        return np.fromfile(file_path, dtype=np.uint8)

    def _gen_mem(self, MEM_SIZE):
        mem = np.zeros(MEM_SIZE, dtype=np.int8)
        return mem

    def load_mem(self, text_array, data_array):
        text_size = len(text_array)
        data_size = len(data_array)

        self.memory[0:text_size] = text_array
        self.memory[8192:8192+data_size] = data_array

    # retorna um inteiro de 32 bits unsigned
    def get_bits_unsigned(self, number_32bits, start, end):
        mask = (2**(end - start + 1) - 1) << start
        bits = (number_32bits & mask) >> start
        return np.uint32(bits)

    def get_bits_signed(self, number_32bits, start, end):  # retorna um inteiro de 32 bits
        mask = (2**(end - start + 1) - 1) << start
        bits = (number_32bits & mask) >> start
        if (bits >> (end - start)) == 1:
            bits = bits - 2**(end - start + 1)
        return np.int32(bits)

    def decode(self, instruction_32bits):
        def _decode_U(instruction_32bits):
            self.rd = self.get_bits_unsigned(instruction_32bits, 7, 11)
            self.imm = self.get_bits_signed(instruction_32bits, 12, 31)
            self.imm = self.imm << 12
            return self.dict_opcodes[self.type_U(self.opcode)]

        def _decode_UJ(instruction_32bits):
            self.rd = self.get_bits_unsigned(instruction_32bits, 7, 11)
            self.imm = (self.get_bits_signed(
                instruction_32bits, 31, 31) << 20)  # bit 20
            # bits 12-19
            self.imm += (self.get_bits_unsigned(instruction_32bits, 12, 19) << 12)
            # bit 11
            self.imm += (self.get_bits_unsigned(instruction_32bits, 20, 20) << 11)
            # bits 1-10 (bit 0 é sempre 0)
            self.imm += (self.get_bits_unsigned(instruction_32bits, 21, 30) << 1)
            return self.dict_opcodes[self.type_UJ(self.opcode)]

        def _decode_S(instruction_32bits):
            self.imm = self.get_bits_signed(instruction_32bits, 25, 31)
            self.imm = self.imm << 5
            self.imm = self.imm + \
                self.get_bits_unsigned(instruction_32bits, 7, 11)
            self.rs1 = self.get_bits_unsigned(instruction_32bits, 15, 19)
            # lembrar que rs1 e rs2 só podem ser valores positivos pois indicam o numero do registrador
            self.rs2 = self.get_bits_unsigned(instruction_32bits, 20, 24)
            self.funct3 = self.get_bits_unsigned(instruction_32bits, 12, 14)
            return self.dict_opcodes[(self.opcode, self.funct3)]

        def _decode_SB(instruction_32bits):
            self.imm = (self.get_bits_signed(
                instruction_32bits, 31, 31) << 12)  # bit 12
            # bit 11
            self.imm += (self.get_bits_unsigned(instruction_32bits, 7, 7) << 11)
            # bits 5-10
            self.imm += (self.get_bits_unsigned(instruction_32bits, 25, 30) << 5)
            # bits 1-4 (bit 0 é sempre 0)
            self.imm += (self.get_bits_unsigned(instruction_32bits, 8, 11) << 1)
            self.rs1 = self.get_bits_unsigned(instruction_32bits, 15, 19)
            self.rs2 = self.get_bits_unsigned(instruction_32bits, 20, 24)
            self.funct3 = self.get_bits_unsigned(instruction_32bits, 12, 14)
            return self.dict_opcodes[(self.opcode, self.funct3)]

        def _decode_R(instruction_32bits):
            self.rd = self.get_bits_unsigned(instruction_32bits, 7, 11)
            self.rs1 = self.get_bits_unsigned(instruction_32bits, 15, 19)
            self.rs2 = self.get_bits_unsigned(instruction_32bits, 20, 24)
            self.funct3 = self.get_bits_unsigned(instruction_32bits, 12, 14)
            self.funct7 = self.get_bits_unsigned(instruction_32bits, 25, 31)
            return self.dict_opcodes[(self.opcode, self.funct3, self.funct7)]

        def _decode_I_loads(instruction_32bits):
            self.rd = self.get_bits_unsigned(instruction_32bits, 7, 11)
            self.rs1 = self.get_bits_unsigned(instruction_32bits, 15, 19)
            self.imm = self.get_bits_signed(instruction_32bits, 20, 31)
            self.funct3 = self.get_bits_unsigned(instruction_32bits, 12, 14)
            return self.dict_opcodes[(self.opcode, self.funct3)]

        def _decode_I_arit_shift(instruction_32bits):
            self.funct3 = self.get_bits_unsigned(instruction_32bits, 12, 14)

            if self.funct3 in (0b001, 0b101):
                self.rd = self.get_bits_unsigned(instruction_32bits, 7, 11)
                self.rs1 = self.get_bits_unsigned(instruction_32bits, 15, 19)
                self.imm = self.get_bits_unsigned(instruction_32bits, 20, 24)
                self.shamt = self.get_bits_unsigned(instruction_32bits, 20, 24)
                self.funct7 = self.get_bits_unsigned(
                    instruction_32bits, 25, 31)
                return self.dict_opcodes[(self.opcode, self.funct3, self.funct7)]
            else:
                self.rd = self.get_bits_unsigned(instruction_32bits, 7, 11)
                self.rs1 = self.get_bits_unsigned(instruction_32bits, 15, 19)
                self.imm = self.get_bits_signed(instruction_32bits, 20, 31)
                return self.dict_opcodes[(self.opcode, self.funct3)]

        def _decode_I_ecall(instruction_32bits):
            self.funct3 = self.get_bits_unsigned(instruction_32bits, 12, 14)
            instruction_minus_opcode = self.get_bits_unsigned(
                instruction_32bits, 7, 31)
            return self.dict_opcodes[(self.opcode, self.funct3, instruction_minus_opcode)]

        self.opcode = self.get_bits_unsigned(instruction_32bits, 0, 6)

        if self.opcode in (0b0110111, 0b0010111):  # tipo U
            return _decode_U(instruction_32bits)
        elif self.opcode == 0b1101111:  # tipo UJ
            return _decode_UJ(instruction_32bits)
        elif self.opcode == 0b0100011:  # tipo S
            return _decode_S(instruction_32bits)
        elif self.opcode == 0b1100011:  # tipo SB
            return _decode_SB(instruction_32bits)
        elif self.opcode == 0b0110011:  # tipo R
            return _decode_R(instruction_32bits)
        elif self.opcode in (0b0000011, 0b1100111):  # tipo I for loads
            return _decode_I_loads(instruction_32bits)
        elif self.opcode == 0b0010011:  # tipo I for arithmetic and shifts
            return _decode_I_arit_shift(instruction_32bits)
        elif self.opcode == 0b1110011:  # tipo I for ecall
            return _decode_I_ecall(instruction_32bits)

    def fetch(self):
        self.ri = self.memory[self.pc].astype(np.uint8).astype(np.uint32)
        self.ri += (self.memory[self.pc +
                    1].astype(np.uint8).astype(np.uint32) << 8)
        self.ri += (self.memory[self.pc +
                    2].astype(np.uint8).astype(np.uint32) << 16)
        self.ri += (self.memory[self.pc +
                    3].astype(np.uint8).astype(np.uint32) << 24)

        self.pc += 4

    def execute(self):
        self.fetch()
        str_instruction = self.decode(self.ri)
        getattr(self, str_instruction)()
        # garantir que o registrador x0 sempre seja 0
        self.registers[0] = np.uint32(0)

    def step(self):
        self.execute()

    def run(self):
        while not self.flag_exit:
            self.step()

    def normalize_pc(self):  # funçao que criei para normalizar o pc quando fazemos saltos condicionais ou incondicionais, visto que na funcao fetch o pc ja é incrementado em 4
        return self.pc - 4

    def lb(self):
        byte = self.get_bits_signed(
            self.memory[self.registers[self.rs1] + self.imm], 0, 7)
        self.registers[self.rd] = np.int32(byte)

    def lbu(self):
        byte = self.get_bits_unsigned(
            self.memory[self.registers[self.rs1] + self.imm], 0, 7)
        self.registers[self.rd] = np.int32(byte)

    def lw(self):
        address = self.registers[self.rs1] + self.imm
        value = np.uint32(0)
        for i in range(4):
            value += (((self.memory[address+i]).astype(
                np.uint8).astype(np.uint32)) << (i*8)).astype(np.uint32)
        self.registers[self.rd] = np.int32(value)

    def lui(self):  # lembrar que o decode ja salvou o imediato da forma correta (deslocado 12 bits para a esquerda)
        self.registers[self.rd] = np.int32(self.imm)

    # lembrar que na hora de armazenar os bytes não importa a interpretação do valor, então usar get_bits_unsigned

    def sb(self):
        self.memory[self.registers[self.rs1] + self.imm] = np.int8(
            self.get_bits_unsigned(self.registers[self.rs2], 0, 7))

    def sw(self):
        address = self.registers[self.rs1] + self.imm
        value_32bits = self.registers[self.rs2]
        for i in range(4):
            self.memory[address +
                        i] = np.int8(self.get_bits_unsigned(value_32bits, (i*8), (i*8+7)))

    def add(self):
        self.registers[self.rd] = np.int32(
            self.registers[self.rs1] + self.registers[self.rs2])

    def addi(self):
        self.registers[self.rd] = np.int32(self.registers[self.rs1] + self.imm)

    def and_(self):
        self.registers[self.rd] = np.int32(
            self.registers[self.rs1] & self.registers[self.rs2])

    def andi(self):
        self.registers[self.rd] = np.int32(self.registers[self.rs1] & self.imm)

    def auipc(self):  # lembrar que o decode já salvou o imediato da forma correta (deslocado 12 bits para a esquerda)
        actual_pc = self.normalize_pc()
        self.registers[self.rd] = np.int32(actual_pc + self.imm)

    def beq(self):
        actual_pc = self.normalize_pc()
        if self.registers[self.rs1] == self.registers[self.rs2]:
            self.pc = np.uint32(actual_pc + self.imm)

    def bne(self):
        actual_pc = self.normalize_pc()
        if self.registers[self.rs1] != self.registers[self.rs2]:
            self.pc = np.uint32(actual_pc + self.imm)

    def bge(self):
        actual_pc = self.normalize_pc()
        if self.registers[self.rs1] >= self.registers[self.rs2]:
            self.pc = np.uint32(actual_pc + self.imm)

    def bgeu(self):
        actual_pc = self.normalize_pc()
        if np.int32(self.registers[self.rs1]).astype(np.uint32) >= np.int32(self.registers[self.rs2]).astype(np.uint32):
            self.pc = np.uint32(actual_pc + self.imm)

    def blt(self):
        actual_pc = self.normalize_pc()
        if self.registers[self.rs1] < self.registers[self.rs2]:
            self.pc = np.uint32(actual_pc + self.imm)

    def bltu(self):
        actual_pc = self.normalize_pc()
        if np.int32(self.registers[self.rs1]).astype(np.uint32) < np.int32(self.registers[self.rs2]).astype(np.uint32):
            self.pc = np.uint32(actual_pc + self.imm)

    def jal(self):
        actual_pc = self.normalize_pc()
        self.registers[self.rd] = np.int32(actual_pc + 4)
        self.pc = np.uint32(actual_pc + self.imm)

    def jalr(self):
        actual_pc = self.normalize_pc()
        self.registers[self.rd] = np.int32(actual_pc + 4)
        self.pc = np.uint32(self.registers[self.rs1] + self.imm)

    def or_(self):
        self.registers[self.rd] = np.int32(
            self.registers[self.rs1] | self.registers[self.rs2])

    def slt(self):
        if self.registers[self.rs1] < self.registers[self.rs2]:
            self.registers[self.rd] = np.int32(1)
        else:
            self.registers[self.rd] = np.int32(0)

    def sltu(self):
        if np.int32(self.registers[self.rs1]).astype(np.uint32) < np.int32(self.registers[self.rs2]).astype(np.uint32):
            self.registers[self.rd] = np.int32(1)
        else:
            self.registers[self.rd] = np.int32(0)

    def ori(self):
        self.registers[self.rd] = np.int32(self.registers[self.rs1] | self.imm)

    def slli(self):
        self.registers[self.rd] = np.int32(
            self.registers[self.rs1] << self.shamt)

    def srai(self):
        self.registers[self.rd] = np.int32(
            self.registers[self.rs1] >> self.shamt)

    def srli(self):
        self.registers[self.rd] = np.int32(
            self.registers[self.rs1].astype(np.uint32) >> self.shamt)

    def sub(self):
        self.registers[self.rd] = np.int32(
            self.registers[self.rs1] - self.registers[self.rs2])

    def xor(self):
        self.registers[self.rd] = np.int32(
            self.registers[self.rs1] ^ self.registers[self.rs2])

    def ecall(self):
        if self.registers[17] == 1:
            print(self.registers[10], end='')

        elif self.registers[17] == 4:
            print(self.decode_memory_to_string(
                self.memory, self.registers[10]), end='')

        elif self.registers[17] == 10:
            self.flag_exit = True

    def decode_memory_to_string(self, memory, start_address):
        string = ''
        counter = 0
        for byte in memory[start_address:]:
            counter += 1
            if byte == 0 or counter > 200:  # condição de parada para evitar looping infinito
                break
            string += chr(byte)
        return string


simu = simulador('code_testador.bin', 'data_testador.bin')
