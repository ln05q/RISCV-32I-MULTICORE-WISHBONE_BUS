.text
.globl main

main:
    # --- KHỞI TẠO ĐỊA CHỈ UART ---
    # 1. lui x5, 0x40000 -> 01000000000000000000001010110111
    lui   x5, 0x40000       # x5 = 0x4000_0000 (Base UART)

    # 2. addi x5, x5, 0 -> 00000000000000101000001010010011
    addi  x5, x5, 0         # Đảm bảo x5 chuẩn 0x4000_0000

    # --- TRUYỀN KÝ TỰ 'd' (ASCII 100) ---
    # 3. addi x10, x0, 100 -> 00000110010000000000010100010011
    addi  x10, x0, 100      # x10 = 'd'
    
    # 4. jal x1, UART_SEND -> 00000001100000000000000011101111
    jal   x1, UART_SEND     # Nhảy đến chương trình con gửi UART

    # --- TRUYỀN KÝ TỰ 'a' (ASCII 97) ---
    # 5. addi x10, x0, 97 -> 00000110000100000000010100010011
    addi  x10, x0, 97       # x10 = 'a'
    
    # 6. jal x1, UART_SEND -> 00000001000000000000000011101111
    jal   x1, UART_SEND     # Nhảy đến chương trình con gửi UART

    # --- TRUYỀN KÝ TỰ '1' (ASCII 49) ---
    # 7. addi x10, x0, 49 -> 00000011000100000000010100010011
    addi  x10, x0, 49       # x10 = '1'
    
    # 8. jal x1, UART_SEND -> 00000000100000000000000011101111
    jal   x1, UART_SEND     # Nhảy đến chương trình con gửi UART

    # 9. jal x0, END -> 00000000000000000000000001101111
    jal   x0, END           # Vòng lặp vô tận kết thúc chương trình

UART_SEND:
    # 10. lw x6, 4(x5) -> 00000000010000101010001100000011
    lw    x6, 4(x5)         # Đọc thanh ghi UART_STATUS (Offset 4)

    # 11. addi x14, x6, 1 -> 00000000000100110111001100010011
    addi  x14, x6, 1        # Kiểm tra bit trạng thái (Logic tùy module)

    # 12. bne x6, x0, -8 -> 11111110000000110001110011100011
    bne   x6, x0, UART_SEND # Nếu UART đang bận (x6 != 0), lặp lại kiểm tra

    # 13. sw x10, 0(x5) -> 00000000101000101000000000100011
    sw    x10, 0(x5)        # Ghi ký tự trong x10 vào UART_DATA (Offset 0) để gửi

    # 14. jalr x0, 0(x1) -> 00000000000000001000000001100111
    jalr  x0, 0(x1)         # Quay về (Return) vị trí sau lệnh gọi jal x1

END:
    jal   x0, END           # Loop forever
