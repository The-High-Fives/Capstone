module  ();
    //Image calc to manipulate bit map
    //Internal Storage
    //Buffer
    //Writing to VGA Interface
    logic [9:0] PRU_BLUE, PRU_GREEN, PRU_RED;
    logic [18:0] pixel_counter;
    logic [9:0] pixel_width;
    logic [8:0] pixel_height;
    [1:0] ImageBuffer [639:0] [479:0];
    initial begin
        for (int i = 0; i < 640; i++) begin
            for (int j = 0; j < 480; j++) begin
                if ( i >= 400 && i < 600 && j >= 75 && j < 130) begin
                    image_buffer[i][j] = 2'b10;
                end else begin
                    image_buffer[i][j] = 2'b00;
                end
             end
        end
    end

    //Output
    
typedef enum reg {Busy,Idle} state_t;
typedef enum logic {BACKGROUND = 2'b00, COLOR1 = 2'b01, COLOR2 = 2'b10, COLOR3 = 2'b11} color_t;
color_t pixel;
state_t state, nxt_state;

//Color Register
always_ff begin
    if (!rst_n) begin
        color_buffer = '0;
    end
    else if (color_load) begin
        //color_buffer = something;
    end
end

//VGA Counter
always_ff begin
    if (!rst_n || VGA_Read) begin
        pixel_counter = '0;
    end
    else 
        pixel_counter = pixel_counter + 1;
end
assign shift = ~VGA_CTRL_CLK;

always_ff begin
    if (!rst_n) 
        state <= IDLE;
    else 
        state <= nxt_state;
end

always_comb begin //State machine
    nxt_state = state;
    case (state)
        Busy:
            if (shift) begin
                case (color_t)
                    BACKGROUND:
                        PRU_RED = 10'h3FF;
                        PRU_GREEN = 10'h3FF;
                        PRU_BLUE = 10'h3FF;
                    COLOR1:
                        PRU_RED = 10'h3FF;
                        PRU_GREEN = 10'h200;
                        PRU_BLUE = 10'h200;
                    COLOR2:
                        PRU_RED = 10'h200;
                        PRU_GREEN = 10'h3FF;
                        PRU_BLUE = 10'h200;
                    COLOR3:
                        PRU_RED = 10'h200;
                        PRU_GREEN = 10'h200;
                        PRU_BLUE = 10'h3FF;
                endcase
            end else if (pixel_counter == 19'h4b000) begin
                nxt_state = IDLE;
            end
        IDLE:
            if (VGA_Read) begin
                nxt_state = Busy;
            end
    endcase
end
endmodule