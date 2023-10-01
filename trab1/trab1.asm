.data
blk_in:  .half 0, 1, 2, 3
blk_out: .half 0, 0, 0, 0
keys:    .half 1, 2, 3, 4, 5, 6
#Test

.text
mul_no_zero:
    # Input: a0 = x, a1 = y
    # Output: a0 = result
    mul a2, a0, a1     # a2 = x * y
    beqz a2, mul_zero

    # a3 = p >> 16
    srli a3, a2, 16    
    # a0 = y - x
    sub a0, a2, a3     
    blt a2, a0, mul_add
    ret

mul_zero:
    # Load 65537 into a3
    li a3, 1
    slli a3, a3, 16
    addi a3, a3, 1
    
    sub a0, a3, a0
    sub a0, a0, a1

    # Load 0xffff into a3
    li a3, -1          # a3 will have all bits set (i.e., 0xffffffff in 32-bit, which is equivalent to 0xffff in 16-bit)
    and a0, a0, a3     # Ensure result is 16-bits
    ret

mul_add:
    # Load 65537 into a3
    li a3, 1
    slli a3, a3, 16
    addi a3, a3, 1

    add a0, a0, a3
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
    call mul_no_zero
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
    call mul_no_zero
    mv t3, a0
    
    # t2 = word1 ^ word3
    xor t4, t0, t2

    # t2 = mul(t2, *key_ptr++)
    mv a0, t4
    lh a1, 12(a2)    # Load next key
    call mul_no_zero
    mv t4, a0       # Store the result in t4

    # t1 = LSW16(t2 + (word2 ^ word4))
    xor t5, t1, t3
    add t5, t5, t4
    and t5, t5, t6

    # t1 = mul(t1, *key_ptr++)
    mv a0, t5
    lh a1, 14(a2)    # Load next key
    call mul_no_zero
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

    # Store the results to blk_out_ptr (using a1 as the pointer might cause confusion. Instead, use a1 as intended)
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
    li t1, 4     # Load immediate value 4 into t1

print_loop:
    # Check if we've printed all four values
    bge t0, t1, end

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
