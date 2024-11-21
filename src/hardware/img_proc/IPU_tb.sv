module IPU_tb ();

    // inputs
    logic clk, rst_n;
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
        .iRST(rst_n),
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
    initial begin
        rst_n = 0;
        dVAL = 0;
        red = 0;
        green = 0;
        blue = 0;
        iX_Cont = 0;
        iY_Cont = 0;

        repeat (10) @(posedge clk);
        rst_n = 1;

        repeat (480) begin
            repeat (640) @(posedge clk) begin
                dVAL = 1;
                red = 12'hFFF;
                green = 12'h000;
                blue = 12'h000;
                iX_Cont = iX_Cont + 1;
            end
            iX_Cont = 0;
            iY_Cont = iY_Cont + 1;
        end
    end


endmodule