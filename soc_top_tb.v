`timescale 1ns / 1ps

module soc_top_tb;

  // 1. Khai báo các tín hiệu kết nối với SOC
  reg         clk;
  reg         rst;

  // Các đường dây để quan sát (Monitor) từ Waveform
  wire [31:0] timer_debug;  // slave timer
  wire [31:0] led_matrix_out;  // slave led_matrix

  wire        uart_tx;  // slave uart_tx
  wire        uart_rx;  // slave uart_rx
  //  wire [ 7:0] dbg_rx_data;
  // wire [ 7:0] dbg_tx_data;
  wire [31:0] pc                                  [0:3];
  wire [31:0] instr                               [0:3];
  wire [31:0] data                                [0:3];
  wire [ 6:0] HEX0;
  wire [ 6:0] HEX1;
  wire [ 6:0] HEX2;
  wire [ 6:0] HEX3;


  // 2. Khởi tạo Module SOC TOP (UUT - Unit Under Test)
  soc_top uut (
      .clk(clk),
      .rst(rst),
      .timer_debug_val(timer_debug),
      .led_matrix_out(led_matrix_out),
      .uart_tx(uart_tx),
      .uart_rx(uart_rx),
      .HEX0(HEX0),
      .HEX1(HEX1),
      .HEX2(HEX2),
      .HEX3(HEX3),
      //    .dbg_rx_data(dbg_rx_data),
      //   .dbg_tx_data(dbg_tx_data),
      // TESTING

      //
      // Kết nối các chân Debug ra để xem trên sóng (Waveform)

      .dbg_pc_0(pc[0]),
      .dbg_pc_1(pc[1]),
      .dbg_pc_2(pc[2]),
      .dbg_pc_3(pc[3]),
      .dbg_instr_0(instr[0]),
      .dbg_instr_1(instr[1]),
      .dbg_instr_2(instr[2]),
      .dbg_instr_3(instr[3]),
      .dbg_wb_data_0(data[0]),
      .dbg_wb_data_1(data[1]),
      .dbg_wb_data_2(data[2]),
      .dbg_wb_data_3(data[3])

  );

  // 3. Tạo xung Clock (Ví dụ: 100MHz => Chu kỳ 10ns)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Đảo trạng thái mỗi 5ns
  end

  // 4. Kịch bản Reset và Chạy
  initial begin
    // Trạng thái ban đầu
    rst = 1;

    // Chờ 100ns cho hệ thống ổn định
    #100;

    // Thả Reset để các Core bắt đầu chạy
    $display("--- THA RESET: HE THONG BAT DAU CHAY ---");
    rst = 0;

    // Cho hệ thống tự vận hành trong 50 micro giây (tùy bạn chỉnh)
    // Đây là khoảng thời gian để các tập lệnh trong Core thực thi
    #50000;

    // Kết thúc mô phỏng
    $display("--- KET THUC MO PHONG TAI %t ---", $time);
    $finish;
  end

  // (Tùy chọn) In một số thông tin ra Console để theo dõi nhanh
  initial begin
    $monitor("Time: %t | PC0: %h | PC1: %h | Timer: %d", $time, pc[0], pc[1], timer_debug);
  end

endmodule
