.text
.globl main

main:
    # --- PHẦN KHỞI TẠO HỆ THỐNG ---
    lui    x5, 0x10000       # Gán x5 = 0x10000000 (Địa chỉ Base của LED Matrix)
    addi   x8, x0, 1         # Gán x8 = 1 (Giá trị dùng để Enable module)
    sw     x8, 0(x5)         # Ghi 1 vào thanh ghi CONTROL (Offset 0) để mở khóa LED

    # --- CHUẨN BỊ DỮ LIỆU HIỂN THỊ ---
    # Lưu ý: addi x12, x0, -1 vẫn hoạt động vì -1 (0xFFF...) nằm trong dải 12-bit
    addi   x12, x0, -1       # Gán x12 = 0xFFFFFFFF (Tất cả 32 LED đều sáng)
    addi   x14, x0, 0        # Gán x14 = 0x00000000 (Tất cả 32 LED đều tắt)

LOOP:
    # --- GIAI ĐOẠN 1: BẬT ĐÈN ---
    sw    x12, 4(x5)         # Ghi 0xFFFFFFFF vào thanh ghi DATA (Offset 4)
    
    # Vòng lặp trễ 1 (Tăng lên để mắt người kịp nhìn)
    li    x10, 10000000      # Nạp 10,000,000 vào x10 (tạo trễ ~0.8 giây ở 50MHz)
DELAY1:
    addi  x10, x10, -1       # Giảm x10 đi 1 đơn vị
    bne   x10, x0, DELAY1    # Nếu x10 chưa bằng 0, quay lại DELAY1

    # --- GIAI ĐOẠN 2: TẮT ĐÈN ---
    sw    x14, 4(x5)         # Ghi 0x00000000 vào thanh ghi DATA (Offset 4)

    # Vòng lặp trễ 2 (Đảm bảo thời gian tắt cũng đủ lâu)
    li    x10, 10000000      # Reset biến đếm x10 = 10,000,000
DELAY2:
    addi  x10, x10, -1       
    bne   x10, x0, DELAY2   

    # --- VÒNG LẬP VÔ HẠN ---
    jal   x0, LOOP           # Nhảy về nhãn LOOP để tiếp tục chập tắt
