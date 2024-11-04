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
    logic [18:0] pixel_counter;
    logic [9:0] pixel_width, i_row;
    logic [8:0] pixel_height, i_column;
    logic [30:0] color_buffer [3:0];
    logic [1:0] current_pixel;
	logic VGA_read_edge, VGA_read_delay;


    //readmemh();

    //Output
 
typedef enum reg {Busy,Idle} state_t;
typedef enum logic [1:0] {BACKGROUND = 2'b00, COLOR1 = 2'b01, COLOR2 = 2'b10, COLOR3 = 2'b11} color_t;
color_t pixel;
state_t state, nxt_state;
color_t image_buffer [639:0] [479:0];

logic next_row;


assign pixel = image_buffer[i_row][i_column];

//Color Register
always_ff @ (posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        color_buffer[0] <= '0;
        color_buffer[1] <= '0;
        color_buffer[2] <= '0;
        color_buffer[3] <= '0;
    end
    else if (color_load) begin
        case (pru_addr) 
            32'h4000:
                color_buffer[0] = pru_data[30:0];
            32'h4004:
                color_buffer[1] = pru_data[30:0];
            32'h4008:
                color_buffer[2] = pru_data[30:0];
            32'h400C:
                color_buffer[3] = pru_data[30:0];
            default:
                $stop();
        endcase
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
		case (pixel)
			COLOR1: begin
				pru_red = 10'h3ff;
				pru_green = 10'h200;
				pru_blue = 10'h200;
			end
			COLOR2: begin
				pru_red = 10'h200;
				pru_green = 10'h3ff;
				pru_blue = 10'h200;
			end
			COLOR3: begin
				pru_red = 10'h200;
				pru_green = 10'h200;
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
//reset buffer?
always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
     for (int i = 0; i < 640; i++) begin
         for (int j = 0; j < 480; j++) begin
             if (j >= 2 && j < 8) begin
                image_buffer[i][j] = COLOR2;
             end else begin
                 image_buffer[i][j] = BACKGROUND;
             end
          end
     end
	end
end
	
always_ff @ (posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        color_buffer[0] <= '0;
        color_buffer[1] <= '0;
        color_buffer[2] <= '0;
        color_buffer[3] <= '0;
    end
    else if (color_load) begin
        case (pru_addr) 
            32'h4000:
                color_buffer[0] = pru_data[30:0];
            32'h4004:
                color_buffer[1] = pru_data[30:0];
            32'h4008:
                color_buffer[2] = pru_data[30:0];
            32'h400C:
                color_buffer[3] = pru_data[30:0];
            default:
                $stop();
        endcase
    end
end

//VGA Counter
always_ff @ (posedge clk, negedge rst_n) begin
    if (!rst_n || VGA_read_edge) begin
        pixel_counter = '0;
    end
    else 
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

assign VGA_read_edge = VGA_Read && ~VGA_read_delay;

//Position Tracker Image Buffer
always_ff @ (posedge clk, negedge rst_n) begin
    if (!rst_n || VGA_read_edge) begin 
        i_row = 0;
        i_column = 0;
    end
    else if (shift) begin //Add back VGA READ?
        i_column = i_column + 1;
    end
    else if (next_row) begin
        i_row = i_row + 1;
        i_column = '0;
    end
end

//State Machine FF
always_ff @ (posedge clk, negedge rst_n) begin
    if (!rst_n) 
        state <= Idle;
    else 
        state <= nxt_state;
end

//State Machine Outputs
always_comb begin
    nxt_state = state;
    next_row = 0;
    case (state)
        Busy: begin 
            if (i_column == 9'h1df) begin //1df is 479
                next_row = 1;
            end

            if (pixel_counter == 19'h003d0) begin //Change back to 4b000
                nxt_state = Idle;
            end
        end
        default: begin 
            if (VGA_Read) begin
                nxt_state = Busy;
            end
        end
    endcase
end
endmodule
