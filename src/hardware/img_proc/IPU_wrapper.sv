// wraps IPU to work with bus interface
module IPU_wrapper (
    input clk, 
    input rst_n, 

    // RGB input
    input iDVAL,
    input [11:0] iRed,
    input [11:0] iGreen,
    input [11:0] iBlue,

    // bus
    input write_i,
    input read_i,
    input [31:0] addr_i,
    input [31:0] data_i,
    inout [31:0] data_o,
    inout ack_o
);

    localparam addr_offset = 30'h00000000;

    logic [9:0] row;
    logic [9:0] col;
    logic valid;
    logic present;

    wire [10:0] oRow, oCol;

    IPU u_IPU (
        // inputs
        .iCLK       (clk),
        .iRST       (rst_n),
        .iDVAL      (iDVAL),
        .iRed       (iRed),
        .iGreen     (iGreen),
        .iBlue      (iBlue),
        .iX_Cont    (iX_Cont),
        .iY_Cont    (iY_Cont),
        // outputs
        .oRow       (oRow),
        .oCol       (oCol),
        .oDVAL      (oDVAL)
    );

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            row <= 0;
            col <= 0;
            present <= 1;
        end
        else if (oDVAL) begin
            row <= oRow[9:0];
            col <= oCol[9:0];
            // present <= 0;
        end
    end

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            valid <= 0;
        end
        else if (oDVAL) begin
            valid <= 1;
        end
        else if (cs & read_i)
            valid <= 0;
    end

    assign cs = (addr_i[31:2] == addr_offset);
    
    assign data_o = cs ? {10'h000, row, col, present, valid} : 32'hzzzzzzzz;
    assign ack_o = cs ? 1'b1 : 1'bz;
endmodule