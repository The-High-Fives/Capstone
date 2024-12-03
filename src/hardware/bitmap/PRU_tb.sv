module PRU_tb;
    // Testbench signals
    logic clk;
    logic rst_n;
    logic [31:0] data;                  // Data input to PRU_Preprocessing
    logic [1:0] color;
    logic [8:0] row;
    logic [9:0] col;
    logic [9:0] width, PRU_RED, PRU_GREEN, PRU_BLUE;
    logic [8:0] height_radius;
    logic [1:0] shape_select;
    logic start, write, subtract, color_load, VGA_CTRL_CLK, VGA_Read;
    logic busy, done, ack;
    logic [31:0] pru_addr, pru_data, bitmap_address;
    logic [1:0] color_map [2499:0];    // 50 x 50 = 2500

    // Instantiate the PRU_Preprocessing module
    PRU_Preprocessing preprocessor (
        .clk(clk),
        .rst_n(rst_n),
		.write(write),
        .data(data),
        .color(color),
        .row(row),
        .col(col),
        .width(width),
		.bitmap_address(bitmap_address),
        .height_radius(height_radius),
        .shape_select(shape_select),
        .start(start),
        .subtract(subtract),
        .color_load(color_load),
        .VGA_CTRL_CLK(VGA_CTRL_CLK),
        .VGA_Read(VGA_Read),
		.ack()
    );

    // Instantiate the PRU module
    PRU dut (
        .clk(clk),
        .rst_n(rst_n),
        .color(color),
        .row(row),
        .col(col),
        .width(width),
        .height_radius(height_radius),
        .pru_addr(pru_addr),
        .pru_data(pru_data),
		.bitmap_address(bitmap_address),
        .shape_select(shape_select),
        .start(start),
        .subtract(subtract),
        .busy(busy),
        .done(done),
        .color_load(color_load),
        .VGA_CTRL_CLK(VGA_CTRL_CLK),
        .VGA_Read(VGA_Read),
		.pru_red(PRU_RED),
        .pru_green(PRU_GREEN),
        .pru_blue(PRU_BLUE)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize signals
		write = 0;
        rst_n = 0;
        data = 32'h0;
		pru_data = 32'h0000;
		pru_addr = 32'h0000;
        // Apply reset
        repeat (2) @(posedge clk);
        rst_n = 1;

        // Test rectangle input
        $display("Testing rectangle...");
				//-----------ss-color---col------row
		data = 32'b000000000_00_01_0000001010_000001010;
		write = 1;
		repeat (1) @(posedge clk);
		write = 0;
		//-----------------------cl--sub-width------height_radius
		data = 32'b000000000000_0_0000001111_000001111;
		repeat (1) @(posedge clk);
		write = 1;	
		repeat (1) @(posedge clk);
		write = 0;		

        repeat (1) @(posedge done);
		repeat (1) @(posedge clk);
		display_color_map(0, 0, 30, 30);
        // Test circle input
        $display("Testing circle...");
				
					//-----------ss-color---col------row
		data = 32'b000000000_01_10_0000011110_000011110;
		write = 1;
        repeat (1) @(posedge clk);
		write = 0;
		//-----------------------cl--sub-width------height_radius	
        data = 32'b000000000000_0_0000001010_000001010;
		

        repeat (1) @(posedge clk);
		write = 1;	
		repeat (1) @(posedge clk);
		write = 0;		

        repeat (10000) @(posedge clk);
		display_color_map(0, 0, 50, 50);
		$display("Testing bitmap...");
		
		//-----------ss-color---col------row
		data = 32'b000000000_10_11_0000001010_000001010;
		write = 1;
        repeat (1) @(posedge clk);
		write = 0;
				//-------------BITMAP_ADDRESS------
				//32'h00000000;
        data = 32'h0000_0000;
        repeat (1) @(posedge clk);
		write = 1;	
		repeat (1) @(posedge clk);
		write = 0;		

        repeat (10000) @(posedge clk);
		display_color_map(0, 0, 50, 50);
        // End simulation
        $stop;
    end

    // Task to display a section of the color_map array as 2D
    task display_color_map(input int x_start, input int y_start, input int x_end, input int y_end);
        integer x, y;
        integer index;
        for (y = y_start; y < y_end; y = y + 1) begin
            for (x = x_start; x < x_end; x = x + 1) begin
                index = y * 50 + x;
                $write("%0d ", dut.color_map.imagebuffer[index]);
            end
            $display("");
        end
    endtask
endmodule
