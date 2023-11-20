.text
  li, a0, 4
  jal soma_recursiva
  
  li a7, 1
  ecall
  
  li a7, 10
  ecall

  soma_recursiva:
    addi sp, sp, -8 # prepara a pilha para receber 2 itens
    sw ra, 4(sp) # empilha $ra (End. Retorno)
    sw a0, 0(sp) # empilha $a0 (n)
    slti t0, a0, 1 # testa se n < 1
    beq t0, zero, L1 # se n>=1, vá para L1
    add a0, zero, zero # valor de retorno é 0
    addi sp, sp, 8 # remove 2 itens da pilha
    ret # retorne para depois de jal
  L1:
    addi a0, a0, -1 # argumento passa a ser (n-1)
    call soma_recursiva # calcula a soma para (n-1)
    lw t0, 0(sp) # restaura o valor de n
    lw ra, 4(sp) # restaura o endereço de retorno
    addi sp, sp, 8 # retira 2 itens da pilha.
    add a0, a0, t0 # retorne n + soma_recursiva(n-1)
    ret # retorne para a chamadora
