.text
.globl main

main:
    # --- KHỞI TẠO ---
    lui   x5, 0x10000       # Địa chỉ Base LED Matrix
    addi  x8, x0, 1         # x8 = 1
    sw    x8, 0(x5)         # Enable module (Offset 0)

    addi  x11, x0, 1        # x11: Giá trị LED (Bắt đầu ở bit 0)
    addi  x13, x0, 0        # x13: Hướng di chuyển (0: Trái, 1: Phải)
    
    # Định nghĩa biên
    lui   x14, 0x80000      # x14 = 0x80000000 (Bit cao nhất của 32-bit)
    addi  x15, x0, 1        # x15 = 0x00000001 (Bit thấp nhất)

LOOP:
    sw    x11, 4(x5)        # Hiển thị ra LED Matrix (Offset 4)

    # --- TẠO DELAY (Khoảng 0.05s để mượt mà hơn) ---
    li    x12, 1000000      
WAIT:
    addi  x12, x12, -1
    bne   x12, x0, WAIT

    # --- KIỂM TRA HƯỚNG VÀ DI CHUYỂN ---
    bne   x13, x0, MOVE_RIGHT

MOVE_LEFT:
    slli  x11, x11, 1       # Dịch trái
    beq   x11, x14, SET_RIGHT # Nếu chạm bit 31, đổi hướng
    jal   x0, LOOP

MOVE_RIGHT:
    srli  x11, x11, 1       # Dịch phải
    beq   x11, x15, SET_LEFT  # Nếu chạm bit 0, đổi hướng
    jal   x0, LOOP

SET_RIGHT:
    addi  x13, x0, 1        # Đổi trạng thái sang di chuyển Phải
    jal   x0, LOOP

SET_LEFT:
    addi  x13, x0, 0        # Đổi trạng thái sang di chuyển Trái
    jal   x0, LOOP
