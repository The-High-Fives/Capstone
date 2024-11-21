module IPU(
    // inputs
    input iCLK;
    input iRST;
    input iDVAL;
    input	[11:0]	iRed,
    input	[11:0]	iGreen,
    input	[11:0]	iBlue,
    input [10:0] iX_Cont;
    input [10:0] iY_Cont;

    // outputs
    output [10:0] oX;
    output [10:0] oY;
    output oDVAL;
);

logic [11:0] filterRed;
logic [11:0] filterGreen;
logic [11:0] filterBlue;
logic filterDVAL;

logic [10:0] gd_X;
logic [10:0] gd_Y;

reg [10:0] avg_X;
reg [10:0] avg_Y;

color_filter_unified u_color_filter_unified (
    .iX_Cont(iX_Cont),
    .iY_Cont(iY_Cont),
    .iRed(iRed),
    .iGreen(iGreen),
    .iBlue(iBlue),
    .iDVAL(iDVAL),
    .iCLK(iCLK),
    .iRST(iRST),
    .oRed(filterRed),
    .oGreen(filterGreen),
    .oBlue(filterBlue),
    .oDVAL(filterDVAL)
);

group_detection u_group_detection (
    .iX_Cont(iX_Cont),
    .iY_Cont(iY_Cont),
    .iColor(filterRed),
    .iDVAL(filterDVAL),
    .iCLK(iCLK),
    .iRST(iRST),
    .oX(gd_x),
    .oY(gd_Y),
    .oDVAL(oDVAL)
);

always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        avg_X <= 0;
        avg_Y <= 0;
    end else if (oDVAL) begin
        avg_X <= gd_X;
        avg_Y <= gd_Y;
    end
end

assign oX = avg_X;
assign oY = avg_Y;

endmodule