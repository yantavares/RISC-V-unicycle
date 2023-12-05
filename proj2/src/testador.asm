.data
word:	.word 0xFAFEF1F0

TAB: 	.asciz "\t"
NL: 	.asciz	"\n"
Label:	.asciz "Teste"
l_ok:	.asciz	" OK"
l_fail:	.asciz	" FAIL"

.text

teste1:
	li t1, -2	# Testa ADD
	li t2, 3
	add t3, t1, t2
	li a1, 1
	li t6, 1	
	beq t3, t6, t1_ok
	jal FAIL
	j teste2
t1_ok:
	jal OK

teste2:
	li t1, -2048	# Testa ADDi
	addi t1, t1, -2048
	li a1, 2
	li  t6, -4096
	beq  t1, t6, t2_ok
	jal FAIL 
	j teste3
t2_ok:
	jal OK 
	
teste3:			# Testa AND
	li t1, 0x37F
	li t2, 0x6E3
	and t3, t1, t2
	li a1, 3
	li t6, 0x263
	beq  t3, t6, t3_ok
	jal FAIL 
	j teste4
t3_ok:
	jal OK 
	
teste4:			# Testa ANDi
	li t1, 0x37F
	andi t1, t1, 0x584
	li a1, 4
	li  t6, 0x104
	beq  t1, t6, t4_ok
	jal FAIL 
	j teste5
t4_ok:
	jal OK 
	
teste5:			# Testa AUIPC
	auipc t1, 0
	auipc t2, 0
	sub t1, t2, t1
	li a1, 5
	li  t6, 0x4
	beq  t1, t6, t5_ok
	jal FAIL 
	j teste6
t5_ok:
	jal OK 
	
teste6:			# Testa BEQ e BNE
	li  t0, -100
	li  t1, -200
beqt:	
	beq t0, t1, bnet
	addi t1, t1, 100
	j beqt
bnet:
	li a1, 6
	bne t0, t1, t6_ok
	addi t1, t1, 100
	j bnet
	jal FAIL 
	j teste7
t6_ok:
	jal OK 
	
teste7:			# Testa BGE e BGEU
	li  t0, -100
	li  t1, -200
	li  a1, 7
bget:	
	bge t1, t0, bgeut
	addi t1, t1, 300
	j bget
bgeut:
	bgeu t1, t0, t7_nok
	bgeu t0, t1, t7_ok
	j bgeut
t7_nok:
	jal FAIL 
	j teste8
t7_ok:
	jal OK 		
	
teste8:			# Testa BGE e BGEU
	li  t0, -100
	li  t1, -200
	li  a1, 8
blt:	
	blt t0, t1, bltu
	addi t1, t1, 300
	j blt
bltu:
	bltu t0, t1, t8_nok
	bltu t1, t0, t8_ok
	j bgeut
t8_nok:
	jal FAIL 
	j teste9
t8_ok:
	jal OK 	
	
teste9:	
	la t0, word	# Le palavra da memoria com Lw e compara com constante
	lw t1, 0(t0)
	li t2, 0xFAFEF1F0
	li a1, 9
	beq t1, t2, t9_ok
	jal FAIL
	j teste10
t9_ok:	
	jal OK	

teste10:	
	la t0, word	# Le byte da memoria com lb e compara com constante
	lb t1, 0(t0)    # Verifica extensao de sinal
	li t2, 0xFFFFFFF0
	li a1, 10
	beq t1, t2, t10_ok
	jal FAIL
	j teste11
t10_ok:	
	jal OK	
	
teste11:	
	la t0, word	# Le byte da memoria com lbu e compara com constante
	lbu t1, 0(t0) # Verifica leitura sem sinal
	li t2, 0x0F0
	li a1, 11
	beq t1, t2, t11_ok
	jal FAIL
	j teste12
t11_ok:	
	jal OK	


teste12:	
	lui t1, 9	# testando LUI e SLLi
	li t2, 9
	slli t2, t2, 12
	li a1, 12
	beq t1, t2, t12_ok
	jal FAIL
	j teste13
t12_ok:	
	jal OK
		

teste13:	
	la t0, word	# Altera valor na memoria, testa SW
	lw t1, 0(t0)
	li t2, 0xFAFEF1FA
	sw t2, 0(t0) 
	lw t3, 0(t0)
	li a1, 13
	bne t1, t3, t13_ok
	jal FAIL
	j teste14
t13_ok:	
	jal OK		
	
teste14:	
	la t0, word	# Altera 1o byte na palavra, testa SB
	li t1, 0xFAFEFFF0
	sw t1, 0(t0)
	li t1, 0xFAFEF1F0
	li t2, 0xF1
	sb t2, 1(t0)
	lw t3, 0(t0)
	li a1, 14
	beq t1, t3, t14_ok
	jal FAIL 
	j teste15
t14_ok:	jal  OK 

teste15:		# Testa OR
	li t1, 0xf0f0f0f0
	li t2, 0x0f0f0f0f
	or t3, t1, t2
	li a1, 15
	li t6, -1
	beq  t3, t6, t15_ok
	jal FAIL
	j teste16
t15_ok:
	jal OK 
	

teste16:		# Teste ORi
	li t1, 0xf0f0f0f0
	ori t1, t1, 0x700
	li a1, 16
	li  t6, 0xf0f0f7f0
	beq  t1, t6, t16_ok
	jal FAIL 
	j teste17
t16_ok:
	jal OK 

teste17:		# Testa XOR
	li t1, 0xf0f0f0f0
	li t2, 0xffff0000
	xor t3, t1, t2
	li a1, 17
	li t6, 0x0f0ff0f0
	beq  t3, t6, t17_ok
	jal FAIL 
	j teste18
t17_ok:
	jal OK 

teste18:		# Testa SUB
	li t1, -2
	li t2, 3
	sub t3, t1, t2
	li a1, 18
	li  t6, -5
	beq  t3, t6, t18_ok
	jal FAIL 
	j teste19
t18_ok:
	jal OK 

teste19:
	li t1, 0	# Testa JAL
	li a1, 19
	jal s0, t19
	bne t1, zero, t19_ok 
	jal FAIL 
	j teste20
t19:	li t1, 1
	jr s0	
t19_ok:	jal OK 			

teste20:		# Testa SLT
	li t1, -1
	li t2, 8
	slt t3,t1,t2
	slt t4,t2,t1
	slli t3, t3, 1
	li t6, 2
	li a1, 20
	beq  t3, t6, t20_ok
	jal FAIL
	j teste21
t20_ok:
	jal OK	

teste21:		# Testa SRA
	li t1, -10
	srai t2, t1, 1
	li a1, 21
	li t6, -5
	beq  t2, t6, t21_ok
	jal FAIL 
	j teste22
t21_ok:
	jal OK		
	
teste22:		# Testa SRL
	li t1, -1
	srli t2, t1, 24
	li a1, 22
	li t6, 255
	beq  t2, t6, t22_ok
	jal FAIL 
	j fim
t22_ok:
	jal OK
	
fim:
	li a7, 10
	ecall		
	
OK:	# a1 eh o numero do teste
	la a0, Label
	li a7, 4
	ecall
	add a0, zero, a1
	li a7, 1
	ecall
	la a0, l_ok
	li a7, 4
	ecall
	la a0, NL
	ecall
	jr ra

FAIL:   # a1 eh o numero do teste
	la a0, Label
	li a7, 4
	ecall

	add a0, zero, a1
	li a7, 1
	ecall

	la a0, l_fail
	li a7, 4
	ecall
	la a0, NL
	ecall
	jr ra