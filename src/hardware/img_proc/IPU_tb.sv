module IPU_tb ();

    // inputs
    logic clk, rst;
    logic dVAL;
    logic	[11:0]	red,
    logic	[11:0]	greed,
    logic	[11:0]	blue,
    logic [10:0] iX_Cont;
    logic [10:0] iY_Cont;

    // outputs
    logic [10:0] avg_X;
    logic [10:0] avg_Y;
    logic valid;

    IPU dut(
        .iCLK(clk),
        .iRST(rst),
        .iDVAL(dVAL),
        .iRed(red),
        .iGreen(green),
        .iBlue(blue),
        .iX_Cont(iX_Cont),
        .iY_Cont(iY_Cont),
        .oX(avg_X),
        .oY(avg_Y),
        .oDVAL(valid)
    );

    initial begin 
        clk = 0;
        forever #5 clk = ~clk;
    end
    

endmodule