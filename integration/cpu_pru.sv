module cpu_pru(input clk, input rst_n);

    logic clk;
    logic rst_n;
    logic [1:0] color;
    logic [9:0] row;
    logic [8:0] col;
    logic [9:0] width, PRU_RED, PRU_GREEN, PRU_BLUE;
    logic [8:0] height_radius;
    logic [31:0] bitmap_addr;
    logic [1:0] shape_select;
	logic [31:0] pru_addr;
    logic [31:0] pru_data;
    logic start, VGA_CTRL_CLK, VGA_Read;
    logic subtract;
    logic i_color_load;
    logic busy;
    logic done;
    logic [1:0] color_map [2499:0];  // 50 * 50 = 2500
    logic [31:0] bus_addr, bus_data_in, bus_data_out;
    logic bus_read, bus_write, bus_ack;
    logic [3:0] bl_strobe;
    logic [31:0] bl_data;
    logic [13:0] bl_addr;
    logic bl_stall;

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
    .clk(CLOCK_50),
    .rst_n(DLY_RST_1),
    .write(b_write_o),
    .data(b_data_o),
    .color(color),
    .row(row),
    .col(col),
    .width(width),
    .height_radius(height_radius),
    .shape_select(shape_select),
    .start(start),
    .subtract(subtract),
    .color_load(color_load),
    .ack(b_ack_i)
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
    .pru_addr(pru_addr),
    .pru_data(pru_data),
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