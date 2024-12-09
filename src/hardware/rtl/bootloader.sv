module bootloader (
    input clk,
    input rst_n,
    input DISABLE, // from switch, disables bootloader so CPU starts running immediately

    // bus
    inout write_o,
    inout read_o,
    input [31:0] data_i,
    inout [31:0] data_o,
    input ack_i,
    inout [31:0] addr_o,

    // bootloader to cpu
    output logic [3:0] bl_strobe,
    output [31:0] bl_data,
    output logic [13:0] bl_addr,
    output logic bl_stall,

    // debug
    output [2:0] debug_state,
	output [11:0] lut_rx_counter, 
    output [11:0] lut_instr_count
);

localparam spart_offset = 32'h4000001C;
typedef enum logic [2:0] {INIT1, INIT2, ACK_IC, INSTRUCTION, ACK, COMPLETE, STOP} state_t; 

// declarations
state_t state, next_state;
logic [31:0] instr_count; // sets number of expected instructions
logic [31:0] rx_counter; // counters number of instructions received
logic [1:0] byte_count; 
logic inc;
logic wr_ic;
logic wr_buff;
logic inc_addr;
logic inc_rxc;
wire [31:0] rx_counter_inc; // rx_counter + 1
logic [7:0] instr_count_0, instr_count_1, instr_count_2, instr_count_3;
logic [7:0] instr_buffer_0, instr_buffer_1, instr_buffer_2;

// bus signals
logic b_write;
logic b_read;
logic [31:0] b_addr;
logic [31:0] b_data;
wire [7:0] rx_data;

assign rx_data = data_i[7:0];
assign rx_counter_inc = rx_counter + 1;

assign write_o = bl_stall ? b_write : 1'bz;
assign read_o = bl_stall ? b_read : 1'bz;
assign addr_o = bl_stall ? b_addr : 32'hzzzzzzzz;
assign data_o = bl_stall ? b_data : 32'hzzzzzzzz;
assign bl_data = {rx_data, instr_buffer_2, instr_buffer_1, instr_buffer_0};

// debug
assign debug_state = state;
assign lut_rx_counter = rx_counter[11:0];
assign lut_instr_count = instr_count[11:0];

// state ff
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        state <= INIT1;
    else
        state <= next_state;
end

// bl_addr
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        bl_addr <= 0;
    else if (inc_addr)
        bl_addr <= bl_addr + 1;
end

// rx_counter counts received bytes
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        rx_counter <= 0;
    else if (inc_rxc)
        rx_counter <= rx_counter_inc;
end

// instruction count
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        instr_count_3 <= '0;
    else if (wr_ic && (byte_count == 2'b11)) begin
        instr_count_3 <= rx_data;
    end
end

// instruction count
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        instr_count_2 <= '0;
    else if (wr_ic && (byte_count == 2'b10)) begin
        instr_count_2 <= rx_data;
    end
end

// instruction count
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        instr_count_1 <= '0;
    else if (wr_ic && (byte_count == 2'b01)) begin
        instr_count_1 <= rx_data;
    end
end

// instruction count
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        instr_count_0 <= '0;
    else if (wr_ic && (byte_count == 2'b00)) begin
        instr_count_0 <= rx_data;
    end
end

assign instr_count = {instr_count_3, instr_count_2, instr_count_1, instr_count_0};

// instruction buffer
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        instr_buffer_0 <= '0;
    else if (wr_buff && (byte_count == 2'b00)) begin
        instr_buffer_0 <= rx_data;
    end
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        instr_buffer_1 <= '0;
    else if (wr_buff && (byte_count == 2'b01)) begin
        instr_buffer_1 <= rx_data;
    end
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        instr_buffer_2 <= '0;
    else if (wr_buff && (byte_count == 2'b10)) begin
        instr_buffer_2 <= rx_data;
    end
end

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        byte_count <= 0;
    else if (inc)
        byte_count <= byte_count + 1;
end

always_comb begin
    next_state = state;
    inc = 0;        // increments byte count
    wr_ic = 0;      // writes next byte to instruction count register
    wr_buff = 0;    // writes next byte to instruction buffer
    inc_addr = 0;
    inc_rxc = 0;
    bl_stall = 1;
    b_data = 32'h00000000;
    b_write = 0;
    b_read = 0;
    b_addr = 32'h00000000;
    bl_strobe = 4'b0000;

    case (state)
        INIT1: begin // displays char 'B'
            if (DISABLE) begin
                next_state = STOP;
            end
            else begin
                b_addr = spart_offset;
                b_write = 1;
                b_data = 32'h00000042;
                if (ack_i)
                    next_state = INIT2;
            end
        end

        INIT2: begin // gets instruction count
            b_addr = spart_offset + 1;
            b_read = 1;
            if (ack_i) begin
                wr_ic = 1;
                inc = 1;
				next_state = ACK_IC;
                if (byte_count == 2'b11)
                    next_state = INSTRUCTION;
            end
        end
		
		ACK_IC: begin
			b_addr = spart_offset;
            b_write = 1;
            b_data = 32'h00000049; // returns letter 'I'
            if (ack_i)
                next_state = INIT2;
		end

        INSTRUCTION: begin
            b_addr = spart_offset + 1;
            b_read = 1;
            if (ack_i) begin
                wr_buff = 1;
                inc = 1;
				next_state = ACK;
                if (byte_count == 2'b11) begin
                    bl_strobe = 4'b1111;
                    inc_addr = 1;
                    inc_rxc = 1;
                    if (rx_counter_inc == instr_count)
                        next_state = COMPLETE;
                end
            end
        end
		
		ACK: begin
			b_addr = spart_offset;
            b_write = 1;
            b_data = 32'h00000041; // returns letter 'A'
            if (ack_i)
                next_state = INSTRUCTION;
		end
		
		COMPLETE: begin
			b_addr = spart_offset;
            b_write = 1;
            b_data = 32'h00000043; // returns letter 'C'
            if (ack_i)
                next_state = STOP;
		end

        default: begin // STOP
            bl_stall = 0;
        end
    endcase
end

endmodule