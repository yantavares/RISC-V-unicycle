.data
	# array
	byte:	.byte	7 8 9 10 11
	seila:  .byte   4
	word:	.word   0x3334

.text
	la s0, byte  # Load address -> Stores address of var 'byte'
	lb t0, 0(s0) # Load byte -> load value contained inside s0
	
	la s1, word
	lb t1, 0(s1) # should generate value t1	| 0x00000034
	lw t2, 0(s1) # should generate value t2	| 0x00003334


