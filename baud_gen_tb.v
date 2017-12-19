`include "defs.v"
`include "timescale.v"

module baud_gen_tb();

wire baud_clk;
reg sys_clk, rst_n;

baud_gen bg(
  .sys_clk_i(sys_clk),
  .rst_n_i(rst_n),
  .baud_modulo_i(15'd10),
  .baud_clk_o(baud_clk)
);

`GEN_CLK(sys_clk, 20)

initial begin
  $dumpfile("baud_gen.vcd");
  $dumpvars(0, baud_gen_tb); 
end

initial begin
  rst_n = 0;
  #200;
  rst_n = 1;
  #10000;
  $finish;
end


endmodule
