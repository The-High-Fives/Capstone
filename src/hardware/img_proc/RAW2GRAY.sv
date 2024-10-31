module RAW2GRAY (oRed,
				 oGreen,
				 oBlue,
				 oDVAL,
				 iX_Cont,
				 iY_Cont,
				 iDATA,
				 iDVAL,
				 iCLK,
				 iRST
				 );

input	[10:0]	iX_Cont;
input	[10:0]	iY_Cont;
input	[11:0]	iDATA;
input			iDVAL;
input			iCLK;
input			iRST;
output	[11:0]	oRed;
output	[11:0]	oGreen;
output	[11:0]	oBlue;
output			oDVAL;
wire	[11:0]	mDATA_0;
wire	[11:0]	mDATA_1;
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[13:0]	mCCD;
reg				mDVAL;
reg				mDVAL_pipe;

// copy value to R, G, B lines
assign	oRed	=	mCCD[13:2];
assign	oGreen	=	mCCD[13:2];
assign	oBlue	=	mCCD[13:2];

assign	oDVAL	=	mDVAL_pipe;

line_buffer_param u_line_buffer_param (
	.clk(iCLK),
	.rst_n(iRST),
	.en(iDVAL),	// shift if high
	.d_shift_in(mDATAd_0),
	.d_out_0(mDATA_0), // first in
	.d_out_1(mDATA_1)	// second in
);

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		mCCD <= 0;
		mDATAd_0<=	0;
		mDATAd_1<=	0;
		mDVAL	<=	0;
		mDVAL_pipe <= 0;
	end
	else
	begin
		if (iDVAL) begin
			mDATAd_0	<=	mDATAd_1;
			mDATAd_1	<=	iDATA;
		end
		mDVAL		<=	(iX_Cont[0] & iY_Cont[0]) ? iDVAL: 1'b0; // set dval on odd pixels
		mDVAL_pipe <= mDVAL;
		mCCD <= (mDATA_0+mDATAd_0+mDATA_1+mDATAd_1); // add four bayer values
	end
end

endmodule		

