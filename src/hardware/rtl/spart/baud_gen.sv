module baud_gen
(
    input clk,
    input rst_n,
    output enable, // 16x selected baud rate
);

    logic [15:0] counter;   // down counter

    // down counter
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) 
            counter <= 0;
        else if (counter == 0)
            counter <= 16'h00A2; // 19200 baud
        else
            counter <= counter - 1;
    end

    assign enable = counter == 0;

endmodule