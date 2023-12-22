# Generation of Constants: LUI, AUIPC
LUI x1, 0x12345       # Load Upper Immediate
AUIPC x2, 0x6789      # Add Upper Immediate to PC

# Arithmetic: ADD, SUB
ADD x3, x1, x2        # Add x1 and x2
SUB x4, x2, x1        # Subtract x1 from x2

# Arithmetic with Immediate: ADDI
ADDI x5, x3, 10       # Add immediate 10 to x3

# Logical: AND, SLT, OR, XOR
AND x6, x3, x4        # AND x3 and x4
SLT x7, x4, x5        # Set x7 to 1 if x4 < x5
OR x8, x5, x6         # OR x5 and x6
XOR x9, x6, x7        # XOR x6 and x7

# Logical with Immediate: ANDI, ORI, XORI
ANDI x10, x7, 15      # AND immediate 15 with x7
ORI x11, x8, 15       # OR immediate 15 with x8
XORI x12, x9, 15      # XOR immediate 15 with x9

# Shifts: SLL, SRL, SRA
SLL x13, x10, x1      # Shift Left Logical x10 by lower 5 bits of x1
SRL x14, x11, x2      # Shift Right Logical x11 by lower 5 bits of x2
SRA x15, x12, x3      # Shift Right Arithmetic x12 by lower 5 bits of x3

# Shifts with Immediate: SLLI, SRLI, SRAI
SLLI x16, x13, 2      # Shift Left Logical x13 by 2
SRLI x17, x14, 2      # Shift Right Logical x14 by 2
SRAI x18, x15, 2      # Shift Right Arithmetic x15 by 2

# Comparison: SLT, SLTU
SLT x19, x16, x17     # Set x19 to 1 if x16 < x17
SLTU x20, x17, x18    # Set x20 to 1 if x17 < x18 (unsigned)

# Comparison with Immediate: SLTI, SLTIU
SLTI x21, x19, 5      # Set x21 to 1 if x19 < 5
SLTIU x22, x20, 5     # Set x22 to 1 if x20 < 5 (unsigned)

# Subroutines: JAL, JALR
JAL x23, skip         # Jump And Link to label 'skip'
JALR x24, x23, 4      # Jump And Link Register with offset 4

# Branches: BEQ, BNE, BLT, BGE, BLTU, BGEU
BEQ x21, x22, label1  # Branch if Equal
BNE x22, x21, label2  # Branch if Not Equal
BLT x21, x22, label3  # Branch if Less Than
BGE x22, x21, label4  # Branch if Greater Than or Equal
BLTU x21, x22, label5 # Branch if Less Than Unsigned
BGEU x22, x21, label6 # Branch if Greater Than or Equal Unsigned

# Memory: LW, SW
LW x25, 0(x1)         # Load Word
SW x25, 4(x2)         # Store Word

label1:
label2:
label3:
label4:
label5:
label6:
skip:
NOP                   # No operation (placeholder for labels)
