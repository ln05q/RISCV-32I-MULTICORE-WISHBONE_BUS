module timer_hex_display (
    input  wire [31:0] timer_input,  // Giá trị 32-bit từ Timer truyền vào
    output wire [ 6:0] HEX6,         // LED hàng đơn vị
    output wire [ 6:0] HEX7          // LED hàng chục
);

  wire [3:0] tens;
  wire [3:0] unit;

  // --- Tách số hàng chục và hàng đơn vị ---
  // Sử dụng 7-bit thấp là đủ để xử lý giá trị đến 99
  assign tens = timer_input[6:0] / 10;
  assign unit = timer_input[6:0] % 10;

  // --- Khối giải mã hàng đơn vị ---
  hex_decoder_core seg0 (
      .bin_in (unit),
      .seg_out(HEX6)
  );

  // --- Khối giải mã hàng chục ---
  hex_decoder_core seg1 (
      .bin_in (tens),
      .seg_out(HEX7)
  );

endmodule

// Module Core giải mã 4-bit Binary sang 7-segment (Decimal 0-9)
module hex_decoder_core (
    input  wire [3:0] bin_in,
    output reg  [6:0] seg_out
);
  always @(*) begin
    case (bin_in)
      4'd0: seg_out = 7'b1000000;  // 0
      4'd1: seg_out = 7'b1111001;  // 1
      4'd2: seg_out = 7'b0100100;  // 2
      4'd3: seg_out = 7'b0110000;  // 3
      4'd4: seg_out = 7'b0011001;  // 4
      4'd5: seg_out = 7'b0010010;  // 5
      4'd6: seg_out = 7'b0000010;  // 6
      4'd7: seg_out = 7'b1111000;  // 7
      4'd8: seg_out = 7'b0000000;  // 8
      4'd9: seg_out = 7'b0010000;  // 9
      default: seg_out = 7'b1111111;  // Tắt hết thanh LED
    endcase
  end
endmodule
