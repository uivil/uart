`define B9600   9600
`define B19200  19200
`define CLOCK_50 50_000_000


`define GEN_CLK(clk, period) \
  initial begin \
    clk = 0; \
    forever begin \
      #period  clk = ~clk; \
    end \
  end

