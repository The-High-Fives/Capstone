module  VGA_converter(input rst_n, input clk, input VGA_CTRL_CLK, input [31:0] pru_addr, input [31:0] pru_data, input VGA_Read, 
		input color_load,
		output logic [9:0] pru_red,
		output logic [9:0] pru_green,
		output logic [9:0] pru_blue);
    //Image calc to manipulate bit map
    //Internal Storage
    //Buffer
    //Writing to VGA Interface
    //logic [9:0] pru_blue, pru_green, pru_red;
    logic [17:0] pixel_counter;
    logic [9:0] pixel_width, i_row;
    logic [8:0] pixel_height, i_column;
    logic [30:0] color_buffer [3:0];
    logic [1:0] current_pixel;
	logic VGA_read_edge, VGA_read_delay, screen_reset;
//    logic [17:0] pixel_location;

    //readmemh();

    //Output
 
typedef enum reg {Busy,Idle} state_t;
//typedef enum logic [1:0] {BACKGROUND = 2'b00, COLOR1 = 2'b01, COLOR2 = 2'b10, COLOR3 = 2'b11} color_t;
// color_t pixel;
 state_t state, nxt_state;

logic next_row,ire,iwe;
logic [1:0] iwrt_data,ird_data;
assign ire = '1;
assign iwe = '0;
assign iwrt_data = '1;
//assign ird_data = '1;
logic [15:0] mem_addr;
assign mem_addr = '1;


assign VGA_read_edge = VGA_Read && ~VGA_read_delay;
assign screen_reset = pixel_counter == 19'h4b000;


(* ramstyle = "m10k" *)


//three_d_memory image_buffer (.clk(clk),.re_column(i_column),.re_row(i_row),.wr_column(i_column),.wr_row(i_row),.re(ire),.we(iwe),.wrt_data(iwrt_data),.rd_data(ird_data));

//assign pixel = image_buffer[i_row][i_column];
// always_ff @ (posedge clk) begin
//     current_pixel <= ird_data;
// end

Dual_Port_PRU Image_Buffer (.clk(clk),.re_addr(pixel_counter),.wr_addr(pixel_counter),.we(iwe),.wrt_data(iwrt_data),.rd_data(ird_data));


//Color Register
always_ff @ (posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        color_buffer[0] <= '0;
        color_buffer[1] <= '0;
        color_buffer[2] <= '0;
        color_buffer[3] <= '0;
    end
    else if (color_load) begin
        if (pru_addr == 32'h4000)
            color_buffer[0] = pru_data[30:0];
        else if (pru_addr == 32'h4004)
            color_buffer[1] = pru_data[30:0];
        else if (pru_addr == 32'h4008)
            color_buffer[2] = pru_data[30:0];
        else
            color_buffer[3] = pru_data[30:0];
    end
end

//Image Buffer and pru_color outputs
always_ff @ (posedge clk, negedge rst_n) begin
	if (!rst_n) begin
        pru_red = 10'h15f;
        pru_green = 10'h200;
        pru_blue = 10'h200;	
	end
	else begin
		case (ird_data)
			2'b01: begin
				pru_red = 10'h3ff;
				pru_green = 10'h000;
				pru_blue = 10'h000;
			end
			2'b10: begin
				pru_red = 10'h000;
				pru_green = 10'h3ff;
				pru_blue = 10'h000;
			end
			2'b11: begin
				pru_red = 10'h200;
				pru_green = 10'h000;
				pru_blue = 10'h3ff;
			end
			default: begin //BACKGROUND
				pru_red = 10'h30f;
				pru_green = 10'h30f;
				pru_blue = 10'h30f;
			end
		endcase
	end
end
	
// always_ff @ (posedge clk, negedge rst_n) begin
//     if (!rst_n) begin
//         color_buffer[0] <= '0;
//         color_buffer[1] <= '0;
//         color_buffer[2] <= '0;
//         color_buffer[3] <= '0;
//     end
//     else if (color_load) begin
//         case (pru_addr) 
//             32'h4000:
//                 color_buffer[0] = pru_data[30:0];
//             32'h4004:
//                 color_buffer[1] = pru_data[30:0];
//             32'h4008:
//                 color_buffer[2] = pru_data[30:0];
//             default:
//                 color_buffer[3] = pru_data[30:0];
//         endcase
//     end
// end

//VGA Counter
always_ff @ (negedge VGA_CTRL_CLK, negedge rst_n, posedge screen_reset, posedge VGA_Read) begin
    if (!rst_n) begin //add back vga read edge
        pixel_counter = '0;
    end
    else if (screen_reset) begin
        pixel_counter = '0;
    end
    else if (VGA_Read)
        pixel_counter = pixel_counter + 1; //VGA READ IS boofed
end

assign shift = ~VGA_CTRL_CLK;

//VGA CLK edge checker
always_ff @ (posedge clk, negedge rst_n) begin
    if (!rst_n)
		VGA_read_delay <= 0;
	else 
		VGA_read_delay <= VGA_Read;
end



// //Position Tracker Image Buffer
// always_ff @ (posedge clk, negedge rst_n) begin
//     if (!rst_n) begin //add back vga read edge
//         i_row = 0;
//         i_column = 0;
//     end
//     else if (shift) begin //Add back VGA READ?
//         i_column = i_column + 1;
//     end
//     else if (next_row) begin
//         i_row = i_row + 1;
//         i_column = '0;
//     end
// end

// //State Machine FF
// always_ff @ (posedge clk, negedge rst_n) begin
//     if (!rst_n) 
//         state <= Idle;
//     else 
//         state <= nxt_state;
// end

// //State Machine Outputs
// always_comb begin
//     screen_reset = 0;
//     nxt_state = state;
//     next_row = 0;
//     case (state)
//         Busy: begin 
//             if (i_column == 9'h1df) begin //1df is 479
//                 next_row = 1;
//             end

//             if (pixel_counter == 19'h4b000) begin //Change back to 4b000
//                 screen_reset = 1;
//             end
//         end
//         default: begin 
//             if (VGA_Read) begin
//                 nxt_state = Busy;
//             end
//         end
//     endcase
// end
endmodule
