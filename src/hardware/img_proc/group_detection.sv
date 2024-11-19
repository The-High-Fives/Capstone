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
input reg [10:0] iX_Cont;
input reg [10:0] iY_Cont;
input iCLK;
input iRST;

output [10:0] oX;
output [10:0] oY;
output oDVAL;

localparam threshold = 12'h700;

localparam endX = 640;
localparam endY = 480;

wire [10:0] X;
wire [10:0] Y;

reg [10:0] prevTotalRow;
reg [10:0] prevTotalCol;

reg [20:0] prevTotalX;
reg [10:0] prevTotalY;

reg [20:0] totalX;
reg [10:0] prevXCount;
reg [10:0] xCount;
reg [10:0] totalY;


assign X = iX_Cont;
assign Y = iY_Cont;

assign totalX = iColor > threshold ? X + prevTotalX : 0;
assign totalY = iColor > threshold ? 1 + prevTotalY : 0;
assign xCount = iColor > threshold ? 1 + prevXCount : 0;

always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        prevTotalRow <= 0;
        prevTotalCol <= 0;
        prevTotalX <= 0;
        prevTotalY <= 0;
    end else if (iDVAL) begin
        
        if (Y == 0 && X == 0) begin
            prevTotalRow <= 0;
            prevTotalCol <= 0;
            prevTotalX <= 0;
            prevTotalY <= 0;
        end

        if (Y == (endY - 1)) begin
            prevTotalRow <= (prevTotalRow * Y + totalY) / (Y + 1);
        end
        if (X == (endX - 1)) begin
            prevTotalCol <= (prevTotalCol * Y + (totalX / xCount)) / (Y + 1);
        end

        prevTotalX <= totalX;
        prevTotalY <= totalY;
    end
end

assign oDVAL = ((iY_Cont == (endY - 1)) && (iX_Cont == (endX - 1))) & iDVAL ? 1 : 0;
assign oX = prevTotalCol;
assign oY = prevTotalRow;


endmodule