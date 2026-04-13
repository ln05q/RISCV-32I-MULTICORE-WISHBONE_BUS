module wb_led_7seg_top (
    input wire clk_i,
    input wire rst_i,

    // --- Wishbone Interface ---
    input wire [31:0] wb_adr_i,
    input wire [31:0] wb_dat_i,
    input wire [ 3:0] wb_sel_i,
    input wire        wb_we_i,
    input wire        wb_cyc_i,
    input wire        wb_stb_i,

    output wire [31:0] wb_dat_o,
    output wire        wb_ack_o,

    // --- LED 7 SEGMENT PINS (Nối ra Kit DE2) ---
    output wire [6:0] hex0,
    output wire [6:0] hex1,
    output wire [6:0] hex2,
    output wire [6:0] hex3
);

  // --- Dây nối nội bộ (Internal Wires) ---
  wire [31:0] seg_addr;
  wire [31:0] seg_wdata;
  wire        seg_we;

  // 1. Instantiate Wishbone Slave Adapter
  wishbone_slave_adapter_led_7seg adapter_inst (
      .clk_i(clk_i),
      .rst_i(rst_i),

      .wb_addr_i(wb_adr_i),
      .wb_data_i(wb_dat_i),
      .wb_data_o(wb_dat_o),
      .wb_we_i  (wb_we_i),
      .wb_stb_i (wb_stb_i),
      .wb_cyc_i (wb_cyc_i),
      .wb_sel_i (wb_sel_i),
      .wb_ack_o (wb_ack_o),

      .seg_addr_o (seg_addr),
      .seg_wdata_o(seg_wdata),
      .seg_we_o   (seg_we)
  );

  // 2. Instantiate LED 7 Segment Core (Module mà ta đã viết ở lượt trước)
  // Lưu ý: addr ở đây lấy bit [3:2] của địa chỉ để chọn 1 trong 4 LED HEX
  led_7segment led_7seg_core (
      .clk  (clk_i),
      .rst  (rst_i),
      .addr (seg_addr[3:2]),  // 0x00->HEX0, 0x04->HEX1, 0x08->HEX2, 0x0C->HEX3
      .we   (seg_we),
      .wdata(seg_wdata),
      .HEX0 (hex0),
      .HEX1 (hex1),
      .HEX2 (hex2),
      .HEX3 (hex3)
  );

endmodule
