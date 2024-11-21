module IPU_tb ();

    // inputs
    logic clk, rst;
    logic dVAL;
    logic [11:0] data;
    logic [10:0] iX_Cont;
    logic [10:0] iY_Cont;

    // outputs
    logic [10:0] avg_X;
    logic [10:0] avg_Y;
    logic valid;
endmodule