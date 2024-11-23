module IPU(
    // inputs
    input iCLK,
    input iRST,
    input iDVAL,
    input	[11:0]	iRed,
    input	[11:0]	iGreen,
    input	[11:0]	iBlue,
    input [10:0] iX_Cont,
    input [10:0] iY_Cont,

    // outputs
    output [10:0] oRow,
    output [10:0] oCol,
    output oDVAL
);

logic [11:0] filterRed;
logic [11:0] filterGreen;
logic [11:0] filterBlue;
logic filterDVAL;

// logic [10:0] gd_X;
// logic [10:0] gd_Y;

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
    .iColor(filterRed),
    .iDVAL(filterDVAL),
    .iCLK(iCLK),
    .iRST(iRST),
    .oRow(oRow),
    .oCol(oCol),
    .oVALID_COORD(oDVAL)
);

endmodule