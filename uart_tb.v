`include "defs.v"
`include "timescale.v"

module uart_tb();

reg clk, rst;
reg [7:0] tx_data;
reg tx_wr;

wire rx_ack, rx_empty, tx_busy;
wire TxD;
wire tx_clk, rx_clk;

baud_gen tx_gen(
  .clk_i(clk),
  .rst_n_i(rst),
  .baud_modulo_i(32'd31),
  .baud_clk_o(tx_clk)
);

baud_gen rx_gen(
  .clk_i(clk),
  .rst_n_i(rst),
  .baud_modulo_i(32'd01),
  .baud_clk_o(rx_clk)
);


uart_rx urx(
  .clk_i(rx_clk),
  .rst_n_i(rst),
  .RxD_i(TxD),
  .RX_ack_o(rx_ack),
  .RX_empty_o(rx_empty)
);

uart_tx utx(
  .clk_i(tx_clk),
  .rst_n_i(rst),
  .TxD_o(TxD),
  .TX_busy_o(tx_busy),
  .data_i(tx_data),
  .wr_i(tx_wr)
);


`GEN_CLK(clk, 20)

initial begin
  $dumpfile("uart.vcd");
  $dumpvars(0, uart_tb); 
end



initial begin
  rst = 1;
  #50;
  rst = 0;
  #100;
  rst = 1;

  tx_data = 8'b1010_1010;
  tx_wr = 1;
  //#3000;
  //tx_wr = 0;

  #60000;
  $finish;
end


endmodule
