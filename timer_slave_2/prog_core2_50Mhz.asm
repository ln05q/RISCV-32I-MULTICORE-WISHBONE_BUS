.text
.globl main

main:
    # --- 1. KHỞI TẠO ĐỊA CHỈ ---
    lui   x5, 0x20000       # x5 = 0x2000_0000 (Base Timer)

    # --- 2. RESET HARDWARE ---
    # Đảm bảo bit Enable của Timer Hardware tắt để không bị xung đột với CPU
    sw    x0, 0(x5)         # ctrl = 0

RESET_COUNTER:
    addi  x11, x0, 0        # x11 là biến đếm, bắt đầu từ 0

LOOP_COUNT:
    # --- 3. HIỂN THỊ GIÁ TRỊ ---
    sw    x11, 8(x5)        # Ghi giá trị x11 vào thanh ghi value (HEX6-7 sẽ hiện số này)

    # --- 4. VÒNG LẶP DELAY (KHOẢNG 1 GIÂY) ---
    # Với xung 50MHz, mỗi vòng lặp addi + bne mất khoảng 2-4 chu kỳ.
    # Ta nạp khoảng 12.5 triệu để tạo độ trễ tầm 1 giây (tùy vào CPI của Core bạn dùng)
    li    x10, 12500000     
DELAY_WAIT:
    addi  x10, x10, -1      # Giảm x10
    bne   x10, x0, DELAY_WAIT # Nếu chưa về 0 thì lặp tiếp

    # --- 5. KIỂM TRA ĐIỀU KIỆN DỪNG (SỐ 10) ---
    addi  x11, x11, 1       # Tăng biến đếm lên 1
    
    # addi  x12, x0, 11       # Ngưỡng chặn là 11 (để hiện xong số 10 thì mới reset)
     addi  x12, x0, 100       # Ngưỡng chặn là 11 (để hiện xong số 99 thì mới reset)
        blt   x11, x12, LOOP_COUNT # Nếu x11 < 11 thì quay lại hiển thị số tiếp theo

    # --- 6. QUAY LẠI TỪ ĐẦU ---
    jal   x0, RESET_COUNTER # Sau khi đếm tới 10 thì quay về 0
