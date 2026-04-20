`timescale 1ns / 1ps

module wb_interconnect_4m #(
    parameter NUM_MASTERS = 4,
    parameter NUM_DEVICES = 2
) (
    input wire clk_i,
    input wire rst_i,

    // --- Master Interfaces (4 Cores) ---
    input  wire [NUM_MASTERS*32-1:0] m_adr_i,
    input  wire [NUM_MASTERS*32-1:0] m_dat_i,
    output reg  [NUM_MASTERS*32-1:0] m_dat_o,
    input  wire [NUM_MASTERS-1:0]    m_we_i,
    input  wire [NUM_MASTERS-1:0]    m_stb_i,
    input  wire [NUM_MASTERS-1:0]    m_cyc_i,
    input  wire [NUM_MASTERS*4-1:0]  m_sel_i,
    output reg  [NUM_MASTERS-1:0]    m_ack_o,

    // --- Slave Interfaces ---
    output wire [              31:0] s_adr_o,
    output wire [              31:0] s_dat_o,
    input  wire [NUM_DEVICES*32-1:0] s_dat_i,
    output wire                      s_we_o,
    output reg  [   NUM_DEVICES-1:0] s_stb_o,
    output reg  [   NUM_DEVICES-1:0] s_cyc_o,
    output wire [               3:0] s_sel_o,
    input  wire [   NUM_DEVICES-1:0] s_ack_i,

    // --- Cấu hình địa chỉ (như cũ) ---
    input wire [NUM_DEVICES*32-1:0] device_base_addr,
    input wire [NUM_DEVICES*32-1:0] device_region_mask
);

  // ---------------------------------------------------------
  // 1. ARBITER: Chọn Master được quyền sử dụng Bus
  // ---------------------------------------------------------
  reg [1:0] master_sel;  // ID của Master đang được chọn (0..3)
  reg       bus_busy;  // Bus đang trong một giao dịch

  always @(posedge clk_i) begin
    if (!rst_i) begin
      master_sel <= 2'b00;
      bus_busy   <= 1'b0;
    end else begin
      if (!bus_busy) begin
        // Nếu bus rảnh, tìm Master tiếp theo có yêu cầu (Round Robin)
        if (m_cyc_i[(master_sel+1)%4]) master_sel <= (master_sel + 1) % 4;
        else if (m_cyc_i[(master_sel+2)%4]) master_sel <= (master_sel + 2) % 4;
        else if (m_cyc_i[(master_sel+3)%4]) master_sel <= (master_sel + 3) % 4;
        else if (m_cyc_i[master_sel]) master_sel <= master_sel;

        if (m_cyc_i != 4'b0000) bus_busy <= 1'b1;
      end else begin
        // Nếu giao dịch kết thúc (nhận được ACK hoặc Master hạ CYC)
        if (m_ack_o[master_sel] || !m_cyc_i[master_sel]) begin
          bus_busy <= 1'b0;
        end
      end
    end
  end

  // Tín hiệu của Master "chiến thắng"
  wire    [           31:0] current_m_adr = m_adr_i[master_sel*32+:32];
  wire    [           31:0] current_m_dat = m_dat_i[master_sel*32+:32];
  wire                      current_m_we = m_we_i[master_sel];
  wire                      current_m_stb = m_stb_i[master_sel];
  wire                      current_m_cyc = m_cyc_i[master_sel];
  wire    [            3:0] current_m_sel = m_sel_i[master_sel*4+:4];

  // ---------------------------------------------------------
  // 2. ADDRESS DECODER: Chọn Slave dựa trên địa chỉ của Master
  // ---------------------------------------------------------
  reg     [NUM_DEVICES-1:0] device_sel;
  integer                   j;

  always @(*) begin
    device_sel = {NUM_DEVICES{1'b0}};
    for (j = 0; j < NUM_DEVICES; j = j + 1) begin
      // Tính toán mask tương tự như logic cũ của bạn
      if ((current_m_adr & ~(device_region_mask[j*32+:32] - 1)) == device_base_addr[j*32+:32]) begin
        device_sel[j] = 1'b1;
      end
    end
  end

  // Kết nối tín hiệu đến Slave
  assign s_adr_o = current_m_adr;
  assign s_dat_o = current_m_dat;
  assign s_we_o  = current_m_we;
  assign s_sel_o = current_m_sel;

  always @(*) begin
    s_stb_o = {NUM_DEVICES{1'b0}};
    s_cyc_o = {NUM_DEVICES{1'b0}};
    if (bus_busy) begin
      s_stb_o = device_sel & {NUM_DEVICES{current_m_stb}};
      s_cyc_o = device_sel & {NUM_DEVICES{current_m_cyc}};
    end
  end

  // ---------------------------------------------------------
  // 3. RESPONSE MUX: Trả dữ liệu/ACK về đúng Master
  // ---------------------------------------------------------
  reg [31:0] selected_s_dat;
  reg        selected_s_ack;

  always @(*) begin
    selected_s_dat = 32'h0;
    selected_s_ack = 1'b0;
    for (j = 0; j < NUM_DEVICES; j = j + 1) begin
      if (device_sel[j]) begin
        selected_s_dat = s_dat_i[j*32+:32];
        selected_s_ack = s_ack_i[j];
      end
    end
  end

  // Chỉ trả ACK và Data về cho Master đang giữ quyền truy cập
  always @(*) begin
    m_ack_o = {NUM_MASTERS{1'b0}};
    m_dat_o = {NUM_MASTERS * 32{1'b0}};

    if (bus_busy) begin
      m_ack_o[master_sel] = selected_s_ack;
      m_dat_o[master_sel*32+:32] = selected_s_dat;
    end
  end

endmodule
