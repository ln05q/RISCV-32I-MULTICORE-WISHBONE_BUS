.text
.globl main

main:
    # --- THIẾT LẬP ĐỊA CHỈ NGOẠI VI ---
    # lui x5, 0x20000 
    # Mã máy: 00100000000000000000001010110111
    lui   x5, 0x20000       # Nạp địa chỉ Base Timer = 0x2000_0000 vào x5

    # --- CÀI ĐẶT CHU KỲ ĐẾM (PERIOD) ---
    # addi x6, x0, 2013 
    # Mã máy: 00000111110100000000001100010011
    # Giải thích: 2013 (thập phân) = 0x7DD (Hex). 12-bit Immediate là 000001111101.
    addi  x6, x0, 0x7DD      # Lưu giá trị ngưỡng đếm 2013 vào x6

    # sw x6, 4(x5)
    # Mã máy: 00000000011000101010001000100011
    sw    x6, 4(x5)         # Ghi giá trị 2013 vào thanh ghi timer_period (Offset 4)

    # --- KÍCH HOẠT TIMER ---
    # addi x7, x0, 1
    # Mã máy: 00000000000100000000001110010011
    addi  x7, x0, 1         # Gán x7 = 1 (Dùng làm tín hiệu Enable)

    # sw x7, 0(x5)
    # Mã máy: 00000000011100101010000000100011
    sw    x7, 0(x5)         # Ghi 1 vào thanh ghi timer_ctrl (Offset 0) để bắt đầu đếm

    # --- VÒNG LẶP ĐỢI (DELAY) ---
    # addi x10, x0, 10
    # Mã máy: 00000000101000000000010100010011
    addi  x10, x0, 10       # Khởi tạo biến đếm ngược delay = 10
    
WAIT_LOOP:
    # addi x10, x10, -1
    # Mã máy: 11111111111101010000010100010011
    addi  x10, x10, -1      # Giảm biến đếm x10
    
    # bne x10, x0, -4
    # Mã máy: 11111110000001010001111011100011
    bne   x10, x0, WAIT_LOOP # Nếu x10 != 0, nhảy ngược lại 4 byte (về lệnh addi trên)

    # --- KIỂM TRA VÀ DỪNG HỆ THỐNG ---
    # lw x8, 4(x5)
    # Mã máy: 00000000010000101010010000000011
    lw    x8, 4(x5)         # Đọc lại giá trị từ thanh ghi Period/Status để kiểm tra

    # 5 lệnh NOP (No Operation) để CPU nghỉ ngơi, dễ quan sát trên Waveform
    addi  x0, x0, 0         # NOP 1 (00000000000000000000000000010011)
    addi  x0, x0, 0         # NOP 2
    addi  x0, x0, 0         # NOP 3
    addi  x0, x0, 0         # NOP 4
    addi  x0, x0, 0         # NOP 5

    # sw x0, 0(x5)
    # Mã máy: 00000000000000101010000000100011
    sw    x0, 0(x5)         # Ghi 0 vào timer_ctrl để DỪNG Timer
