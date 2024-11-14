// max size of 32768 memory locations
module dmem32
#(
    parameter depth = 16384 // 128K = 32768 32-bit memory location, 64K = 16384 32-bit memory location 
)
(
    // inputs
    input logic clk,
    input logic rst_n, 
    input logic [14:0] addr,  // 15-bit address for 32KB (128KB memory)
    input logic re,           // Read enable
    input logic we,           // Write enable
    input logic [7:0] wdata, // 32-bit data to be written into memory

    // outputs
    output logic [7:0] rdata // 32-bit data to be read from memory
);

    // memory, each location stores a 32-bit word (4 bytes), each bank store 1 byte
    reg [7:0] mem [0:depth-1];

    // Read operation
    always_ff @(posedge clk) begin // rst_n
        if (re) 
            rdata <= mem[addr[$clog2(depth)-1:0]]; // Read data from memory at the given address
    end

    // Write operation
    always_ff @(posedge clk) begin // rst_n
        if (we) 
            mem[addr] <= wdata; // Write to memory during normal operation
    end

    // Reading memory
    initial begin
        $readmemh("ADD.hex", mem);
    end

endmodule
