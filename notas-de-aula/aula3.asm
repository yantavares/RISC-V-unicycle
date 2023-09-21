.data
kte:	.word 0xFACACAFE
msk:	.word 0x0000FFFF # Máscara

.text
	la t0, kte # t0 armazena endereço de kte
	lw t0,0(t0) # Armazena conteúdo de kte em t0
	la a0, msk
	lw a0, 0(a0)
	
	and s0, a0, t0 # Faz operação a0 & t0 -> Aplica máscara e armazena 0x0000CAFE em s0

	
	# Obs.: Para armazenar 0x0000FACA, podemos deslocar 16bits com Shift Right
	srli s1, t0, 16 # Shift Right Logico Imediato
	
	# Usando a função definida abaixo:
	mv a0, t0
	jal lsw16
	
	# Printa a0 (inteiro) -> 0x0000CAFE
	li a7, 34
	ecall
	
	
	# ----------------------
	
	# Outra função
	mv a0, t0
	jal rsw16
	
	# Printa a0 (inteiro) -> 0x0000FACA
	li a7, 34
	ecall
	
	# Para de rodar
	li a7, 10
	ecall

lsw16:  # Funcao -> a's e t's (Não se deve mexer nos s (convenção))
	la a1, msk
	lw a1, 0(a1)
	and a0, a0, a1
	ret # Retorna a0

rsw16:
	srli a0, a0, 16
	ret 
	
	
	