module timer (
    // bus signals
    input write_i,
    input read_i,
    input [31:0] addr_i,
    input [31:0] data_i,
    inout [31:0] data_o,
    inout ack_o
);

    localparam addr_offset = 30'h10000001; // 0x40000004

    logic [31:0] timer;

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            timer <= 0;
        else if (cs & read_i)
            timer <= 0;
        else
            timer <= timer + 1;
    end

    assign cs = (addr_i[31:2] == addr_offset) & (read_i | write_i) & ((addr_i[1:0] == 2'b00) 
                | (addr_i[1:0] == 2'b01) | (addr_i[1:0] == 2'b10) | (addr_i[1:0] == 2'b11))
    assign ack_o = cs ? 1'b1 : 1'bz;
    assign data_o = cs ? timer : 32'hzzzzzzzz;
endmodule