module dmem32
#(
    parameter depth = 16384, // 128K = 32768 32-bit memory location, 64K = 16384 32-bit memory location 
	parameter FILENAME = "add.hex"
)
(
    // inputs
    input clk,
    input rst_n,
    input [$clog2(depth)-1:0] addr,  // 14-bit address for 16KB bank (64KB memory)
    input re,           // Read enable
	input we,           // Write enable
    input [7:0] wdata, // 32-bit data to be written into memory

    // outputs
    output reg [7:0] rdata // 32-bit data to be read from memory
);
    // memory, each location stores a 32-bit word (4 bytes), each bank store 1 byte
    reg [7:0] mem [0:depth-1];

    // Write operation
    always_ff @(posedge clk) begin
        if (we) begin
            mem[addr] <= wdata; // Write to memory during normal operation
		end
		if (re) begin
			rdata <= mem[addr]; // Read data from memory at the given address
		end
    end

    // Reading memory
    initial begin
        $readmemh(FILENAME, mem);
    end

endmodule
