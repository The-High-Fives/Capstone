module noise_reduction (
    input iCLK,
    input iRST,
    input [11:0] iDATA,
    input iDVAL,
    output [11:0] oRed,
    output [11:0] oGreen,
    output [11:0] oBlue,
    output oDVAL,
    input [15:0] iX_Cont,
    input [15:0] iY_Cont,
    input iSW,
    input iSW2
);

// top row taps
wire	[11:0]	top_mDATA_0;
wire	[11:0]	top_mDATA_1;
wire	[11:0]	top_mDATA_2;

// middle row taps
wire	[11:0]	middle_mDATA_0;
wire	[11:0]	middle_mDATA_1;
wire	[11:0]	middle_mDATA_2;

// buffer registers
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[11:0]	mDATAd_2;

reg		[13:0]	mCCD;
reg				mDVAL;
reg				mDVAL_pipe;

wire [13:0] temp_data;

wire [14:0] sum; // intermediate deep sum
wire [3:0] sum_shallow; // intermediate shallow sum

wire [13:0] total;      // total deep sum
wire [13:0] total_shallow; // total shallow sum

// convolution
assign sum = (15'h0000 + top_mDATA_0 + top_mDATA_1 + top_mDATA_2 + middle_mDATA_0 + middle_mDATA_2 + mDATAd_0 + mDATAd_1 + mDATAd_2);
assign sum_shallow = (4'h0 
    + (top_mDATA_0 == 0 ? 0 : 1'b1)
    + (top_mDATA_1 == 0 ? 0 : 1'b1)
    + (top_mDATA_2 == 0 ? 0 : 1'b1)
    + (middle_mDATA_0 == 0 ? 0 : 1'b1)
    + (middle_mDATA_2 == 0 ? 0 : 1'b1)
    + (mDATAd_0 == 0 ? 0 : 1'b1)
    + (mDATAd_1 == 0 ? 0 : 1'b1)
    + (mDATAd_2 == 0 ? 0 : 1'b1)
);

assign total = sum > 8000 ? 14'h1FFF : 14'h0000;
assign total_shallow = sum_shallow > 8 ? 14'h1FFF : 14'h0000;

assign temp_data = iSW ? total : iSW2 ? mDATAd_2 == 0 ? 0 : 14'h1FFF : total_shallow;

assign	oRed	=	mCCD[13:2];
assign	oGreen	=	0;
assign	oBlue	=	0;
assign	oDVAL	=	mDVAL_pipe;

line_buffer_param top_row (
	.clk(iCLK),
	.rst_n(iRST),
	.en(iDVAL),	// shift if high
	.d_shift_in(middle_mDATA_0),
	.d_out_0(top_mDATA_0), // first in
	.d_out_1(top_mDATA_1),	// second in
    .d_out_2(top_mDATA_2)	// third in
);

line_buffer_param middle_row (
	.clk(iCLK),
	.rst_n(iRST),
	.en(iDVAL),	// shift if high
	.d_shift_in(mDATAd_0),
	.d_out_0(middle_mDATA_0), // first in
	.d_out_1(middle_mDATA_1),	// second in
    .d_out_2(middle_mDATA_2)	// second in
);

    always@(posedge iCLK or negedge iRST) begin
        if(!iRST)
        begin
            mCCD <= 0;
            mDATAd_0 <=	0;
            mDATAd_1 <=	0;
            mDATAd_2 <=  0;
            mDVAL	<=	0;
        end
        else
        begin
			// pipeline values
            if (iDVAL) begin
                mDATAd_0	<=	mDATAd_1;
                mDATAd_1	<=	mDATAd_2;
                mDATAd_2    <=  iDATA;
            end
			
			// valid on every other row
            mDVAL		<=	((iY_Cont != 0)) ? iDVAL : 1'b0;
            mDVAL_pipe <= mDVAL;
            mCCD <= temp_data; // apply values
        end
    end
endmodule