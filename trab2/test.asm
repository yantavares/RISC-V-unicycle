.data
int1: .word 3
int2: .word 5

.text

lw a1, int1
lw a2, int2

add a0, a1, a2

li a7, 1
ecall

li a7, 10
ecall