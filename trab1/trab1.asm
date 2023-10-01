.data
blk_in:  .half 0, 1, 2, 3
blk_out: .half 0, 0, 0, 0
keys:    .half 1, 2, 3, 4, 5, 6

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
    call mul
    mv t0, a0

    # word2 = LSW16(word2 + *key_ptr++);
    add t1, t1, s1
    andi t1, t1, 0xffff

    # word3 = LSW16(word3 + *key_ptr++);
    add t2, t2, s2
    andi t2, t2, 0xffff

    # word4 = mul(word4, *key_ptr++);
    mv a0, t3
    mv a1, s3
    call mul
    mv t3, a0
    
    # t2 = word1 ^ word3
    xor t4, t0, t2

    # t2 = mul(t2, *key_ptr++)
    mv a0, t4
    lh a1, 12(a2)    # Load next key
    call mul
    mv t4, a0       # Store the result in t4

    # t1 = LSW16(t2 + (word2 ^ word4))
    xor t5, t1, t3
    add t5, t5, t4
    andi t5, t5, 0xffff

    # t1 = mul(t1, *key_ptr++)
    mv a0, t5
    lh a1, 14(a2)    # Load next key
    call mul
    mv t5, a0       # Store the result in t5

    # t2 = LSW16(t1 + t2)
    add t4, t4, t5
    andi t4, t4, 0xffff

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
    sh t0, 0(a1)
    sh t1, 2(a1)
    sh t2, 4(a1)
    sh t3, 6(a1)

    ret



main:
    # Set up addresses for blk_in, blk_out, and keys
    la a0, blk_in
    la a1, blk_out
    la a2, keys

    # Call idea_round
    call idea_round

    # Setup for printing the results
    li t0, 0     # loop index
    la a1, blk_out

print_loop:
    # Check if we've printed all four values
    bge t0, 4, end

    # Print blk_out[t0]
    lh a0, 0(a1)  # load halfword to a0
    li a7, 34     # print integer
    ecall

    # Update index and pointer for the next iteration
    addi t0, t0, 1
    addi a1, a1, 2
    j print_loop

end:
    # Exit the program
    li a7, 10     # exit syscall
    ecall