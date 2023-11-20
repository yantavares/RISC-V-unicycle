.text
 	li, a0, 4
 	jal fibo
  
 	li a7, 1
 	ecall
  
 	li a7, 10
 	ecall

fibo:

	beqz a0, return	
	addi t0, a0, -1 	
	beqz t0, return

	addi sp, sp, -8	        
	sw a0, 0(sp)		
	sw ra, 4(sp)		
	
	addi a0, a0, -1		
	jal fibo		
	
	lw t0, 0(sp)		
	sw a0, 0(sp)		
  
	addi a0, t0, -2		
	jal fibo		
	
	lw t0, 0(sp)		
	add a0, a0, t0		
	
	lw ra, 4(sp)		
	addi sp, sp, 8	
	
return:
	ret