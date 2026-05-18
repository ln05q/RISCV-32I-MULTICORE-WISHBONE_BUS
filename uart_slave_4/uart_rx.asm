.text
.globl main

main:
    lui   x5, 0x40000           # x5 = 0x4000_0000 (Base UART)

WAIT_FOR_RX:
    lw    x10, 4(x5)            # Đọc Status Register (Offset 4)
    
    # ÉP TRIGGER: Nếu Status == 0 (cả 2 cờ đều bằng 0), quay lại đợi.
    # Nếu có bất kỳ cờ nào lên (Status khác 0), vọt xuống đọc dữ liệu luôn!
    beq   x10, x0, WAIT_FOR_RX 

    # Đọc dữ liệu để cập nhật ra chân dbg_rx_data của bạn
    lw    x12, 0(x5)            # Đọc Data (Offset 0) -> Tự động clear cờ luôn

    jal   x0, WAIT_FOR_RX       # Tiếp tục vòng lặp
