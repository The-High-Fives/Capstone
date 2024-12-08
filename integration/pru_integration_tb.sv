module pru_integration_tb;

    logic clk;
    logic rst_n;
    logic VGA_CTRL_CLK, VGA_Read;
    logic bl_stall;
    logic [3:0] bl_strobe;
    logic [9:0] VGA_BLUE, VGA_GREEN, VGA_RED;
    cpu_pru DUT (.clk(clk),.rst_n(rst_n),.VGA_CTRL_CLK(VGA_CTRL_CLK),
    .VGA_Read(VGA_Read),.bl_stall(bl_stall),.bl_strobe(bl_strobe),
    .VGA_BLUE(VGA_BLUE),.VGA_RED(VGA_RED),.VGA_GREEN(VGA_GREEN),
    .b_ack(), .pru_start(),  .pru_done(),  .in_idle(), .in_load_2());


        // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    initial begin
        VGA_CTRL_CLK = 0;
        forever #8 VGA_CTRL_CLK = ~VGA_CTRL_CLK;  
    end


    initial begin
        rst_n = 0;
        bl_stall = 0;
        bl_strobe = 0;
        VGA_Read = 0;
        
        repeat (2) @ (posedge clk) begin
        rst_n = 1;
        end
        // repeat (200)@ (posedge clk) begin 
        // rst_n = 1;
        // end
        // repeat (10000)@ (posedge clk) begin 
        // VGA_Read = 1;
        // end


        repeat (30000)@ (posedge clk);
        display_color_map(0, 0, 125, 125);
        $display("Above is circle");
        $stop();
    end
    task display_color_map(input int x_start, input int y_start, input int x_end, input int y_end);
        integer x, y;
        integer index;
        for (y = y_start; y < y_end; y = y + 1) begin
            for (x = x_start; x < x_end; x = x + 1) begin
                index = y * 640 + x;
                $write("%0d ", DUT.DRAW.color_map.imagebuffer[index]); 
            end
            $display("");
        end
    endtask
endmodule