# Ver passo a passo no montador e ler slides !
.text
	li s0, 7
	li s1, 123
	
	mv a0, s0
	mv a1, s1
	
	jal soma
	
	mv s2, a0
	
	li a7, 10
	ecall

soma:
	add a0, a0, a1
	