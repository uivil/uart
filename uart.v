`include "defs.v"

module uart(
  input pad_clk, pad_rst_n,

//  output tx, int_tx, int_rx,

//  input RxD,
//  output TxD,
//
  output rdempty_i,

//  output rdfull_i,
//  output wrempty_i,
//  output wrfull_i,
//
//  output rdempty_o,
//  output rdfull_o,
//  output wrempty_o,
//
  output wrfull_o,
  output rx_ack_o,
  output [6:0] HEX0, HEX1, HEX2, HEX3
);

wire TxD;
wire rst_n;
wire rx_ack, tx_busy, rx_empty;

wire tx_clk, rx_clk;
wire [7:0] rx_data, tx_data;
wire[7:0] host2jtag_data, jtag2host_data;


assign rx_ack_o = rx_ack;

reset_sync rs
(
  .rst_n(rst_n),
  .clk(pad_clk), 
  .asyncrst_n(pad_rst_n)
);

SEG7_LUT_4 hd
(
  .iDIG({host2jtag_data, jtag2host_data}),
  .HEX0(HEX0),
  .HEX1(HEX1),
  .HEX2(HEX2),
  .HEX3(HEX3)
);



jtag_iface ji
(
  .rd_clk_i(tx_clk),
  .wr_clk_i(rx_clk),
  .data_i(rx_data),
  .wr_i(rx_ack),
  .rd_i(!tx_busy && !rdempty_i),
  .host2jtag_data(host2jtag_data),
  .jtag2host_data(jtag2host_data),

  .rdempty_i(rdempty_i),
//  .rdfull_i(rdfull_i),
//  .wrempty_i(wrempty_i),
//  .wrfull_i(wrfull_i),
//  .rdempty_o(rdempty_o),
//  .rdfull_o(rdfull_o),
//  .wrempty_o(wrempty_o),
  .wrfull_o(wrfull_o)
);


baud_gen tx_gen
(
  .clk_i(pad_clk),
  .rst_n_i(rst_n),
  .baud_modulo_i(32'd5216),
  .baud_clk_o(tx_clk)
);

baud_gen rx_gen
(
  .clk_i(pad_clk),
  .rst_n_i(rst_n),
  .baud_modulo_i(32'd326),
  .baud_clk_o(rx_clk)
);


uart_rx urx
(
  .clk_i(rx_clk),
  .rst_n_i(rst_n),
  .RxD_i(TxD),
  .RX_ack_o(rx_ack),
  .RX_empty_o(rx_empty),
  .data_o(rx_data)
);

uart_tx utx
(
  .clk_i(tx_clk),
  .rst_n_i(rst_n),
  .TxD_o(TxD),
  .TX_busy_o(tx_busy),
  .data_i(host2jtag_data),
  .wr_i(!rdempty_i)
);



endmodule
