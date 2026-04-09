# Chasing Light Effect chu?n theo Feature gi?i mã ???c
.text
.globl main

main:
    # 1. Tr? vào ??a ch? Base LED
    lui   x10, 0x10000       # x10 = 0x10000000
    
    # 2. ENABLE LED MODULE (B?t bu?c theo code c?)
    addi  x5, x0, 1          # x5 = 1
    sw    x5, 0(x10)         # Ghi 1 vào Control Reg (Offset 0)

    # 3. Kh?i t?o bit ??u tiên cho hi?u ?ng ?u?i
    addi  x11, x0, 1         # x11 = 1 (LED 0 sáng)
    
LOOP_START:
    # 4. Ghi giá tr? vào thanh ghi DATA
    sw    x11, 4(x10)        # Ghi vào Data Reg (Offset 4)
    
    # 5. Delay (Ch?nh s? này l?n h?n n?u mu?n nhìn ch?m l?i)
    addi  x12, x0, 50        
WAIT:
    addi  x12, x12, -1       
    bne   x12, x0, WAIT 
    
    # 6. D?ch bit sang trái
    slli  x11, x11, 1        

    # 7. N?u d?ch h?t 32 bit (x11 tr? v? 0), thì reset v? 1
    bne   x11, x0, LOOP_START 
    addi  x11, x0, 1         
    jal   x0, LOOP_START