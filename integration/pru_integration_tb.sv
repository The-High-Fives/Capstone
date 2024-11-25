module pru_integration_tb;

    logic clk;
    logic rst_n;
    logic VGA_CTRL_CLK, VGA_Read;
    logic bl_stall;
    logic [3:0] bl_strobe;
    cpu_pru DUT (.clk(clk),.rst_n(rst_n),.VGA_CTRL_CLK(VGA_CTRL_CLK),
    .VGA_Read(VGA_Read),.bl_stall(bl_stall),.bl_strobe(bl_strobe));


        // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    initial begin
        VGA_CTRL_CLK = 0;
        forever #10 VGA_CTRL_CLK = ~VGA_CTRL_CLK;  
    end


    initial begin
        rst_n = 0;
        bl_stall = 0;
        bl_strobe = 0;
        VGA_Read = 0;
        
        repeat (2) @ (posedge clk) begin
        rst_n = 1;
        end
        repeat (200)@ (posedge clk) begin 
        rst_n = 1;
        end
        repeat (1000000)@ (posedge clk) begin 
        VGA_Read = 1;
        end
        $stop();
    end
endmodule