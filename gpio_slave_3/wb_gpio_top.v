module wb_gpio_top (
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

    // GPIO PINS
    inout wire [31:0] gpio_pins
);

  wire [ 1:0] gpio_addr;
  wire [31:0] gpio_rdata;
  wire        gpio_we;
  wire        gpio_rst;

  assign gpio_rst = rst_i;

  // 1. Instantiate Adapter
  wishbone_slave_adapter_gpio adapter_inst (
      .clk_i    (clk_i),
      .rst_i      (gpio_rst),
      .wb_addr_i(wb_adr_i),
      .wb_data_i(wb_dat_i),
      .wb_we_i  (wb_we_i),
      .wb_stb_i (wb_stb_i),
      .wb_cyc_i (wb_cyc_i),
      .wb_data_o(wb_dat_o),
      .wb_ack_o (wb_ack_o),

      // Các chân này giờ đã tồn tại trong adapter
      .core_addr_o (gpio_addr),
      .core_we_o   (gpio_we),
      .core_rdata_i(gpio_rdata)
  );

  // 2. Instantiate GPIO Core (Duy nhất 1 lần ở đây)
  gpio gpio_inst (
      .clk      (clk_i),
      .rst      (gpio_rst),
      .addr     (gpio_addr),
      .we       (gpio_we),
      .wdata    (wb_dat_i),
      .rdata    (gpio_rdata),
      .gpio_pins(gpio_pins)
  );

endmodule
