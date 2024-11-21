module PRU_Preprocessing (
    input logic clk,                     // Clock signal
    input logic rst_n,                   // Reset signal (active low)
	input logic write,
    input logic [31:0] data,             // 32-bit data input
    output logic [1:0] color,            // Color value
    output logic [9:0] row,              // Starting row for rectangle, center row for circle
    output logic [8:0] col,              // Starting col for rectangle, center col for circle
    output logic [9:0] width,            // Width of the rectangle
    output logic [8:0] height_radius,    // Height of rectangle or radius of circle
    output logic [1:0] shape_select,     // Shape selection: 00 for rectangle, 01 for circle
    output logic start,                  // Start signal
    output logic subtract,               // Subtract flag
    output logic color_load,             // Color load signal
    output logic VGA_CTRL_CLK,           // VGA Control Clock
    output logic VGA_Read,                // VGA Read signal
	output logic ack
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
		ack = 0;
		load1 = 0;
		load2 = 0;
		next_state = state;
		case (state)
			LOAD: begin
				if (write) begin
					next_state = IDLE;
					load2 = 1;
					ack = 1;
				end

			end
			default: begin //IDLE
				if (write) begin
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
            color <= 0;
            row <= 0;
            col <= 0;
            width <= 0;
            height_radius <= 0;
            shape_select <= 0;
            start <= 0;
            subtract <= 0;
            color_load <= 0;
            VGA_CTRL_CLK <= 0;
            VGA_Read <= 0;
        end else begin
			if (load1) begin
                // Populate the first set of PRU inputs
                color <= data[1:0];
                row <= data[11:2];
                col <= data[20:12];
                width <= data[30:21];
            end
            else if (load2) begin
                // Populate the remaining PRU inputs
                height_radius <= data[8:0];
                shape_select <= data[10:9];
                start <= data[11];
                subtract <= data[12];
                color_load <= data[13];
                VGA_CTRL_CLK <= data[14];
                VGA_Read <= data[15];
            end
				
		end		
            
    end
    

endmodule