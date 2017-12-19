`include "defs.v"


module uart_tx
(
  input[7:0] data_i,
  input wr_i,
  input clk_i, rst_n_i,
  output TxD_o, TX_busy_o
);

reg[9:0] tx_r;
reg[3:0] tx_cnter;
reg[3:0] state, next;

wire tx_load = (state == ST_WRITE);
wire tx_shift = (state == ST_SEND);

always @ (posedge clk_i, negedge rst_n_i)
  if (~rst_n_i) begin
    tx_r <= 10'h200;
    tx_cnter <= 'b0;
  end
  else if (tx_load) begin
    tx_r <= {1'b0, data_i, 1'b1};
    tx_cnter <= 'b0;
  end 
  else if (tx_shift) begin
    tx_r <= {tx_r[8:0], 1'b1};
    tx_cnter <= tx_cnter + 'b1;
  end


parameter[3:0]  ST_IDLE   = 4'b0001,
                ST_DONE   = 4'b0010,
                ST_WRITE  = 4'b0100,
                ST_SEND   = 4'b1000;

always @(negedge clk_i)
  if (~rst_n_i) state <= ST_IDLE;
  else          state <= next;

always @* begin
  next = state;
  case (state)
    ST_IDLE: if (wr_i)  next = ST_WRITE;
    
    ST_WRITE: next = ST_SEND;

    ST_SEND: if (tx_cnter == 'd9) next = ST_DONE;
    
    ST_DONE: if (wr_i) next = ST_WRITE;
  endcase
end



assign TX_busy_o = (state == ST_SEND);
assign TxD_o = tx_r[9];

endmodule
