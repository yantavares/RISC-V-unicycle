# Guardar palavras
.data
x:	.word 33
y:	.word 99

# Comandos
.text 
	# x0 ou zero
	# Transferir valor de x2 para x4, ja que x0 = 0
	add x2, x0, x4
	
	# t0, t1... -> Registradores temporários
	add t1, t2, t3
	
	#a0, a1... -> Passar parâmetros
	
	#r -> Retorno
	
	# Pseudo intrução do montador para acessar variável
	la t0 x
	
	# Intruções para acessar memória começadas com L
	# Para armazenar, S
	
	lw x2, 0(y)
	
# Olhar os registradores à direita para ver funcionamento :)
	
	
	
