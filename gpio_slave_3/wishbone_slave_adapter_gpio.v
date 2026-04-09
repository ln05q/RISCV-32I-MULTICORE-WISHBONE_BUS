module wishbone_slave_adapter_gpio (
    input wire clk_i,
    input wire rst_i,

    // --- Wishbone Interface ---
    input  wire [31:0] wb_addr_i,
    input  wire [31:0] wb_data_i,
    input  wire        wb_we_i,
    input  wire        wb_stb_i,
    input  wire        wb_cyc_i,
    output wire [31:0] wb_data_o,
    output wire        wb_ack_o,

    // --- GPIO Core Interface (Kết nối ra Top) ---
    output wire [ 1:0] core_addr_o,
    output wire        core_we_o,
    input  wire [31:0] core_rdata_i
);

  localparam STATE_IDLE = 2'b00;
  localparam STATE_ACK = 2'b01;
  localparam STATE_COOLDOWN = 2'b10;

  reg [1:0] state, next_state;

  // FSM Logic
  always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) state <= STATE_IDLE;
    else state <= next_state;
  end

  always @(*) begin
    next_state = state;
    case (state)
      STATE_IDLE: begin
        if (wb_cyc_i && wb_stb_i) next_state = STATE_ACK;
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

  // Kết nối tín hiệu ra Core
  assign core_addr_o = wb_addr_i[3:2];
  assign core_we_o   = (wb_cyc_i && wb_stb_i && wb_we_i) && (state == STATE_IDLE);

  // Trả dữ liệu về Wishbone
  assign wb_ack_o    = (state == STATE_ACK);
  assign wb_data_o   = core_rdata_i;

endmodule
