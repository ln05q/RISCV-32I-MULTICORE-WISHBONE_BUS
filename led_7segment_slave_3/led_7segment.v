module led_7segment (
    input wire        clk,
    input wire        rst,
    input wire [ 1:0] addr,  // Lấy từ cpu_addr[3:2] để phân biệt 4 ô
    input wire        we,    // Tín hiệu ghi từ CPU
    input wire [31:0] wdata, // Dữ pointer từ CPU

    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3
);

  // Thanh ghi lưu trữ giá trị cho 4 ô LED
  reg [3:0] r_hex0, r_hex1, r_hex2, r_hex3;

  // --- 1. Ghi dữ liệu dựa trên địa chỉ (Offset) ---
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      r_hex0 <= 4'h0;
      r_hex1 <= 4'h0;
      r_hex2 <= 4'h0;
      r_hex3 <= 4'h0;
    end else if (we) begin
      case (addr)
        2'b00: r_hex0 <= wdata[3:0];  // 0x3000_0000
        2'b01: r_hex1 <= wdata[3:0];  // 0x3000_0004
        2'b10: r_hex2 <= wdata[3:0];  // 0x3000_0008
        2'b11: r_hex3 <= wdata[3:0];  // 0x3000_000C
      endcase
    end
  end

  // --- 2. Bộ giải mã 7 đoạn (Common Anode - Mức 0 là sáng) ---
  function [6:0] decode(input [3:0] val);
    case (val)
      4'h0: decode = 7'b1000000;
      4'h1: decode = 7'b1111001;
      4'h2: decode = 7'b0100100;
      4'h3: decode = 7'b0110000;
      4'h4: decode = 7'b0011001;
      4'h5: decode = 7'b0010010;
      4'h6: decode = 7'b0000010;
      4'h7: decode = 7'b1111000;
      4'h8: decode = 7'b0000000;
      4'h9: decode = 7'b0010000;
      default: decode = 7'b1111111;  // Tắt hết
    endcase
  endfunction

  // Mapping ra các cổng Output nối với chân Kit DE2
  assign HEX0 = decode(r_hex0);
  assign HEX1 = decode(r_hex1);
  assign HEX2 = decode(r_hex2);
  assign HEX3 = decode(r_hex3);

endmodule
