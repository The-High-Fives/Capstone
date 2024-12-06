module led_mm (
    input clk,
    input rst_n,
    output [9:0] LEDR,

    // bus signals
    input write_i,
    input read_i,
    input [31:0] addr_i,
    input [31:0] data_i,
    inout [31:0] data_o,
    inout ack_o
);

    localparam addr_offset = 32'h40000000; // 40000000

    logic [9:0] led;
    assign LEDR = led;
    wire cs;

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            led <= 0;
        else if (cs & write_i)
            led <= data_i[9:0];
    end

    assign cs = (addr_i[31:2] == addr_offset[31:2]) & (read_i | write_i) & ((addr_i[1:0] == 2'b00) 
                | (addr_i[1:0] == 2'b01) | (addr_i[1:0] == 2'b10) | (addr_i[1:0] == 2'b11));
    assign ack_o = cs ? 1'b1 : 1'bz;
    assign data_o = cs ? {22'h000000, led} : 32'hzzzzzzzz;

endmodule