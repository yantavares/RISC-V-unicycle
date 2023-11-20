.text
  li a0, 4
  li t4, 0
  jal soma_recursiva
  
  mv a0, t4
  
  li a7, 1
  ecall
  
  li a7, 10
  ecall

  soma_recursiva:
    addi sp, sp, -4 # prepara a pilha para receber 2 itens
    sw ra, 4(sp) # empilha $ra (End. Retorno)

    add t4, t4, a0

    slti t0, a0, 1 # testa se n < 1
    beq t0, zero, L1 # se n>=1, vá para L1
    addi sp, sp, 4 # remove 2 itens da pilha
    
    ret # retorne para depois de jal
  L1:
    addi a0, a0, -1 # argumento passa a ser (n-1)
    call soma_recursiva # calcula a soma para (n-1)
    lw ra, 4(sp) # restaura o endereço de retorno
    addi sp, sp, 4 # retira 2 itens da pilha.
    ret # retorne para a chamadora
