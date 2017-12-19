// http://www.sunburst-design.com/papers/CummingsSNUG2003Boston_Resets.pdf
//

module reset_sync (
  output 		rst_n,
  input      clk, asyncrst_n
);

  reg        rff1;
  reg				rst;
  always @(posedge clk or negedge asyncrst_n)
    if (!asyncrst_n) {rst,rff1} <= 2'b0;
    else             {rst,rff1} <= {rff1,1'b1};

	 assign rst_n = rst;
endmodule