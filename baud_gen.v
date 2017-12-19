`include "defs.v"

module baud_gen
(
  input clk_i, rst_n_i,
  // set baud rate 
  //
  input[WIDTH-1:0] baud_modulo_i, // sys_clk_i / baud_rate
  output baud_clk_o
);
//localparam WIDTH = $clog2(`B19200);
localparam WIDTH = 32;

/**************************************/

// generate clock
// RX/TX clk = sys_clk / baudrate
reg [WIDTH-1:0] baud_cnter_r;
reg baud_clk;
//always @ (posedge sys_clk_i, negedge rst_n_i) begin
always @ (posedge clk_i) begin
  if (~rst_n_i)  begin
    baud_cnter_r <= 0;
    baud_clk <= 0;
  end else 
  if (baud_cnter_r == baud_modulo_i) begin
    baud_cnter_r <= 0;
    baud_clk <= ~baud_clk;
  end
  else
    baud_cnter_r <= baud_cnter_r + 1;
end
// outputs
assign baud_clk_o = baud_clk;

endmodule


