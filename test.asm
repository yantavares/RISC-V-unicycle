.data
    newline: .word 10

.text
    li a7, 5
    ecall
    
    mv t0, a0
    
    li a7, 5
    ecall
    
    mv t1, a0
    
    add a0, t0, t1
    
    li a7, 1
    ecall
    
    li a7, 10
    ecall 