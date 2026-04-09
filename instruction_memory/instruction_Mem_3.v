module instruction_Mem_3 (
    input [31:0] addr,
    output reg [31:0] inst
);
  reg [31:0] i_mem[63:0];

  initial begin
    $readmemb(
        "C:/Users/Admin/vivado_project/source/Testing_project_wb_soc/uart_slave_4/prog_core3.txt",
        i_mem);
  end


  always @(*) begin
    inst = i_mem[addr[31:2]];
  end

endmodule
