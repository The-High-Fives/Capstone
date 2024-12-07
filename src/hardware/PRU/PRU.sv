module PRU (
    input logic clk,                     // Clock signal
    input logic rst_n,                   // Reset signal (active low)
    input logic [1:0] color,             // Color value
    input logic [9:0] col,               // Starting col for rectangle, center col for circle
    input logic [8:0] row,               // Starting row for rectangle, center row for circle
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
    integer c, r;                        // Current row and column counters
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
	
	//bitmap rd data
	logic ibitmaprd_data;
	
    logic fifo_full,fifo_empty,screen_reset;

	assign busy = (state != IDLE && state != COMPLETE);


    // Combinational logic for state transitions and pixel calculations
    always_comb begin
        next_state = state;


        rect_done = (c >= col + width-1) && (r >= row + height_radius-1);
        circle_done = (c >= col + height_radius - 1) && (r >= row + height_radius - 1);
		bitmap_done = (draw_bitmap_counter == 1023);
        case (state)

            RESET_MAP: begin        
		    if (c == 479 && r == 639) begin
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
            c <= 0;
            r <= 0;
            done <= 0;
			draw_bitmap_counter <= 0; // Reset bitmap counter
        pixel_calculator = 0; // calculates 1D location of 2D (row,column)x
        pixel_in_circle = 0;
        end
        else begin
            state <= next_state;
	    pixel_calculator = (c + (640 * r)); // calculates 1D location of 2D (row,column)x
        pixel_in_circle = ((c - col) * (c - col) + (r - row) * (r - row) <= height_radius * height_radius);
            case (state)
                RESET_MAP: begin

			if (r < 479) begin
                        r <= r + 1;
                    end else begin
                        r <= 0;
			    if (c < 639) begin
                            c <= c + 1;
                        end else begin
							r <= 0;
							c <= 0;
						end
                    end
                end

                DRAW_RECT: begin
                    // Initialize r and c to the start of the rectangle bounds
                    if (c < col) c <= col;
                    if (r < row) r <= row;
                    
                    // Draw rectangle sequentially within bounds

                    if (c >= col && c < col + width && r >= row && r < row + height_radius) begin
			    if (c < 640 && r < 480) begin  // Bounds check
                            iwe <= 1;
                        end
                        else begin
                            iwe <= 0;
                        end
                    end
                    // Update column and row counters
                    if (r < row + height_radius - 1) begin
                        r <= r + 1;
                    end else begin
                        r <= row;  // Reset column to start of the rectangle
                        c <= c + 1;  // Move to the next row
                    end
                end

                DRAW_CIRCLE: begin
                    // Initialize r and c to the center of the circle
                    if (c < col - height_radius) c <= col - height_radius;
                    if (r < row - height_radius) r <= row - height_radius;
                    
                    // Draw circle sequentially, checking if each pixel is within radius

			if (c < 640 && r < 480 && pixel_in_circle) begin
                        iwe <= 1;
                    end
                    else begin
                        iwe <= 0;
                    end
                    // Update column and row counters
                    if (r < row + height_radius + height_radius - 1) begin
                        r <= r + 1;
                    end else begin
                        r <= row - height_radius;
                        c <= c + 1;
                    end
                end
				DRAW_BITMAP: begin
				    
                    // Initialize r and c to the start of the rectangle bounds
					
                    if (c < col) c <= col;
                    if (r < row) r <= row;
                    
                    // Draw rectangle sequentially within bounds
                    if ((c >= col && c < col + height_radius && r >= row) && (r < row + height_radius)) begin //FIXME LOOK OVER THIS? for height_radius and width
						draw_bitmap_counter <= draw_bitmap_counter + 1;
                        iwe <= ibitmaprd_data == 1'b1;
                    end
                    else begin
                        iwe <= 0;
                    end
                    
                    // Update column and row counters
                    if (r < row + height_radius - 1) begin
                        r <= r + 1;
                    end else begin
                        r <= row;  // Reset column to start of the rectangle
                        c <= c + 1;  // Move to the next row
                    end
                end

                COMPLETE: begin //This is complete
                    done <= 1;  // Signal that drawing is complete
                    iwe <= 0;
                end

                default: begin //IDLE
                    // Reset counters and done flag in IDLE state
                    c <= 0;
                    r <= 0;
					draw_bitmap_counter <= 0;
                    done <= 0;
                    iwe <=0;
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
        color_buffer[0] <= '1;
        color_buffer[1] <= '0;//30'h30FFF0F0;
        color_buffer[2] <= '0;//30'h107FF00F;
        color_buffer[3] <= '0;//30'h270F3F53;
    end
    else if (color_load) begin
        if (pru_addr == 32'h4000010C)
            color_buffer[0] = pru_data[30:0];
        else if (pru_addr == 32'h40000110)
            color_buffer[1] = pru_data[30:0];
        else if (pru_addr == 32'h40000114)
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
				//pru_red = 10'h3ff
				//pru_green = 10'h000;
				//pru_blue = 10'h000;
				pru_red = color_buffer[1][9:0];
				pru_green = color_buffer[1][19:10];
				pru_blue = color_buffer[1][29:20];
				
			end
			2'b10: begin
				//pru_red = 10'h000;
				//pru_green = 10'h3ff;
				//pru_blue = 10'h000;
				pru_red = color_buffer[2][9:0];
				pru_green = color_buffer[2][19:10];
				pru_blue = color_buffer[2][29:20];
			end
			2'b11: begin
				//pru_red = 10'h200;
				//pru_green = 10'h000;
				//pru_blue = 10'h3ff;
				pru_red = color_buffer[3][9:0];
				pru_green = color_buffer[3][19:10];
				pru_blue = color_buffer[3][29:20];
			end
			default: begin //BACKGROUND
				//pru_red = 10'h30f;
				//pru_green = 10'h30f;
				//pru_blue = 10'h30f;
				pru_red = color_buffer[0][9:0];
				pru_green = color_buffer[0][19:10];
				pru_blue = color_buffer[0][29:20];
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
