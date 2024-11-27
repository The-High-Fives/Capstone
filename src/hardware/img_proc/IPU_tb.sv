module IPU_tb ();

    // inputs
    logic iCLK, iRST;
    logic iDVAL;
    logic	[11:0]	iColor;
    logic	[11:0]	green;
    logic	[11:0]	blue;
    logic [10:0] iX_Cont;
    logic [10:0] iY_Cont;

    // outputs
    logic [10:0] avg_X;
    logic [10:0] avg_Y;
    logic valid;

    IPU dut(
        .iCLK(iCLK),
        .iRST(iRST),
        .iDVAL(iDVAL),
        .iRed(iColor),
        .iGreen(green),
        .iBlue(blue),
        .iX_Cont(iX_Cont),
        .iY_Cont(iY_Cont),
        .oRow(avg_X),
        .oCol(avg_Y),
        .oDVAL(valid)
    );

    initial begin 
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

    int row;
    int col;
    initial begin
        iRST = 0;
        blue = 0;
        green = 0;
        iCLK = 0;
        row = 0;
        col = 0;
        iDVAL = 0;
        iColor = '0;
        repeat(2) @(posedge iCLK);
        iRST = 1;
        
        repeat(400) begin
            repeat (200) begin
                @(posedge iCLK);
                iDVAL = 1;
            end
            repeat(100) begin
                @(posedge iCLK);
                iDVAL = 1;
                iColor = '1;
            end
            iColor = '0;
            repeat (180) begin
                @(posedge iCLK);
                iDVAL = 1;
            end
        end
        iColor = 0;
        repeat (134400) @(posedge iCLK);
        repeat(100) @(posedge iCLK);
        $stop();
    end
endmodule