module PRU (
    input logic clk,                     // Clock signal
    input logic rst_n,                   // Reset signal (active low)
    input logic [1:0] color,             // Color value
    input logic [9:0] row,               // Starting row for rectangle, center row for circle
    input logic [8:0] col,               // Starting col for rectangle, center col for circle
    input logic [9:0] width,             // Width of the rectangle
    input logic [8:0] height_radius,     // Height of rectangle or radius of circle
	input logic [31:0] bitmap_addr,
    input logic [1:0] shape_select,      // Shape selection: 00 for rectangle, 01 for circle
    input logic start,                   // Start signal
	input logic subtract,
    output logic busy,                   // Busy signal
    output logic done,                   // Done signal
    output logic [1:0] color_map [0:49][0:49]  // Color map output
);

    // Define FSM States
    typedef enum logic [2:0] {
        IDLE, RESET_MAP, DRAW_RECT, DRAW_CIRCLE, COMPLETE
    } state_t;

    state_t state, next_state;
    integer r, c;                        // Current row and column counters
    logic pixel_in_circle;               // Flag to check if pixel is within circle bounds
    logic rect_done, circle_done;        // Flags for rectangle and circle completion

    // Set busy signal when the drawing process is active
    
	assign busy = (state != IDLE && state != COMPLETE);


    // Combinational logic for state transitions and pixel calculations
    always_comb begin
        next_state = state;
        pixel_in_circle = ((r - row) * (r - row) + (c - col) * (c - col) <= height_radius * height_radius);
        rect_done = (r >= row + height_radius-1) && (c >= col + width-1);
        circle_done = (r >= row + height_radius - 1) && (c >= col + height_radius - 1);

        case (state)
            IDLE: begin
                if (start) begin
                    next_state = (shape_select == 2'b00) ? DRAW_RECT : DRAW_CIRCLE;
                end
            end
            RESET_MAP: begin        
				if (r == 49 && c == 49) begin
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
            COMPLETE: begin
                if (!start) next_state = IDLE;
            end
        endcase
    end

    // Sequential logic for FSM, color_map update, and counters
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RESET_MAP;
            r <= 0;
            c <= 0;
            done <= 0;
        end
        else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Reset counters and done flag in IDLE state
                    r <= 0;
                    c <= 0;
                    done <= 0;
                end

                RESET_MAP: begin
                    // Reset color_map to 0s sequentially
                    color_map[r][c] <= 2'b00;
                    if (c < 49) begin
                        c <= c + 1;
                    end else begin
                        c <= 0;
                        if (r < 49) begin
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
                        if (r < 50 && c < 50) begin  // Bounds check
                            color_map[r][c] <= color;
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
                    if (r < 50 && c < 50 && pixel_in_circle) begin
                        color_map[r][c] <= color;
                    end

                    // Update column and row counters
                    if (c < col + height_radius + height_radius - 1) begin
                        c <= c + 1;
                    end else begin
                        c <= col - height_radius;
                        r <= r + 1;
                    end
                end

                COMPLETE: begin
                    done <= 1;  // Signal that drawing is complete
                end
            endcase
        end
    end

endmodule
