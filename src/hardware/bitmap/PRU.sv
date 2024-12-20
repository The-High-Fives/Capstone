module PRU (
    input logic clk,                     // Clock signal
    input logic rst_n,                   // Reset signal (active low)
    input logic [1:0] color,             // Color value
    input logic [9:0] row,               // Starting row for rectangle, center row for circle
    input logic [8:0] col,               // Starting col for rectangle, center col for circle
    input logic [9:0] width,             // Width of the rectangle
    input logic [8:0] height_radius,     // Height of rectangle or radius of circle
	input logic [31:0] pru_addr,
    input logic [31:0] pru_data,
    input logic [1:0] shape_select,      // Shape selection: 00 for rectangle, 01 for circle
    input logic start,                   // Start signal
	input logic subtract,
    output logic busy,                   // Busy signal
    output logic done,                   // Done signal
    input logic color_load,
    input logic VGA_CTRL_CLK,
    input logic VGA_Read,
    output logic [9:0] pru_red,
    output logic [9:0] pru_green,
    output logic [9:0] pru_blue
);
	
    // Define FSM States
    typedef enum logic [2:0] {
        IDLE, RESET_MAP, DRAW_RECT, DRAW_CIRCLE, DRAW_BITMAP, COMPLETE
    } state_t;

    state_t state, next_state;
    integer r, c;                        // Current row and column counters
	logic [18:0] pixel_calculator;			 // Calculates position in 1D color_map array given row and column
	logic [18:0] draw_bitmap_counter; // draw bitmap counter
    logic pixel_in_circle;               // Flag to check if pixel is within circle bounds
    logic rect_done, circle_done, bitmap_done;        // Flags for rectangle and circle completion
	logic iwe;
    // Set busy signal when the drawing process is active
    
    //Writing to VGA Interface
    logic [18:0] pixel_counter, prev_pixel_count;
    logic [30:0] color_buffer [3:0];
    logic [1:0] current_pixel, ird_data;

    //logic [9:0] pru_red, pru_green, pru_blue;
	
	//bitmap rd data
	logic ibitmaprd_data;
	
    logic fifo_full,fifo_empty,screen_reset;

	assign busy = (state != IDLE && state != COMPLETE);


    // Combinational logic for state transitions and pixel calculations
    always_comb begin
        next_state = state;
		pixel_calculator = (c + (640 * r)); // calculates 1D location of 2D (row,column)x
        pixel_in_circle = ((r - row) * (r - row) + (c - col) * (c - col) <= height_radius * height_radius);
        rect_done = (r >= row + height_radius-1) && (c >= col + width-1);
        circle_done = (r >= row + height_radius - 1) && (c >= col + height_radius - 1);
		bitmap_done = (draw_bitmap_counter == 1023);
        case (state)

            RESET_MAP: begin        
				if (r == 639 && c == 479) begin
                    next_state = IDLE;
                end     
            end
            DRAW_RECT: begin
                if (rect_done) begin
                    next_state = COMPLETE;
                end
            end
            DRAW_CIRCLE: begin
                if (circle_done) begin
                    next_state = COMPLETE;
                end
            end
			DRAW_BITMAP: begin
				if (bitmap_done) begin
                    next_state = COMPLETE;
                end
			end
            COMPLETE: begin
                if (!start) next_state = IDLE;
            end
            default: begin //IDLE
                if (start) begin
                    next_state = (shape_select == 2'b00) ? DRAW_RECT : (shape_select == 2'b01) ? DRAW_CIRCLE : DRAW_BITMAP;
                end
            end
        endcase
    end

    // Sequential logic for FSM, color_map update, and counters
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            r <= 0;
            c <= 0;
            done <= 0;
			draw_bitmap_counter <= 0; // Reset bitmap counter
        end
        else begin
            state <= next_state;

            case (state)
                RESET_MAP: begin
                    // Reset color_map to 0s sequentially
                    //color_map[pixel_calculator] <= 2'b00;// TODO this is needs another think through
                    if (c < 479) begin
                        c <= c + 1;
                    end else begin
                        c <= 0;
                        if (r < 639) begin
                            r <= r + 1;
                        end else begin
							c <= 0;
							r <= 0;
						end
                    end
                end

                DRAW_RECT: begin
                    // Initialize r and c to the start of the rectangle bounds
                    if (r < row) r <= row;
                    if (c < col) c <= col;
                    
                    // Draw rectangle sequentially within bounds
                    if (r >= row && r < row + height_radius && c >= col && c < col + width) begin
                        if (r < 640 && c < 480) begin  // Bounds check
                            iwe <= 1;
                        end
                        else begin
                            iwe <= 0;
                        end
                    end
                    // Update column and row counters
                    if (c < col + width - 1) begin
                        c <= c + 1;
                    end else begin
                        c <= col;  // Reset column to start of the rectangle
                        r <= r + 1;  // Move to the next row
                    end
                end

                DRAW_CIRCLE: begin
                    // Initialize r and c to the center of the circle
                    if (r < row - height_radius) r <= row - height_radius;
                    if (c < col - height_radius) c <= col - height_radius;
                    
                    // Draw circle sequentially, checking if each pixel is within radius
                    if (r < 640 && c < 480 && pixel_in_circle) begin
                        iwe <= 1;
                    end
                    else begin
                        iwe <= 0;
                    end
                    // Update column and row counters
                    if (c < col + height_radius + height_radius - 1) begin
                        c <= c + 1;
                    end else begin
                        c <= col - height_radius;
                        r <= r + 1;
                    end
                end
				DRAW_BITMAP: begin
				    
                    // Initialize r and c to the start of the rectangle bounds
					
                    if (r < row) r <= row;
                    if (c < col) c <= col;
                    
                    // Draw rectangle sequentially within bounds
                    if ((r >= row && r < row + height_radius && c >= col) && (c < col + height_radius)) begin
						draw_bitmap_counter <= draw_bitmap_counter + 1;
                        iwe <= ibitmaprd_data == 1'b1;
                    end
                    else begin
                        iwe <= 0;
                    end
                    
                    // Update column and row counters
                    if (c < col + height_radius - 1) begin
                        c <= c + 1;
                    end else begin
                        c <= col;  // Reset column to start of the rectangle
                        r <= r + 1;  // Move to the next row
                    end
                end

                COMPLETE: begin //This is complete
                    done <= 1;  // Signal that drawing is complete
                end

                default: begin //IDLE
                    // Reset counters and done flag in IDLE state
                    r <= 0;
                    c <= 0;
					draw_bitmap_counter <= 0;
                    done <= 0;
                end
            endcase
        end
    end

