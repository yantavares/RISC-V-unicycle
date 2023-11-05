.text
  li, a0, 5
  jal soma_recursiva
  
  li a7, 1
  ecall
  
  li a7, 10
  ecall

 soma_recursiva:
    beqz a0, return   
 
    addi sp, sp, -8
    sw a0, 0(sp)
    sw ra, 4(sp)
    
    addi a0, a0, -1
    jal soma_recursiva
    
    lw t0, 0(sp)
    lw ra, 4(sp)
    
    add a0, a0, t0
    
    addi sp, sp, 8
    
    ret
    
return:
    ret
