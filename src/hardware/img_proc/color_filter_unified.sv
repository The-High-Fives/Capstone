module color_filter_unified 
(				
    input	[10:0]	iX_Cont,
    input	[10:0]	iY_Cont,
    input	[11:0]	iRed,
    input	[11:0]	iGreen,
    input	[11:0]	iBlue,
    input			iDVAL,
    input			iCLK,
    input			iRST,
    output logic	[11:0]	oRed,
    output logic    [11:0]	oGreen,
    output logic	[11:0]	oBlue,
    output			oDVAL
);

// wire [11:0] top_l, top_c, top_r;
// wire [11:0] mid_l, mid_c, mid_r;
// logic [11:0] bot_l, bot_c, bot_r;

// line_buffer_param #(.width(640)) row_top (.clk(iCLK), .rst_n(iRST_N), .en(iDVAL), .d_shift_in(mid_r), .d_out_0(top_r), .d_out_1(top_c), .d_out_2(top_l));
// line_buffer_param #(.width(640)) row_mid (.clk(iCLK), .rst_n(iRST_N), .en(iDVAL), .d_shift_in(bot_r), .d_out_0(mid_r), .d_out_1(mid_c), .d_out_2(mid_l));

// always_ff @(posedge iCLK or negedge iRST_N) begin
//     if (!iRST_N) begin
//         bot_l <= 0;
//         bot_c <= 0;
//         bot_r <= 0;
//     end else if (iDVAL) begin
//         bot_l <= iDATA;
//         bot_c <= bot_l;
//         bot_r <= bot_c;
//     end
// end

localparam threshold = 12'h700;
function logic red_filter (logic [11:0] red, blue, green);
    return (red > threshold && blue < 12'h4FF && green < 12'h4FF);
endfunction

always_comb begin
    if (red_filter(iRed, iBlue, iGreen)) begin
        // oRed = iRed;
        oRed = 12'hFFF;
        oGreen = 12'h000;
        oBlue = 12'h000;
    end else begin
        oRed = 0;
        oGreen = 0;
        oBlue = 0;
    end
end

assign oDVAL = iDVAL;

endmodule

