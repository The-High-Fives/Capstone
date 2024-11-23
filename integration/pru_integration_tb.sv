module pru_integration_tb;

    logic clk;
    logic rst_n;
    logic VGA_CTRL_CLK, VGA_Read;
    cpu_pru DUT (.clk(clk),.rst_n(rst_n),.VGA_CTRL_CLK(VGA_CTRL_CLK),.VGA_Read(VGA_Read));


        // Clock generation
    initial begin
        clk = 0;
        VGA_CTRL_CLK = 0;
        forever #5 clk = ~clk;  // 10ns clock period
        forever #10 VGA_CTRL_CLK = ~VGA_CTRL_CLK;  
    end

    initial begin
        rst_n = 0;
    end
    
endmodule