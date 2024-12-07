module PRU_Preprocessing (
    input logic clk,                     // Clock signal
    input logic rst_n,                   // Reset signal (active low)
	input logic write,
    input logic [31:0] bus_data,             // 32-bit data input
	input logic [31:0] bus_address,
	output logic [31:0] bitmap_address,  // 32-bit bitmap_address
    output logic [1:0] color,            // Color value
    output logic [9:0] col,              // Starting col for rectangle, center col for circle
    output logic [8:0] row,              // Starting row for rectangle, center row for circle
    output logic [9:0] width,            // Width of the rectangle
    output logic [8:0] height_radius,    // Height of rectangle or radius of circle
    output logic [1:0] shape_select,     // Shape selection: 00 for rectangle, 01 for circle
    output logic start,                  // Start signal
    output logic subtract,               // Subtract flag
    output logic color_load,             // Color load signal
	output logic ack
);

    typedef enum logic [1:0] {IDLE, LOAD_SHAPE, LOAD_IMM} state_t; // State definitions
    state_t state, next_state;                            // Current and next state
	logic load1, load2, loadImm;
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
		loadImm = 0;
		color_load = 0;
		next_state = state;
		case (state)
			LOAD_SHAPE: begin
				if (write) begin
					next_state = IDLE;
					load2 = 1;
					ack = 1;
				end

			end
			LOAD_IMM: begin
				if (write) begin
					next_state = IDLE;
					loadImm = 1;
					ack = 1;
				end

			end
			default: begin //IDLE
				if (write) begin
					ack = 1;
					load1 = 1;
					if ((bus_address == 32'h4000010C) || (bus_address == 32'h40000110) || (bus_address == 32'h40000114) || (bus_address == 32'h40000118)) begin
						color_load = 1;
					end else 
					if(bus_data[22] == 1'b1) begin
						next_state = LOAD_IMM;
					end else begin
					next_state = LOAD_SHAPE; 
					end
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
            col <= 0;
            row <= 0;
            width <= 0;
            height_radius <= 0;
            shape_select <= 0;
            subtract <= 0;
        end 
		else if (load1) begin
                // Populate the first set of PRU inputs
		row <= bus_data[8:0];
		col <= bus_data[18:9];
		color <= bus_data[20:19];
				shape_select <= bus_data[22:21];
				start <= 0;
        end
		else if (loadImm) begin
				bitmap_address <= bus_data;
				start <= 1;
		end
        else if (load2) begin
                // Populate the remaining PRU inputs
	        height_radius <= bus_data[8:0];
			width <= bus_data[18:9];
		    subtract <= bus_data[19];
			start <= 1;
		end else begin
			start <= 0;
        end	
	end		
            
    
    

endmodule
