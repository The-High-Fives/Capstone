module timer (
    // bus signals
    input write_i,
    input read_i,
    input [31:0] addr_i,
    input [31:0] data_i,
    inout [31:0] data_o,
    inout ack_o
);

    localparam addr_offset = 30'h10000000; // 40000000

    logic [9:0] led;
    assign LEDR = led;

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            led <= 0;
        else if (cs & write_i)
            led <= data_i[9:0];
    end

    assign ack_o = cs ? 1'b1 : 1'bz;
    assign data_o = cs ? {22'hFFFFFF, led} : 32'hzzzzzzzz;
endmodule