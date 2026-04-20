module instruction_Mem_1 (
    input [31:0] addr,
    output reg [31:0] inst
);
  reg [31:0] i_mem[63:0];

  initial begin
    $readmemb("C:/Users/Admin/quartus_project/source/doan_soc/led_slave_1/prog_core1.txt", i_mem);
  end

  always @(*) begin
    inst = i_mem[addr[31:2]];
  end

endmodule
