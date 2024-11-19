module group_detection (
    iColor,
    iDVAL,
    iX_Cont,
    iY_Cont,
    iCLK,
    iRST,
    oX,
    oY,
    oDVAL
);

input [11:0] iColor;
input iDVAL;
input [10:0] iX_Cont;
input [10:0] iY_Cont;
input iCLK;
input iRST;

output [10:0] oX;
output [10:0] oY;
output oDVAL;

localparam threshold = 12'h7FF;

localparam endX = 640;
localparam endY = 480;

reg [10:0] prevTotalRow;
reg [10:0] prevTotalCol;

reg [20:0] prevTotalX;
reg [10:0] prevTotalY;

reg [20:0] totalX;
reg [10:0] prevXCount;
reg [10:0] xCount;
reg [10:0] totalY;

assign totalX = iColor > threshold ? iX_Cont + prevTotalX : 0;
assign totalY = iColor > threshold ? 1 + prevTotalY : 0;
assign xCount = iColor > threshold ? 1 + prevXCount : 0;

always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        prevTotalRow <= 0;
        prevTotalCol <= 0;
        prevTotalX <= 0;
        prevTotalY <= 0;
    end else if (iDVAL) begin
        prevTotalRow <= iY_Cont == endY - 1 ? (prevTotalRow * iY_Cont + totalY) / (iY_cont + 1) : prevTotalRow;

        prevTotalCol <= iX_Cont == endX - 1 ? (prevTotalCol * iY_Cont + (totalX / xCount)) / (iY_Cont + 1) : prevTotalCol;

        prevTotalX <= totalX;
        prevTotalY <= totalY;
    end
end

assign oDVAL = iY_Cont == endY - 1 && iX_Cont == endX - 1 && iDVAL ? 1 : 0;
assign oX = iY_Cont == endY - 1 && iX_Cont == endX - 1 && iDVAL ? prevTotalCol : 0;
assign oY = iY_Cont == endY - 1 && iX_Cont == endX - 1 && iDVAL ? prevTotalRow : 0;


endmodule