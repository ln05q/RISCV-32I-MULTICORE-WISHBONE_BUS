.text
.globl main

main:
    # --- PHẦN 1: KHỞI TẠO THANH GHI VÀ ĐỊA CHỈ BASE ---
    addi  x8, x0, 16        # x8 = 16 (0x10). Dùng làm địa chỉ Base
    lui   x9, 0x11111       # x9 = 0x11111000
    addi  x9, x9, 273       # x9 = 0x11111111 (Cấu hình giá trị test)
    lui   x10, 0x22222      # x10 = 0x22222000
    addi  x10, x10, 546     # x10 = 0x22222222

    # --- PHẦN 2: THAO TÁC GHI DỮ LIỆU (STORE) ---
    sw    x9, 0(x8)         # Ghi 0x11111111 vào địa chỉ 0x10
    sw    x9, 4(x8)         # Ghi 0x11111111 vào địa chỉ 0x14
    add   x10, x8, x8       # x10 = 16 + 16 = 32 (0x20)
    sw    x10, 8(x8)        # Ghi giá trị 32 vào địa chỉ 0x18
    sw    x0, 0(x8)         # Xóa dữ liệu (ghi 0) tại địa chỉ 0x10

    # --- PHẦN 3: TÍNH TOÁN LOGIC VÀ DỊCH BIT ---
    addi  x10, x0, 1365     # x10 = 0x555
    slli  x10, x10, 1       # Dịch trái 1 bit: x10 = 0xAAA
    sw    x9, 10(x8)        # Ghi x9 vào địa chỉ 0x1A (Offset 10)
    lw    x10, 16(x8)       # Đọc dữ liệu từ địa chỉ 0x20 vào x10
    addi  x10, x10, 1       # Tăng giá trị vừa đọc: x10 = x10 + 1
    sw    x10, 20(x8)       # Ghi lại kết quả vào địa chỉ 0x24

    # --- PHẦN 4: TRUY XUẤT BỘ NHỚ THEO BYTE/HALF-WORD ---
    lw    x25, 0(x8)        # Đọc Word từ địa chỉ 0x10 vào x25
    sb    x25, 1(x8)        # Ghi 1 Byte thấp của x25 vào địa chỉ 0x11
    sh    x25, 2(x8)        # Ghi Half-word (2 byte) vào địa chỉ 0x12
    lbu   x27, 2(x8)        # Đọc 1 Byte không dấu từ địa chỉ 0x12
    lhu   x28, 0(x8)        # Đọc Half-word không dấu từ địa chỉ 0x10
    lb    x28, 2(x8)        # Đọc 1 Byte có dấu từ địa chỉ 0x12
    lh    x31, 2(x8)        # Đọc Half-word có dấu từ địa chỉ 0x12

    # --- PHẦN 5: TÍNH TOÁN CUỐI VÀ KẾT THÚC ---
    add   x31, x8, x0       # Copy giá trị x8 sang x31
    addi  x29, x8, 255      # x29 = 16 + 255 = 271
    sw    x29, 29(x28)      # Ghi x29 vào địa chỉ (x28 + 29)
    addi  x6, x0, 288       # x6 = 288
    lui   x7, 0xDEADB       # Nạp hằng số đặc biệt 0xDEADB000 vào x7
    addi  x7, x7, 209       # x7 = 0xDEADB0D1
    sw    x6, 7(x14)        # Ghi x6 vào địa chỉ (x14 + 7)
