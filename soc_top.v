`timescale 1ns / 1ps

module soc_top (
    input wire CLOCK_50,  // clk
    input wire [0:0] KEY,  // RESET (low level)

    // Peripherals Output
    output wire [31:0] timer_debug_val,
    output wire [17:0] LEDR,
    //    inout  wire [31:0] gpio_out,
    output      [ 6:0] HEX0,
    HEX1,
    HEX2,
    HEX3,
    output wire        UART_TXD,
    input  wire        UART_RXD

    // MONITOR DEBUG
    /*
    output wire [31:0] dbg_pc_0,
    dbg_pc_1,
    dbg_pc_2,
    dbg_pc_3,
    output wire [31:0] dbg_instr_0,
    dbg_instr_1,
    dbg_instr_2,
    dbg_instr_3,
    output wire [31:0] dbg_wb_data_0,
    dbg_wb_data_1,
    dbg_wb_data_2,
    dbg_wb_data_3
*/
);

  // -------------------------------------------------------------------------
  // 1. Cấu hình Tham số (Chỉnh sửa số lượng Slave tại đây)
  // -------------------------------------------------------------------------
  localparam NUM_MASTERS = 4;
  localparam NUM_DEVICES = 5;  // RAM, LED, TIMER, GPIO, UART

  //localparam NUM_MASTERS = 3;
  //localparam NUM_DEVICES = 4;  // RAM, LED, TIMER, GPIO, UART

  // -------------------------------------------------------------------------
  // 2. Wires Master và Slave
  // -------------------------------------------------------------------------
  wire [31:0] m_adr[0:3], m_dat_w[0:3], m_dat_r[0:3];
  wire [3:0] m_sel[0:3], m_we, m_stb, m_cyc, m_ack;

  wire [NUM_MASTERS*32-1:0] all_m_adr = {m_adr[3], m_adr[2], m_adr[1], m_adr[0]};
  wire [NUM_MASTERS*32-1:0] all_m_dat_w = {m_dat_w[3], m_dat_w[2], m_dat_w[1], m_dat_w[0]};
  wire [NUM_MASTERS*32-1:0] all_m_dat_r;
  wire [ NUM_MASTERS*4-1:0] all_m_sel = {m_sel[3], m_sel[2], m_sel[1], m_sel[0]};

  // TESTING
  //
  //


  wire [31:0] s_adr, s_dat_w;
  wire [NUM_DEVICES*32-1:0] s_dat_r;  // Gom dữ liệu từ tất cả Slave
  wire [NUM_DEVICES-1:0] s_ack, s_stb, s_cyc;
  wire [3:0] s_sel;
  wire       s_we;

  // -------------------------------------------------------------------------
  // 3. Khởi tạo 4 Master (Cores) - Giữ nguyên logic instance của bạn
  // -------------------------------------------------------------------------

  wb_core_top_0 core0 (
      .clk(CLOCK_50),
      .rst(KEY[0]),
      .wbm_adr_o(m_adr[0]),
      .wbm_dat_o(m_dat_w[0]),
      .wbm_dat_i(m_dat_r[0]),
      .wbm_we_o(m_we[0]),
      .wbm_sel_o(m_sel[0]),
      .wbm_stb_o(m_stb[0]),
      .wbm_cyc_o(m_cyc[0]),
      .wbm_ack_i(m_ack[0])
      /*
      .dbg_pc(dbg_pc_0),
      .dbg_instr(dbg_instr_0),
      .dbg_wb_data(dbg_wb_data_0)
      */
  );


  wb_core_top_1 core1 (
      .clk(CLOCK_50),
      .rst(KEY[0]),
      .wbm_adr_o(m_adr[1]),
      .wbm_dat_o(m_dat_w[1]),
      .wbm_dat_i(m_dat_r[1]),
      .wbm_we_o(m_we[1]),
      .wbm_sel_o(m_sel[1]),
      .wbm_stb_o(m_stb[1]),
      .wbm_cyc_o(m_cyc[1]),
      .wbm_ack_i(m_ack[1])
      /*
      .dbg_pc(dbg_pc_1),
      .dbg_instr(dbg_instr_1),
      .dbg_wb_data(dbg_wb_data_1)
      */
  );

  wb_core_top_2 core2 (
      .clk(CLOCK_50),
      .rst(KEY[0]),
      .wbm_adr_o(m_adr[2]),
      .wbm_dat_o(m_dat_w[2]),
      .wbm_dat_i(m_dat_r[2]),
      .wbm_we_o(m_we[2]),
      .wbm_sel_o(m_sel[2]),
      .wbm_stb_o(m_stb[2]),
      .wbm_cyc_o(m_cyc[2]),
      .wbm_ack_i(m_ack[2])
      /*
      .dbg_pc(dbg_pc_2),
      .dbg_instr(dbg_instr_2),
      .dbg_wb_data(dbg_wb_data_2)
      */
  );


  wb_core_top_3 core3 (
      .clk(CLOCK_50),
      .rst(KEY[0]),
      .wbm_adr_o(m_adr[3]),
      .wbm_dat_o(m_dat_w[3]),
      .wbm_dat_i(m_dat_r[3]),
      .wbm_we_o(m_we[3]),
      .wbm_sel_o(m_sel[3]),
      .wbm_stb_o(m_stb[3]),
      .wbm_cyc_o(m_cyc[3]),
      .wbm_ack_i(m_ack[3])
      /*
      .dbg_pc(dbg_pc_3),
      .dbg_instr(dbg_instr_3),
      .dbg_wb_data(dbg_wb_data_3)
      */
  );

  assign m_dat_r[0] = all_m_dat_r[0*32+:32];
  assign m_dat_r[1] = all_m_dat_r[1*32+:32];
  assign m_dat_r[2] = all_m_dat_r[2*32+:32];
  assign m_dat_r[3] = all_m_dat_r[3*32+:32];

  // -------------------------------------------------------------------------
  // 4. Interconnect 
  // -------------------------------------------------------------------------
  wb_interconnect_4m #(
      .NUM_MASTERS(NUM_MASTERS),
      .NUM_DEVICES(NUM_DEVICES)
  ) bus_matrix (
      .clk_i  (CLOCK_50),
      .rst_i  (KEY[0]),
      .m_adr_i(all_m_adr),
      .m_dat_i(all_m_dat_w),
      .m_dat_o(all_m_dat_r),
      .m_we_i (m_we),
      .m_stb_i(m_stb),
      .m_cyc_i(m_cyc),
      .m_sel_i(all_m_sel),
      .m_ack_o(m_ack),
      .s_adr_o(s_adr),
      .s_dat_o(s_dat_w),
      .s_dat_i(s_dat_r),
      .s_we_o (s_we),
      .s_stb_o(s_stb),
      .s_cyc_o(s_cyc),
      .s_sel_o(s_sel),
      .s_ack_i(s_ack),

      // Thứ tự mảng: {S4: UART, S3: GPIO, S2: TIMER, S1: LED, S0: RAM}
      // Thứ tự mảng: {S4: UART, S3: LED 7 SEGMENT, S2: TIMER, S1: LED, S0: RAM}
      .device_base_addr({
        32'h4000_0000,  // S4: UART
        //        32'h3000_0000,  // S3: GPIO
        32'h3000_0000,  // S3: LED 7 SEGMENT
        32'h2000_0000,  // S2: TIMER
        32'h1000_0000,  // S1: LED_MATRIX
        32'h0000_0000  // S0: RAM
      }),
      .device_region_mask({
        32'h0000_FFFF,  // UART
        32'h0000_FFFF,  // GPIO
        32'h0000_FFFF,  // TIMER
        32'h0000_FFFF,  // LED
        //32'h0000_03FF  // RAM 1KB
        32'h0000_0400  // RAM 1KB
      })
  );

  // -------------------------------------------------------------------------
  // 5. Khởi tạo các Slaves (Muốn tắt cái nào thì comment khối đó)
  // -------------------------------------------------------------------------

  // S0: RAM (0x0000_0000)

  wb_ram_top #(
      .MEM_SIZE(1024)
  ) ram_inst (
      .clk_i(CLOCK_50),
      .rst_i(KEY[0]),
      .wb_adr_i(s_adr),
      .wb_dat_i(s_dat_w),
      .wb_dat_o(s_dat_r[0*32+:32]),
      .wb_we_i(s_we),
      .wb_sel_i(s_sel),
      .wb_stb_i(s_stb[0]),
      .wb_cyc_i(s_cyc[0]),
      .wb_ack_o(s_ack[0])
  );

  // S1: LED MATRIX (0x1000_0000)
  wb_led_matrix_top led_inst (
      .clk_i(CLOCK_50),
      .rst_i(KEY[0]),
      .wb_adr_i(s_adr),
      .wb_dat_i(s_dat_w),
      .wb_dat_o(s_dat_r[1*32+:32]),
      .wb_we_i(s_we),
      .wb_sel_i(s_sel),
      .wb_stb_i(s_stb[1]),
      .wb_cyc_i(s_cyc[1]),
      .wb_ack_o(s_ack[1]),
      .led_pins(LEDR)
  );

  // S2: TIMER (0x2000_0000)
  wb_timer_top timer_inst (
      .clk_i(CLOCK_50),
      .rst_i(KEY[0]),
      .wb_adr_i(s_adr),
      .wb_dat_i(s_dat_w),
      .wb_dat_o(s_dat_r[2*32+:32]),
      .wb_we_i(s_we),
      .wb_sel_i(s_sel),
      .wb_stb_i(s_stb[2]),
      .wb_cyc_i(s_cyc[2]),
      .wb_ack_o(s_ack[2]),
      .timer_value(timer_debug_val)
  );

  /*
  // S3: GPIO (0x3000_0000)
  wb_gpio_top gpio_inst (
      .clk_i(CLOCK_50),
      .rst_i(KEY[0]),
      .wb_adr_i(s_adr),
      .wb_dat_i(s_dat_w),
      .wb_dat_o(s_dat_r[3*32+:32]),
      .wb_we_i(s_we),
      .wb_sel_i(s_sel),
      .wb_stb_i(s_stb[3]),
      .wb_cyc_i(s_cyc[3]),
      .wb_ack_o(s_ack[3]),
      .gpio_pins(gpio_out)
  );
*/

  // S3: GPIO (0x3000_0000)

  wb_led_7seg_top led_7_segment_inst (
      .clk_i(CLOCK_50),
      .rst_i(KEY[0]),
      .wb_adr_i(s_adr),
      .wb_dat_i(s_dat_w),
      .wb_dat_o(s_dat_r[3*32+:32]),
      .wb_we_i(s_we),
      .wb_sel_i(s_sel),
      .wb_stb_i(s_stb[3]),
      .wb_cyc_i(s_cyc[3]),
      .wb_ack_o(s_ack[3]),
      .hex0(HEX0),
      .hex1(HEX1),
      .hex2(HEX2),
      .hex3(HEX3)
  );

  // S4: UART (0x4000_0000)
  wb_uart_top uart_inst (
      .clk_i(CLOCK_50),
      .rst_i(KEY[0]),
      .wb_adr_i(s_adr),
      .wb_dat_i(s_dat_w),
      .wb_dat_o(s_dat_r[4*32+:32]),
      .wb_we_i(s_we),
      .wb_sel_i(s_sel),
      .wb_stb_i(s_stb[4]),
      .wb_cyc_i(s_cyc[4]),
      .wb_ack_o(s_ack[4]),
      .uart_tx(UART_TXD),
      .uart_rx(UART_RXD)
      //      .dbg_rx_data(dbg_rx_data),
      //     .dbg_tx_data(dbg_tx_data)
  );

  // PHẦN QUAN TRỌNG: Nếu bạn comment một Slave nào ở trên, 
  // hãy gán s_ack[index] = 0 và s_dat_r[index*32 +: 32] = 0 để tránh treo Bus.
  // Tránh treo Bus cho các Slave đã bị comment
  /*
  assign s_ack[0] = 1'b0;  // Ram
  assign s_dat_r[0*32+:32] = 32'h0;
 
  assign s_ack[2] = 1'b0;  // Timer
  assign s_dat_r[2*32+:32] = 32'h0;

  assign s_ack[3] = 1'b0;  // GPIO
  assign s_dat_r[3*32+:32] = 32'h0;

  assign s_ack[4] = 1'b0;  // UART
  assign s_dat_r[4*32+:32] = 32'h0;
  */
endmodule
