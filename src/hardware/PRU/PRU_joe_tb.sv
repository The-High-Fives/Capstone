module PRU_tb;
    // Testbench signals
    logic clk;
    logic rst_n;
    logic [1:0] color;
    logic [9:0] row;
    logic [8:0] col;
    logic [9:0] width;
    logic [8:0] height_radius;
    logic [31:0] bitmap_addr;
    logic [1:0] shape_select;
    logic start;
    logic subtract;
    logic busy;
    logic done;
    logic [1:0] color_map [0:49][0:49];

    // Instantiate the PRU module
    PRU uut (
        .clk(clk),
        .rst_n(rst_n),
        .color(color),
        .row(row),
        .col(col),
        .width(width),
        .height_radius(height_radius),
        .bitmap_addr(bitmap_addr),
        .shape_select(shape_select),
        .start(start),
        .subtract(subtract),
        .busy(busy),
        .done(done),
        .color_map(color_map)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        color = 2'b01;            // Arbitrary color value for rectangle
        row = 10;                 // Starting row for rectangle
        col = 10;                 // Starting column for rectangle
        width = 15;               // Width of rectangle
        height_radius = 15;       // Height for rectangle
        bitmap_addr = 32'h0;      // Not used in this example
        shape_select = 2'b00;     // Start with rectangle
        start = 0;
        subtract = 0;

        // Apply reset
		repeat (1) @(posedge clk);

        rst_n = 1;     

        // Draw a rectangle
        repeat (1) @(posedge clk);

        start = 1;                // Begin drawing rectangle
        repeat (10000) @(posedge clk);

        start = 0;                // Release start after one cycle
        repeat (1000) @(posedge clk);

        // Display color_map (partial, top left corner) to check rectangle
        $display("Color map after rectangle (top left corner):");
        display_color_map(0, 0, 30, 30);

        // Draw a circle
        shape_select = 2'b01;     // Set to circle
        color = 2'b10;            // New color for circle
        row = 30;                 // Center row for circle
        col = 30;                 // Center column for circle
        height_radius = 10;       // Set radius for circle
        repeat (1000) @(posedge clk);

        start = 1;                // Begin drawing circle
        repeat (1000) @(posedge clk);

        start = 0;                // Release start after one cycle
        
		repeat (1000) @(posedge clk);


        // Display color_map (partial, around the circle center) to check circle
        $display("Color map after circle (around circle center):");
        display_color_map(0, 0, 50, 50);

        // End simulation
        #10 $finish;
    end

    // Task to display a section of the color_map array
    task display_color_map(input int x_start, input int y_start, input int x_end, input int y_end);
        integer x, y;
        for (x = x_start; x < x_end; x = x + 1) begin
            for (y = y_start; y < y_end; y = y + 1) begin
                $write("%0d ", color_map[x][y]);
            end
            $display("");
        end
    endtask
endmodule
