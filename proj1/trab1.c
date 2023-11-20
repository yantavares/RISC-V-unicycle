#include <stdlib.h>
#include <stdio.h>

typedef unsigned short uint16;        /* 16-bit word */
typedef unsigned int uint32;          /* 32-bit word */
#define LSW16(y) ((y)&0xffff)         /* low significant 16-bit */
#define MSW16(y) ((y >> 16) & 0xffff) /* most significant 16-bit */
uint16 mul(uint16 x, uint16 y)
{
    uint32 p = x * y;
    if (p == 0)
        x = 65537 - x - y;
    else
    {
        x = p >> 16;
        y = p;
        x = y - x;
        if (y < x)
            x += 65537;
    }
    return x;
}
void idea_round(uint16 *blk_in_ptr, uint16 *blk_out_ptr, uint16 *key_ptr)
{
    uint16 word1, word2, word3, word4;
    uint16 t1, t2;

    word1 = *blk_in_ptr++;
    word2 = *blk_in_ptr++;
    word3 = *blk_in_ptr++;
    word4 = *blk_in_ptr;

    word1 = mul(word1, *key_ptr++);
    word2 = LSW16(word2 + *key_ptr++);
    word3 = LSW16(word3 + *key_ptr++);
    word4 = mul(word4, *key_ptr++);

    t2 = word1 ^ word3;
    t2 = mul(t2, *key_ptr++);
    t1 = LSW16(t2 + (word2 ^ word4));
    t1 = mul(t1, *key_ptr++);
    t2 = LSW16(t1 + t2);

    word1 ^= t1;
    word4 ^= t2;

    t2 ^= word2;
    word2 = word3 ^ t1;
    word3 = t2;

    *blk_out_ptr++ = word1;
    *blk_out_ptr++ = word2;
    *blk_out_ptr++ = word3;
    *blk_out_ptr++ = word4;
}
int main(int argc, char *const argv[])
{

    uint16 blk_in[] = {0, 1, 2, 3};
    uint16 blk_out[] = {0, 0, 0, 0};
    uint16 keys[] = {1, 2, 3, 4, 5, 6};
    idea_round(blk_in, blk_out, keys);

    for (int i = 0; i < 4; i++)
    {
        printf("Saida[%d] = %d\n", i, blk_out[i]);
    }
    return 0;
}