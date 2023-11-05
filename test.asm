.data

K12_val: .word 8      # Valor armazenado para K12
val_t1: .word 10      # Valor inicial em mem[t1]

.text
main:
    # Definindo os valores iniciais de t0 e t1
    li t0, 0x10010000
    li t1, 0x10010004

    lw a0, val_t1     # Carregar valor em mem[t1] para o registrador temporário a0 (valor 10)
    lw a1, K12_val    # Carregar valor registrado em K12 (valor 8)
    add a0, a0, a1    # Adicionar constante K12 ao valor em a0
    sw a0, 0(t0)      # Armazenar valor de a0 em mem[t0]

    li a7, 1          # Código da chamada de sistema para printar inteiro (fictício para este exemplo)
    ecall             # Chamada de sistema para imprimir valor de a0

    # Finalizar programa
    li a7, 10         # Código da chamada de sistema para terminar o programa
    ecall             # Chamada de sistema para terminar
