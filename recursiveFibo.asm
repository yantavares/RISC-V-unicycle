.text
  li, a0, 4 # Deve imprimir 3
  jal fibo
  
  li a7, 1
  ecall
  
  li a7, 10
  ecall

  fibo:
    addi sp, sp, -8 # prepara a pilha para receber 2 itens
    sw ra, 4(sp) # empilha $ra (End. Retorno)

  helper:
    call fibo
