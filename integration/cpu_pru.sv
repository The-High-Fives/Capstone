module cpu_pru(input clk, input rst_n, input VGA_CTRL_CLK, input VGA_Read,
    input bl_stall, input [3:0] bl_strobe, output [9:0] VGA_RED,
    output [9:0] VGA_GREEN, output [9:0] VGA_BLUE, 
    output b_ack, output pru_start, output pru_done, output in_idle, output in_load_2);

    logic [1:0] color;
    logic [8:0] row;
    logic [9:0] col;
    logic [9:0] width;
    logic [8:0] height_radius;
    logic [31:0] bitmap_addr;
    logic [1:0] shape_select;
	logic [31:0] pru_addr;
    logic [31:0] pru_data;
    logic start;
    logic subtract;
    logic i_color_load;
    logic busy;
    logic done;
    wire [9:0] PRU_RED, PRU_GREEN, PRU_BLUE;
//    logic [1:0] color_map [307199:0];  //
    wire [31:0] bus_addr, bus_data_in, bus_data_out, bl_data;
    wire [13:0] bl_addr;
    wire bus_read, bus_write, bus_ack;
    assign b_ack = bus_ack;
    assign pru_start = start;
    assign pru_done = done;
   assign VGA_RED = PRU_RED;
   assign VGA_GREEN = PRU_GREEN;
   assign VGA_BLUE = PRU_BLUE;

cpu RISCV
(
    .clk(clk),
    .rst_n(rst_n),
    // bus master interface
    .b_addr_o(bus_addr), // bus r/w address
    .b_data_i(bus_data_in),  // bus data input
    .b_data_o(bus_data_out), // bus data output
    .b_read_o(bus_read),        // bus read
    .b_write_o(bus_write),       // bus write
    .b_ack_i(bus_ack),          // bus acknowledgement signal
    // bootloader 
    .bl_strobe(bl_strobe),
    .bl_data(bl_data),
    .bl_addr(bl_addr),
    .bl_stall(bl_stall)
);

PRU_Preprocessing pru_buffer (
    .clk(clk),
    .rst_n(rst_n),
    .write(bus_write),
    .data(bus_data_out),
    .bus_addr(bus_addr),
    .busy(busy),
    .color(color),
    .row(row),
    .col(col),
    .width(width),
    .height_radius(height_radius),
    .shape_select(shape_select),
    .start(start),
    .subtract(subtract),
    .color_load(i_color_load),
    .ack(bus_ack),
    .in_idle(in_idle),
    .in_load_2(in_load_2)
);

// Instantiate the PRU module
PRU DRAW (
    .clk(clk),
    .rst_n(rst_n),
    .color(color),
    .row(row),
    .col(col),
    .width(width),
    .height_radius(height_radius),
    .pru_addr(bus_addr),
    .pru_data(bus_data_out),
    .shape_select(shape_select),
    .start(start),
    .subtract(subtract),
    .busy(busy),
    .done(done),
    .color_load(i_color_load),
    .VGA_CTRL_CLK(VGA_CTRL_CLK),
    .VGA_Read(VGA_Read),                 
    .pru_red(PRU_RED),
    .pru_green(PRU_GREEN),
    .pru_blue(PRU_BLUE)
);


endmodule