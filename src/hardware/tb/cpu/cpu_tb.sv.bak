module cpu_tb ();
    logic clk, rst_n;
    logic [31:0] b_addr_o;  // bus r/w address
    logic [31:0] b_data_i;  // bus data input
    logic [31:0] b_data_o;  // bus data output
    logic b_read_o;         // bus read
    logic b_write_o;        // bus write
    logic b_ack_i;          // bus acknowledgement signal


    cpu uut (
        .clk(clk),
        .rst_n(rst_n)
        .b_addr_o(b_addr_o),
        .b_data_i(b_data_i),
        .b_data_o(b_data_o),
        .b_read_o(b_read_o),
        .b_write_o(b_write_o),
        .b_ack_i(b_ack_i)
    );

    initial begin
        // Apply reset
        clk = 0;
        rst_n = 0;
        #10;
        rst_n = 1;
        
        repeat(1000) @(posedge clk);
    
        #100 
        $stop();
      end

    initial begin
        $monitor("Time: %0d, PC: %0h, Instr: %0h",
                 $time, uut.u_fetch.PC_IFID_in, uut.u_fetch.instruction_IFID_in);
    end

    always 
        #20 clk = ~clk;

endmodule