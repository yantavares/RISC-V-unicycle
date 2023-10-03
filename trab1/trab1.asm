.data
blk_in:  .half 0, 1, 2, 3
blk_out: .half 0, 0, 0, 0
keys:    .half 1, 2, 3, 4, 5, 6

space_char: .byte ' '

.text

main:
    # Set up addresses for blk_in, blk_out, and keys
    la a0, blk_in
    la a4, blk_out
    la a2, keys

    # Call idea_round
    jal idea_round

    # Setup for printing the results
    li t0, 0     # loop index
    la a4, blk_out
    li t1, 4     # Load immediate value 4 into t1

print_loop:
    # Check if we've printed all four values
    bge t0, t1, end

    # Print blk_out[t0]
    lh a0, 0(a4)  # load halfword to a0
    li a7, 1      # print integer
    ecall

    # Print space
    lbu a0, space_char
    li a7, 11     # system call code for print character
    ecall

    # Update index and pointer for the next iteration
    addi t0, t0, 1
    addi a4, a4, 2
    j print_loop

end:
    # Exit the program
    li a7, 10     # exit syscall
    ecall

mul_main:
    # Treat 0 as 2^16
    beqz a0, mul_a0_zero
    beqz a1, mul_a1_zero

    # Multiply a0 and a1
    mul a0, a0, a1
    
    # Check if the result is zero
    beqz a0, mul_result_zero
    
    # Return the lower 16 bits of the multiplication result
    li a3, -1          # a3 will have all bits set (i.e., 0xffffffff in 32-bit)
    slli a3, a3, 16    # Shift left to make the top 16 bits 0
    srli a3, a3, 16    # Shift right to make a 16-bit mask, now a3 = 0x0000FFFF
    and a0, a0, a3     # Ensure result is 16-bits
    ret

mul_a0_zero:
    # Replace a0 with 2^16 and multiply
    li a0, 1
    slli a0, a0, 16
    mul a0, a0, a1
    j mul_check_result

mul_a1_zero:
    # Replace a1 with 2^16 and multiply
    li a1, 1
    slli a1, a1, 16
    mul a0, a0, a1

mul_check_result:
    # Check if the result is zero (this is possible due to the modulo 2^16 + 1 arithmetic)
    beqz a0, mul_result_zero

    # Return the lower 16 bits of the multiplication result
    li a3, -1          # a3 will have all bits set (i.e., 0xffffffff in 32-bit)
    slli a3, a3, 16    # Shift left to make the top 16 bits 0
    srli a3, a3, 16    # Shift right to make a 16-bit mask, now a3 = 0x0000FFFF
    and a0, a0, a3     # Ensure result is 16-bits
    ret

mul_result_zero:
    # For the special case where the multiplication result is 0,
    # the result is replaced with (2^16 - (a0 + a1) mod 2^16).

    # Add a0 and a1
    add a0, a0, a1

    # Subtract from 2^16
    li a3, 1
    slli a3, a3, 16    # a3 = 2^16
    sub a0, a3, a0     # a0 = 2^16 - (a0 + a1)

    # Ensure result is 16-bits
    li a3, -1          # a3 will have all bits set (i.e., 0xffffffff in 32-bit)
    slli a3, a3, 16    # Shift left to make the top 16 bits 0
    srli a3, a3, 16    # Shift right to make a 16-bit mask, now a3 = 0x0000FFFF
    and a0, a0, a3     # Ensure result is 16-bits

    ret


mul_zero:
    # Load 65537 into a3
    li a3, 1
    slli a3, a3, 16
    addi a3, a3, 1
    
    # Calculate result = (65537 - a0 - a1)
    sub a0, a3, a0
    sub a0, a0, a1
    
    # Load 0xffff into a3
    li a3, -1          # a3 will have all bits set (i.e., 0xffffffff in 32-bit)
    slli a3, a3, 16    # Shift left to make the top 16 bits 0
    srli a3, a3, 16    # Shift right to make a 16-bit mask, now a3 = 0x0000FFFF
    and a0, a0, a3     # Ensure result is 16-bits
    
    ret


mul_add:
    # If a0 < 2^16+1 subtract it, otherwise add it
    li a3, 0x10001
    blt a0, a3, mul_add_sub
    sub a0, a0, a3
    ret

mul_add_sub:
    add a0, a0, a3
    ret



idea_round:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Load words from blk_in_ptr into t0-t3
    lh t0, 0(a0)
    lh t1, 2(a0)
    lh t2, 4(a0)
    lh t3, 6(a0)

    # Load the keys into s0-s5
    lh s0, 0(a2)
    lh s1, 2(a2)
    lh s2, 4(a2)
    lh s3, 6(a2)
    lh s4, 8(a2)
    lh s5, 10(a2)

    # word1 = mul(word1, *key_ptr++);
    mv a0, t0
    mv a1, s0
    jal mul_main
    mv t0, a0

    # Prepare mask register for LSW16
    li t6, 0xFFFF

    # word2 = LSW16(word2 + *key_ptr++);
    add t1, t1, s1
    and t1, t1, t6

    # word3 = LSW16(word3 + *key_ptr++);
    add t2, t2, s2
    and t2, t2, t6

    # word4 = mul(word4, *key_ptr++);
    mv a0, t3
    mv a1, s3
    jal mul_main
    mv t3, a0
    
    # t2 = word1 ^ word3
    xor t4, t0, t2

    # t2 = mul(t2, *key_ptr++)
    mv a0, t4
    mv a1, s4    # Load next key
    jal mul_main
    mv t4, a0       # Store the result in t4

    # t1 = LSW16(t2 + (word2 ^ word4))
    xor t5, t1, t3
    add t5, t5, t4
    and t5, t5, t6

    # t1 = mul(t1, *key_ptr++)
    mv a0, t5
    mv a1, s5    # Load next key
    jal mul_main
    mv t5, a0       # Store the result in t5

    # t2 = LSW16(t1 + t2)
    add t4, t4, t5
    and t4, t4, t6

    # word1 ^= t1
    xor t0, t0, t5

    # word4 ^= t2
    xor t3, t3, t4

    # t2 ^= word2
    xor t4, t4, t1

    # word2 = word3 ^ t1
    xor t1, t2, t5

    # word3 = t2
    mv t2, t4

    # Store the results to blk_out_ptr
    sh t0, 0(a4)
    sh t1, 2(a4)
    sh t2, 4(a4)
    sh t3, 6(a4)

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

