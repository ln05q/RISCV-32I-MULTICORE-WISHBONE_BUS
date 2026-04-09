.text
.globl main

main:
    # --- PH?N KH?I T?O H? TH?NG ---
    lui   x5, 0x10000       # Gán x5 = 0x10000000 (??a ch? Base c?a LED Matrix)
    addi  x8, x0, 1         # Gán x8 = 1 (Giá tr? dùng ?? Enable module)
    sw    x8, 0(x5)         # Ghi 1 vào thanh ghi CONTROL (Offset 0) ?? m? khóa LED

    # --- CHU?N B? D? LI?U HI?N TH? ---
    addi  x12, x0, -1       # Gán x12 = 0xFFFFFFFF (T?t c? 32 LED ??u sáng)
    addi  x14, x0, 0        # Gán x14 = 0x00000000 (T?t c? 32 LED ??u t?t)

LOOP:
    # --- GIAI ?O?N 1: B?T ?ÈN ---
    sw    x12, 4(x5)        # Ghi 0xFFFFFFFF vào thanh ghi DATA (Offset 4)
    
    # Vòng l?p tr? 1 (Delay)
    addi  x10, x0, 5        # Kh?i t?o bi?n ??m x10 = 5
DELAY1:
    addi  x10, x10, -1      # Gi?m x10 ?i 1 ??n v?
    bne   x10, x0, DELAY1   # N?u x10 ch?a b?ng 0, quay l?i DELAY1

    # --- GIAI ?O?N 2: T?T ?ÈN ---
    sw    x14, 4(x5)        # Ghi 0x00000000 vào thanh ghi DATA (Offset 4)

    # Vòng l?p tr? 2 (Delay)
    addi  x10, x0, 5        # Reset bi?n ??m x10 = 5
DELAY2:
    addi  x10, x10, -1      # Gi?m x10 ?i 1 ??n v?
    bne   x10, x0, DELAY2   # N?u x10 ch?a b?ng 0, quay l?i DELAY2

    # --- VÒNG L?P VÔ H?N ---
    jal   x0, LOOP          # Nh?y v? nhãn LOOP ?? ti?p t?c ch?p t?t
