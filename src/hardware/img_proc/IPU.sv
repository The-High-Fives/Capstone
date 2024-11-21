module IPU(
    // inputs
    input iCLK;
    input iRST;
    input iDVAL;
    input [11:0] iDATA;
    input [10:0] iX_Cont;
    input [10:0] iY_Cont;

    // outputs
    output [10:0] avg_X;
    output [10:0] avg_Y;
    output valid;
);

endmodule