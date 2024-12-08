// wraps IPU to work with bus interface
module IPU_wrapper (
    input camera_clk, 
    input sys_clk,
    input rst_n, 
    input w_rst_n,

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
    inout ack_o,

    // debug
    output logic [9:0] debug_row, 
    output logic [9:0] debug_col
);

    localparam addr_offset = 32'h40000200;

    logic [9:0] row;
    logic [9:0] col;
    logic valid;
    logic present;

    wire [10:0] oRow, oCol;
    wire [20:0] fifo_out;
    wire o_empty;
    wire cs;

    IPU u_IPU (
        // inputs
        .iCLK       (camera_clk),
        .iRST       (w_rst_n),
        .iDVAL      (iDVAL),
        .iRed       (iRed),
        .iGreen     (iGreen),
        .iBlue      (iBlue),
        .iX_Cont    (iX_Cont),
        .iY_Cont    (iY_Cont),
        // outputs
        .oRow       (oRow),
        .oCol       (oCol),
        .oDVAL      (oDVAL),
        .oPresent   (oPresent)
    );

    async_fifo 
    #(
        .width(21),
        .depth(4)
    )
    u_async_fifo (
        .i_wclk      (camera_clk),
        .i_rclk      (sys_clk),
        .i_wr        (oDVAL),
        .i_rd        (!o_empty),
        .i_wdata     ({oPresent, oRow[9:0], oCol[9:0]}),
        .i_wrst_n    (w_rst_n),
        .i_rrst_n    (rst_n),
        .o_rdata     (fifo_out),
        .o_empty     (o_empty),
        .o_full      (o_full)
    );

    always_ff @(posedge sys_clk, negedge rst_n) begin
        if (!rst_n) begin
            col <= 0;
        end
        else if (!o_empty) begin
            col <= fifo_out[9:0];
        end
    end

    always_ff @(posedge sys_clk, negedge rst_n) begin
        if (!rst_n) begin
            row <= 0;
        end
        else if (!o_empty) begin
            row <= fifo_out[19:10];
        end
    end

    always_ff @(posedge sys_clk, negedge rst_n) begin
        if (!rst_n) begin
            present <= 0;
        end
        else if (!o_empty) begin
            present <= fifo_out[20];
        end
    end


    // valid is knocked down on read
    always_ff @(posedge sys_clk, negedge rst_n) begin
        if (!rst_n) begin
            valid <= 0;
        end
        else if (!o_empty) begin
            valid <= 1;
        end
        else if (cs & read_i)
            valid <= 0;
    end

    assign cs = (addr_i[31:2] == addr_offset[31:2]) & (read_i | write_i);
    
    assign data_o = cs ? {10'h000, row, col, present, valid} : 32'hzzzzzzzz;
    assign ack_o = cs ? 1'b1 : 1'bz;

    // debug
    always @(posedge camera_clk or negedge rst_n) begin
        if (!rst_n) begin
            debug_row <= 0;
            debug_col <= 0;
        end 
        else if (cs & read_i & present) begin
            debug_row <= data_o[21:12];
            debug_col <= data_o[11:2];
        end
     end
endmodule