.text

li a0, 3

jal t0, soma

li a7, 1
ecall

li a7, 10
ecall

soma:
  addi a0, a0, 3
  jalr t0         # Return using the address in t0
