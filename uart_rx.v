`include "defs.v"

module uart_rx 
(
  input clk_i, rst_n_i, RxD_i,
  output [7:0] data_o,
  output RX_ack_o, RX_empty_o
);

/**********************************/
reg [8:0] rx_r;

/**********************************/
reg[4:0] state, next;
parameter[4:0]  ST_IDLE    		  = 5'b00001,
                ST_BIT2BIT    	= 5'b00010,
                ST_SAMPLE 			= 5'b00100,
                ST_SAMPLE_DONE 	= 5'b01000,
                ST_BIT2BIT_DONE = 5'b10000;

/**********************************/

always @(negedge clk_i, negedge rst_n_i) begin
  if (~rst_n_i)         state <= ST_IDLE;
  else                  state <= next;
end

`define FRAME_END (data_cnter_r == 'd10)

always @* begin
  next = state;
  case (state)
    ST_IDLE:  if (~RxD_i) next = ST_BIT2BIT;

    ST_SAMPLE_DONE: if (`FRAME_END)  next = ST_BIT2BIT_DONE; 
                    else             next = ST_SAMPLE;

    ST_BIT2BIT_DONE: if (~RxD_i) next = ST_SAMPLE; 
								     else        next = ST_IDLE;


    ST_SAMPLE: 	if (`FRAME_END)                   next = ST_BIT2BIT_DONE; 
						     else if (sample_cnter_r == 'hf)  next = ST_SAMPLE_DONE;

    ST_BIT2BIT:	if (sample_cnter_r == 'd6 && ~RxD_i) 	next = ST_SAMPLE_DONE; 
						     else if (RxD_i)            				  next = ST_BIT2BIT_DONE;

    default:  next = ST_IDLE;
  endcase
end


reg [3:0] sample_cnter_r; // 16 samples
reg [3:0] data_cnter_r;
reg [2:0] delay_cnter_r;


wire sample_cnter_rst = (state == ST_IDLE || state == ST_BIT2BIT_DONE || state == ST_SAMPLE_DONE);
wire sample_cnter_inc = (state == ST_SAMPLE || state == ST_BIT2BIT);

wire data_cnter_rst = (state == ST_IDLE || state == ST_BIT2BIT_DONE);
wire data_cnter_inc = (state == ST_SAMPLE_DONE);

//wire delay_cnter_inc = (state == ST_START);
//wire delay_cnter_rst = (state == ST_IDLE || state == ST_DONE);

wire rx_rst = (state == ST_BIT2BIT);
wire rx_shift = (state == ST_SAMPLE_DONE); //|| sample_cnter_r == 'd1));

always @ (posedge clk_i)
  if (rx_rst)         rx_r <= 'b0;
  else if (rx_shift)  rx_r <= {rx_r[7:0], RxD_i};

//always @ (posedge clk_i)
//  if (delay_cnter_rst)      delay_cnter_r <= 'b0;
//  else if (delay_cnter_inc) delay_cnter_r <= delay_cnter_r + 'b1;

always @ (posedge clk_i) 
  if (data_cnter_rst)       data_cnter_r <= 'b0;
  else if (data_cnter_inc)  data_cnter_r <= data_cnter_r + 'b1;

always @ (posedge clk_i)
  if (sample_cnter_rst)      sample_cnter_r <= 'b0;
  else if (sample_cnter_inc) sample_cnter_r <= sample_cnter_r + 'b1;



    // if rx == 0 start sampling
    // count up to 7, the middle position of the start bit
    // reset the counter
    // count up to 15, up to the middle position of the first data bit
    // repeat N-1 times (N=8)
    // repeat once more for the parity bit
    // repat once more for the stop bit
    //

assign RX_ack_o = (state == ST_BIT2BIT_DONE);
assign data_o 	= rx_r[8:1];
assign RX_empty_o = ~|data_o;

endmodule
