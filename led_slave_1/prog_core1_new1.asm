# Chasing Light Effect - Fixed for 50MHz Kit
.text
.globl main

main:
    # 1. Trỏ vào địa chỉ Base LED
    lui    x10, 0x10000       # x10 = 0x10000000
    
    # 2. ENABLE LED MODULE
    addi   x5, x0, 1          
    sw     x5, 0(x10)         # Ghi 1 vào Control Reg (Offset 0)

    # 3. Khởi tạo bit đầu tiên (LED bên phải cùng sáng)
    addi   x11, x0, 1         # x11 = 1 

LOOP_START:
    # 4. Ghi giá trị vào thanh ghi DATA
    sw     x11, 4(x10)        # Ghi vào Data Reg (Offset 4)
    
    # 5. DELAY CỰC LỚN (Để mắt người nhìn thấy)
    # 5.000.000 chu kỳ ~ 0.1 giây mỗi bước chạy (tổng 3.2s để chạy hết 32 LED)
    li     x12, 5000000       
WAIT:
    addi   x12, x12, -1       
    bne    x12, x0, WAIT 
    
    # 6. Dịch bit sang trái để tạo hiệu ứng đuổi
    slli   x11, x11, 1        

    # 7. Kiểm tra nếu đã dịch hết 32 LED (x11 sẽ bằng 0)
    # Nếu x11 khác 0, quay lại chạy tiếp bit tiếp theo
    bne    x11, x0, LOOP_START 

    # 8. Reset về LED đầu tiên và lặp lại từ đầu
    addi   x11, x0, 1         
    jal    x0, LOOP_START
