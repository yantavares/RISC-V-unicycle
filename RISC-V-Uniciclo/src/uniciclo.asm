.data 
vetx:	.word 15 63

# os valores ao lado sao tomados da saida dos modulos:
# PC - saida do PC
# MI - saida do módulo de memoria (e nao de IF/ID)
# ULA - saida direta da ULA
# MD - saida direta da memoria de dados

.text                        	# PC        MI         ULA       MD

	ori  t0, zero, 0xFF     # 00000000  0ff06293   000000ff  00000000
	andi t0, t0, 0xF0       # 00000004  0f02f293   000000f0  00000000
	lui  s0, 2				# 00000008  00002437   00002000  00000000
	lw   s1, 0(s0)      	# 0000000c  00042483   00002000  0000000f
	lw   s2, 4(s0)      	# 00000010  00442903   00002004  0000003f
	add  s3, s1, s2     	# 00000014  012489b3   0000004e  00000000
	sw   s3, 8(s0)      	# 00000018  01342423   00002008  0000004e
	lw   a0, 8(s0)      	# 0000001c  00842503   00002008  0000004e
	addi s4, zero, 0x7F0    # 00000020  7f000a13   000007f0  00000000
	addi s5, zero, 0x0FF    # 00000024  0ff00a93   000000ff  00000000
	and  s6, s5, s4         # 00000028  014afb33   000000f0  00000000
	or   s7, s5, s4         # 0000002c  014aebb3   000007ff  00000000
	xor  s8, s5, s4         # 00000030  014acc33   0000070f  00000000
	slli  t1, s5, 4         # 00000034  004a9313   00000ff0  00000000
	lui  t2, 0xFF000        # 00000038  ff0003b7   ff000000  00000000
	srli  t3, t2, 4         # 0000003c  0043de13   0ff00000  00000000 
	srai  t4, t2, 4         # 00000040  4043de93   fff00000  00000000
	slt  s0, t0, t1         # 00000044  0062a433   00000001  00000000
	slt  s1, t1, t0         # 00000048  005324b3   00000000  00000000
	sltu s3, zero, t0       # 0000004c  005039b3   00000001  00000000
	sltu s4, t0, zero       # 00000050  0002ba33   00000000  00000000
	
	# 54 5c 60 58 64 68 6c 68 6c 70 74 70 74 78 7c 80 84 7c 80 88 8c 90 88 94 98
	
	jal  ra, testasub       # 00000054  008000ef   00000000  00000000 => 5c

	jal  x0, next           # 00000058  00c0006f   00000000  00000000 => 64
testasub:
	sub t3, t0, t1          # 0000005c  40628e33   fffff100  00000000 
	jalr x0, ra, 0          # 00000060  00008067   00000058  00000000 => 58
next:
	addi t0, zero, -2       # 00000064  ffe00293   fffffffe  00000000
beqsim: 
	addi t0, t0, 2          # 00000068  00228293   0000000*  00000000 * t0 = 0, 2
	beq  t0, zero, beqsim   # 0000006c  fe028ee3   00000000  00000000 => 68, 70
bnesim:
	addi t0, t0, -1         # 00000070  fff28293   0000000*  00000000 * t0 = 1, 0
	bne  t0, zero, bnesim   # 00000074  fe029ee3   00000000  00000000 => 70, 78
		
	addi t0, zero, 1		# 00000078  00100293   00000001  xxxxxxxx
bltadd:	
	addi t0, t0, -1         # 0000007c  fff28293   00000000  xxxxxxxx
	blt  t0, zero, blton	# 00000080  0002c463   xxxxxxxx  xxxxxxxx => 84, 88
	j    bltadd				# 00000084  ff9ff06f   xxxxxxxx  xxxxxxxx => 7c
blton:
	bge  t0, zero, end		# 00000088  0002d663   xxxxxxxx  xxxxxxxx => 8c, 94
	addi t0, t0, 1			# 0000008c  00128293   00000000  xxxxxxxx 
	j blton					# 00000090  ff9ff06f   xxxxxxxx  xxxxxxxx => 88
end:
	auipc t1, 10			# 00000094  0000a317   00000000  xxxxxxxx
	addi  t0, x0, 10		# 00000098  00a00293   00000000  xxxxxxxx
	addi  t1, x0, 20		# 0000009c  01400313   00000000  xxxxxxxx
	add   t2, t0, t1     	# 000000a0  006283b3   00000000  xxxxxxxx


	
	
	
	
	
