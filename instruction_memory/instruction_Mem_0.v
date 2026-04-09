module instruction_Mem_0 (
    input [31:0] addr,
    output reg [31:0] inst
);
  reg [31:0] i_mem[63:0];

  initial begin
    $readmemb(
        "C:/Users/Admin/vivado_project/source/Testing_project_wb_soc/ram_slave_0/prog_core0.txt",
        i_mem);
  end

  always @(*) begin
    inst = i_mem[addr[31:2]];
  end

endmodule
