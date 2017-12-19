module SEG7_LUT_4 (	HEX0,HEX1,HEX2,HEX3,iDIG );
input	[15:0]	iDIG;
output	[6:0]	HEX0,HEX1,HEX2,HEX3;

SEG7_LUT	u0	(	HEX0,iDIG[3:0]		);
SEG7_LUT	u1	(	HEX1,iDIG[7:4]		);
SEG7_LUT	u2	(	HEX2,iDIG[11:8]	);
SEG7_LUT	u3	(	HEX3,iDIG[15:12]	);

endmodule
