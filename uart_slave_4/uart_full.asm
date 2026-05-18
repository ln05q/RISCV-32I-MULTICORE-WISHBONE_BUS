.text
.globl main

main:
    # --- 1. KHỞI TẠO ĐỊA CHỈ BASE UART ---
    lui   x5, 0x40000           # x5 = 0x4000_0000 (Base UART)

    # =================================================================
    # GIAI ĐOẠN 1: GỬI THÔNG ĐIỆP CHÀO MỪNG LÊN MÁY TÍNH (CHỈ CHẠY 1 LẦN)
    # =================================================================
    
    # Từ: "Do"
    addi  x10, x0, 68           # 'D'
    jal   x1, UART_SEND
    addi  x10, x0, 111          # 'o'
    jal   x1, UART_SEND

    # Khoảng trắng (Space)
    addi  x10, x0, 32           # ' '
    jal   x1, UART_SEND

    # Từ: "an"
    addi  x10, x0, 97           # 'a'
    jal   x1, UART_SEND
    addi  x10, x0, 110          # 'n'
    jal   x1, UART_SEND

    # Khoảng trắng (Space)
    addi  x10, x0, 32           # ' '
    jal   x1, UART_SEND

    # Từ: "SOC"
    addi  x10, x0, 83           # 'S'
    jal   x1, UART_SEND
    addi  x10, x0, 79           # 'O'
    jal   x1, UART_SEND
    addi  x10, x0, 67           # 'C'
    jal   x1, UART_SEND

    # Ký tự: " - "
    addi  x10, x0, 32           # ' '
    jal   x1, UART_SEND
    addi  x10, x0, 45           # '-'
    jal   x1, UART_SEND
    addi  x10, x0, 32           # ' '
    jal   x1, UART_SEND

    # Mã môn học: "CE433"
    addi  x10, x0, 67           # 'C'
    jal   x1, UART_SEND
    addi  x10, x0, 69           # 'E'
    jal   x1, UART_SEND
    addi  x10, x0, 52           # '4'
    jal   x1, UART_SEND
    addi  x10, x0, 51           # '3'
    jal   x1, UART_SEND
    addi  x10, x0, 51           # '3'
    jal   x1, UART_SEND

    # =================================================================
    # GIAI ĐOẠN 2: VÒNG LẶP LIÊN TỤC LẮNG NGHE VÀ TRIGGER CHIỀU RX
    # =================================================================
MAIN_LOOP_RX:
    # 1. Đọc thanh ghi UART_STATUS (Offset 4) vào x6
    lw    x6, 4(x5)             
    
    # 2. Lọc lấy Bit 1 (r_rx_data_ready) để kiểm tra chiều nhận
    andi  x7, x6, 2             # x7 = x6 AND 2
    
    # 3. Nếu x7 == 0 (Máy tính chưa gửi gì xuống), lặp lại để tiếp tục đợi
    beq   x7, x0, MAIN_LOOP_RX  

    # 4. TRIGGER: Khi phát hiện có ký tự mới từ máy tính gửi xuống (Bit 1 == 1)
    # CPU thoát vòng lặp trên, lao xuống đọc thanh ghi UART_DATA (Offset 0)
    # Lệnh đọc này tự động làm 2 việc:
    #   - Nạp mã ASCII vào x12 (và cập nhật trực tiếp chân raw_rx_byte ra LED)
    #   - Tự động hạ cờ r_rx_data_ready về 0 trong phần cứng để sẵn sàng cho ký tự sau.
    lw    x12, 0(x5)            

    # 5. Quay lại vòng lặp để tiếp tục trực chiến RX
    jal   x0, MAIN_LOOP_RX       


# =================================================================
# CHƯƠNG TRÌNH CON: UART_SEND (Hỗ trợ Giai đoạn 1)
# =================================================================
UART_SEND:
    lw    x6, 4(x5)             # Đọc thanh ghi UART_STATUS (Offset 4)
    andi  x6, x6, 1             # Lọc duy nhất Bit 0 (tx_active)
    bne   x6, x0, UART_SEND     # Nếu bận (bit 0 == 1), lặp lại chờ
    sw    x10, 0(x5)            # Rảnh thì ghi dữ liệu từ x10 vào UART_DATA để gửi đi
    jalr  x0, 0(x1)             # Quay về vị trí gọi lệnh
