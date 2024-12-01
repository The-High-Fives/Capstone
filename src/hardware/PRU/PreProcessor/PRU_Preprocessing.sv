module PRU_Preprocessing (
    input logic clk,                     // Clock signal
    input logic rst_n,                   // Reset signal (active low)
	input logic write,
    input logic [31:0] data,             // 32-bit data input
    input logic busy,
    output logic [1:0] color,            // Color value
    output logic [9:0] row,              // Starting row for rectangle, center row for circle
    output logic [8:0] col,              // Starting col for rectangle, center col for circle
    output logic [9:0] width,            // Width of the rectangle
    output logic [8:0] height_radius,    // Height of rectangle or radius of circle
    output logic [1:0] shape_select,     // Shape selection: 00 for rectangle, 01 for circle
    output logic start,                  // Start signal
    output logic subtract,               // Subtract flag
    output logic color_load,             // Color load signal
	output logic ack,
    output logic in_idle,
    output logic in_load_2
);

    typedef enum logic [1:0] {IDLE, LOAD} state_t; // State definitions
    state_t state, next_state;                            // Current and next state
	logic load1, load2;
    // Sequential logic for state transitions
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;  // Reset to IDLE state
			
        else
            state <= next_state;
    end     	 
	always_comb begin
		ack = 1'bz;
		load1 = 0;
		load2 = 0;
        in_idle = 0;
        in_load_2 = 0;
		next_state = state;
		case (state)
			LOAD: begin
                in_load_2 = 1;
                if (write)
                    ack = 1'b0;
				if (write && !busy) begin
					next_state = IDLE;
					load2 = 1;
					ack = 1;
				end

			end
			default: begin //IDLE
                in_idle = 1;
                if (write)
                    ack = 1'b0;
				if (write && !busy) begin
					load1 = 1;
					ack = 1;
					next_state = LOAD;
				end
			end
		endcase
	end
	
    // Next state logic and output assignments
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all outputs
		start <= 0;
            color <= 0;
            row <= 0;
            col <= 0;
            width <= 0;
            height_radius <= 0;
            shape_select <= 0;
            subtract <= 0;
            color_load <= 0;
        end else begin
            if (load1) begin
                // Populate the first set of PRU inputs
                col <= data[8:0];
                row <= data[18:9];
                color <= data[20:19];
                shape_select <= data[22:21];
                start = 0;
            end
            else if (load2) begin
                // Populate the remaining PRU inputs
                height_radius <= data[8:0];
                width <= data[18:9];
                subtract <= data[21];
                color_load <= data[22];
                start = 1;
            end else begin
                start = 0;
            end	
		end		
            
    end
    

endmodule
