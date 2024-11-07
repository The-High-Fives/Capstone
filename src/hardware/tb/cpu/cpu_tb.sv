module cpu_tb ();
    logic clk, rst_n;
    
    cpu uut (
        .clk(clk),
        .rst_n(rst_n)
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