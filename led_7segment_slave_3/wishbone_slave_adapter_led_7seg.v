module wishbone_slave_adapter_led_7seg (
    input clk_i,
    input rst_i,

    // --- Giao diện Wishbone ---
    input  [31:0] wb_addr_i,
    input  [31:0] wb_data_i,
    output [31:0] wb_data_o,
    input         wb_we_i,
    input         wb_stb_i,
    input         wb_cyc_i,
    input  [ 3:0] wb_sel_i,
    output        wb_ack_o,

    // --- Giao diện nối vào LED 7 SEGMENT CORE
    output [31:0] seg_addr_o,
    output [31:0] seg_wdata_o,
    output        seg_we_o
);

  // --- 1. Định nghĩa FSM (Giống led_matrix của bạn) ---
  localparam STATE_IDLE = 2'b00;
  localparam STATE_ACK = 2'b01;
  localparam STATE_COOLDOWN = 2'b10;

  reg [1:0] state, next_state;

  always @(posedge clk_i) begin
    if (rst_i) state <= STATE_IDLE;
    else state <= next_state;
  end

  // --- 2. Logic chuyển trạng thái ---
  always @(*) begin
    next_state = state;
    case (state)
      STATE_IDLE: begin
        if (wb_stb_i && wb_cyc_i) next_state = STATE_ACK;
      end
      STATE_ACK: begin
        next_state = STATE_COOLDOWN;
      end
      STATE_COOLDOWN: begin
        next_state = STATE_IDLE;
      end
      default: next_state = STATE_IDLE;
    endcase
  end

  // --- 3. Logic xuất tín hiệu Wishbone ---
  assign wb_ack_o = (state == STATE_ACK);

  // LED 7 đoạn của bạn thường chỉ nhận lệnh ghi, 
  // nên rdata trả về 0 hoặc có thể bỏ qua
  assign wb_data_o = 32'd0;

  // --- 4. Logic kết nối phía LED Core ---
  assign seg_addr_o = wb_addr_i;
  assign seg_wdata_o = wb_data_i;

  // Chỉ kích hoạt Write Enable khi đang ở trạng thái bắt đầu giao dịch và là lệnh ghi
  assign seg_we_o = wb_stb_i && wb_we_i && (state == STATE_IDLE);

endmodule
