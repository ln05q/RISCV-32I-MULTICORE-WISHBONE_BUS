.text
.globl main

main:
    # --- BƯỚC 1: THIẾT LẬP ĐỊA CHỈ GỐC (BASE ADDRESS) ---
    # nạp 0x30000000 vào x5. 
    # Lệnh lui sẽ nạp 20-bit cao, tạo ra 0x30000000
    lui   x5, 0x30000       

    # --- BƯỚC 2: HIỂN THỊ SỐ 1 LÊN HEX0 (Địa chỉ 0x3000_0000) ---
    addi  x6, x0, 1         # x6 = 1
    sw    x6, 0(x5)         # Ghi giá trị 1 vào HEX0 (Offset 0)

    # --- BƯỚC 3: HIỂN THỊ SỐ 2 LÊN HEX1 (Địa chỉ 0x3000_0004) ---
    addi  x6, x0, 2         # x6 = 2
    sw    x6, 4(x5)         # Ghi giá trị 2 vào HEX1 (Offset 4)

    # --- BƯỚC 4: HIỂN THỊ SỐ 3 LÊN HEX2 (Địa chỉ 0x3000_0008) ---
    addi  x6, x0, 3         # x6 = 3
    sw    x6, 8(x5)         # Ghi giá trị 3 vào HEX2 (Offset 8)

    # --- BƯỚC 5: HIỂN THỊ SỐ 4 LÊN HEX3 (Địa chỉ 0x3000_000C) ---
    addi  x6, x0, 4         # x6 = 4
    sw    x6, 12(x5)        # Ghi giá trị 4 vào HEX3 (Offset 12)

    # --- BƯỚC 6: VÒNG LẶP VÔ HẠN ĐỂ GIỮ KẾT QUẢ ---
end_loop:
    jal   x0, end_loop      # Nhảy tại chỗ để chương trình không chạy bậy
