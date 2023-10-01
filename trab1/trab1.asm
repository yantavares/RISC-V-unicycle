.data
blk_in:     .half 0, 1, 2, 3
blk_out:    .half 0, 0, 0, 0
keys:       .half 1, 2, 3, 4, 5, 6
msg_part:   .asciz "Saida["
equals:     .asciz "] = "
newline:    .asciz "\n"

.text
mul:
    # Input: a0 = x, a1 = y
    # Output: a0 = result
    mul a2, a0, a1     # a2 = x * y
    beqz a2, mul_zero
    srli a3, a2, 16    # a3 = p >> 16
    sub a0, a2, a3     # a0 = y - x
    blt a2, a0, mul_add
    ret

mul_zero:
    li a3, 65537
    sub a0, a3, a0
    sub a0, a0, a1
    andi a0, a0, 0xffff   # Ensure result is 16-bits
    ret

mul_add:
    addi a0, a0, 65537
    ret

idea_round:
    # Save base pointers
    mv t4, a0   # t4 = blk_in_ptr
    mv t5, a1   # t5 = blk_out_ptr
    mv t6, a2   # t6 = key_ptr

    # Load words from t4 into t0-t3
    lh t0, 0(t4)
    lh t1, 2(t4)
    lh t2, 4(t4)
    lh t3, 6(t4)

    # Load the keys into s0-s5
    lh s0, 0(t6)
    lh s1, 2(t6)
    lh s2, 4(t6)
    lh s3, 6(t6)
    lh s4, 8(t6)
    lh s5, 10(t6)

    # word1 = mul(word1, *key_ptr++);
    mv a0, t0
    mv a1, s0
    call mul
    mv t0, a0

    # t2 = word1 ^ word3
    xor t7, t0, t2

    # t2 = mul(t2, *key_ptr++);
    mv a0, t7
    mv a1, s4
    call mul
    mv t7, a0  # result is stored back in t7

    # t1 = LSW16(t2 + (word2 ^ word4))
    xor t8, t1, t3   # t8 = word2 ^ word4
    add t8, t7, t8   # t8 = t2 + (word2 ^ word4)
    andi t8, t8, 0xffff  # t8 now holds LSW16(t2 + (word2 ^ word4))

    # t1 = mul(t1, *key_ptr++)
    mv a0, t8
    mv a1, s5
    call mul
    mv t8, a0  # result is stored back in t8

    # t2 = LSW16(t1 + t2)
    add t7, t8, t7
    andi t7, t7, 0xffff  # t7 now holds LSW16(t1 + t2)

    # word1 ^= t1
    xor t0, t0, t8

    # word4 ^= t2
    xor t3, t3, t7

    # t2 ^= word2
    xor t7, t7, t1

    # word2 = word3 ^ t1
    xor t1, t2, t8

    # word3 = t2
    mv t2, t7

    # Store results to t5
    sh t0, 0(t5)
    sh t1, 2(t5)
    sh t2, 4(t5)
    sh t3, 6(t5)

    ret


main:
    # Set up addresses for blk_in, blk_out, and keys
    la a0, blk_in
    la a1, blk_out
    la a2, keys

    # Call the idea_round function
    call idea_round

    # Setup for printing the results
    li t0, 0      # Loop index
    la a1, blk_out  # Reset a1 to the start of blk_out

print_loop:
    # Check if we've printed all four values
    bge t0, 4, end

    # Print "Saida["
    la a0, msg_part
    li a7, 4      # Print string
    ecall

    # Print index
    mv a0, t0
    li a7, 34     # Print integer
    ecall

    # Print "] = "
    la a0, equals
    li a7, 4      # Print string
    ecall

    # Load and print the value from blk_out
    lh a0, 0(a1)  # Load halfword to a0
    li a7, 34     # Print integer
    ecall

    # Print newline
    la a0, newline
    li a7, 4      # Print string
    ecall

    # Update index and pointer for the next iteration
    addi t0, t0, 1
    addi a1, a1, 2
    j print_loop

end:
    # Exit the program
    li a7, 10     # Exit syscall
    ecall