assign screen_reset = pixel_counter == 19'h4b000;
assign different_pixel = pixel_counter != prev_pixel_count;

(* ramstyle = "m10k" *)

Dual_Port_PRU color_map (.clk(clk),.re_addr(pixel_counter),.wr_addr(pixel_calculator),.we(iwe),.wrt_data(color),.rd_data(ird_data));

Single_Port_PRU bitmaps (.clk(clk), .re_addr(draw_bitmap_counter),.wr_addr('0),.re(1'b1),.wrt_data('0), .rd_data(ibitmaprd_data));

async_fifo 
#(
     .width(2),.depth(32))
PRU_Fifo_Buffer
(
     .i_wclk(clk)
    ,.i_rclk(!VGA_CTRL_CLK)
    ,.i_wr(!fifo_full)
    ,.i_rd(VGA_Read)
    ,.i_wdata(ird_data)
    ,.i_wrst_n(~rst_n)
    ,.i_rrst_n(~rst_n)

    ,.o_rdata(current_pixel)
    ,.o_empty(fifo_empty)
    ,.o_full(fifo_full)
);
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
        pru_blue = 10'h3ff;	
	end
	else begin
		case (current_pixel)
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
	
always_ff @ (posedge ~VGA_CTRL_CLK, negedge rst_n) begin
    if (!rst_n) begin
		prev_pixel_count = 0;
	end
	else 
		prev_pixel_count <= pixel_counter; 
end

//VGA Counter
always_ff @ (posedge ~VGA_CTRL_CLK, negedge rst_n, posedge screen_reset) begin 
    if (!rst_n) begin //add back vga read edge
        pixel_counter <= '0;
    end
    else if (screen_reset) begin
        pixel_counter <= '0;
    end
     //Note: VGA_Read and fifo_full sensitivity is the opposite of what their respective enable signals are. This is on purpose, and so that a pixel isn't skipped
    else if (VGA_Read && ~fifo_full)
        pixel_counter <= pixel_counter + 1; //VGA READ IS boofed
end
endmodule
