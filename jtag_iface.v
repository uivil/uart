// Adapted from https://github.com/binary-logic/vj-uart

module jtag_iface(
  input wr_clk_i, rd_clk_i, 
  input[7:0] data_i,
  input wr_i, rd_i,

  output [7:0] host2jtag_data, jtag2host_data,
  
  output rdempty_i,
  output rdfull_i,
  output wrempty_i,
  output wrfull_i,
  
  output rdempty_o,
  output rdfull_o,
  output wrempty_o,
  output wrfull_o
  
);

wire uir, cdr, sdr, udr, tck, tdi, ir_i;
// int_TXC/int_RXC/dout -> leds
// wr | rd | addr | aen | din

vjtag jtag(
	.ir_out(),
	.tdo(shift_buffer[0]),
	
	.ir_in(ir_i),
	.tck(tck),
	.tdi(tdi),
	.virtual_state_cdr(cdr),
	.virtual_state_cir(),
	.virtual_state_e1dr(),
	.virtual_state_e2dr(),
	.virtual_state_pdr(),
	.virtual_state_sdr(sdr),
	.virtual_state_udr(udr),
	.virtual_state_uir(uir)
);

reg cdr_delayed, sdr_delayed, udr_delayed;
always @ (negedge tck)
begin
	cdr_delayed <= cdr;
	sdr_delayed <= sdr;
end	

reg ir;
always @(negedge tck)
begin
	if(uir) ir <= ir_i;
end


localparam RX = 1;
localparam TX = 0;

reg[7:0] shift_buffer;
always @ (posedge tck)
begin
	case (ir) 
		TX:  if (cdr_delayed)      shift_buffer <= jtag2host_data; // data_o
				  else if(sdr_delayed)	shift_buffer <= {tdi, shift_buffer[7:1]};

		RX:  if (sdr_delayed)	    shift_buffer <= {tdi, shift_buffer[7:1]};
	endcase
end


// fifo | from jtag
fifo fifo_in(
.data(shift_buffer),
.rdclk(rd_clk_i),
.rdreq(rd_i),
.wrclk(tck),
.wrreq(udr & (ir == RX)),

.q(host2jtag_data),

.rdempty(rdempty_i),
.rdfull(rdfull_i),
.wrempty(wrempty_i),
.wrfull(wrfull_i)
);

// fifo | to jtag
fifo fifo_out(
.data(data_i),
.rdclk(tck),
.rdreq(cdr & (ir == TX)),
.wrclk(wr_clk_i),
.wrreq(wr_i),

.q(jtag2host_data),

.rdempty(rdempty_o),
.rdfull(rdfull_o),
.wrempty(wrempty_o),
.wrfull(wrfull_o)
);

endmodule
