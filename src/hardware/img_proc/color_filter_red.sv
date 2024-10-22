
module color_filter (
				oRed,
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
reg		[11:0]	mCCD_R;
reg		[12:0]	mCCD_G;
reg		[11:0]	mCCD_B;
reg 	[11:0] 	mRed;
reg 	[12:0] 	mGreen;
reg 	[11:0] 	mBlue;
reg				mDVAL;

assign	oRed	=	mCCD_R[11:0];
assign	oGreen	=	mCCD_G[12:1];
assign	oBlue	=	mCCD_B[11:0];
assign	oDVAL	=	mDVAL;

Line_Buffer1 	u0	(	.clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						.taps0x(mDATA_1),
						.taps1x(mDATA_0)	);

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		mCCD_R	<=	0;
		mCCD_G	<=	0;
		mCCD_B	<=	0;
		mDATAd_0<=	0;
		mDATAd_1<=	0;
		mDVAL	<=	0;
	end
	else
	begin
		mDATAd_0	<=	mDATA_0;
		mDATAd_1	<=	mDATA_1;
		mDVAL		<=	{iY_Cont[0]|iX_Cont[0]}	?	1'b0	:	iDVAL;
		if({iY_Cont[0],iX_Cont[0]}==2'b10)
		begin
			mRed	<=	mDATA_0;
			mGreen	<=	mDATAd_0+mDATA_1;
			mBlue	<=	mDATAd_1;
		end	
		else if({iY_Cont[0],iX_Cont[0]}==2'b11)
		begin
			mRed	<=	mDATAd_0;
			mGreen	<=	mDATA_0+mDATAd_1;
			mBlue	<=	mDATA_1;
		end
		else if({iY_Cont[0],iX_Cont[0]}==2'b00)
		begin
			mRed	<=	mDATA_1;
			mGreen	<=	mDATA_0+mDATAd_1;
			mBlue	<=	mDATAd_0;
		end
		else if({iY_Cont[0],iX_Cont[0]}==2'b01)
		begin
			mRed	<=	mDATAd_1;
			mGreen	<=	mDATAd_0+mDATA_1;
			mBlue	<=	mDATA_0;
		end

		if(mRed > 600 && mGreen[12:1] + mBlue < mRed && mRed + mGreen[12:1] + mBlue > 600 && mRed + mGreen[12:1] + mBlue < 8000)
		begin
			mCCD_R	<=	mRed;
			mCCD_G	<=	0;
			mCCD_B	<=	0;
		end
		else
		begin
			mCCD_R	<=	12'hFFF;
			mCCD_G	<=	13'h1FFF;
			mCCD_B	<=	12'hFFF;
		end
	end
end

endmodule


