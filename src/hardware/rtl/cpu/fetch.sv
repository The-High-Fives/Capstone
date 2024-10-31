import pc_defnitions::*;

module fetch (
    // inputs 
    input wire clk,
    input wire rst_n,
    input wire PC_enable,           // Enable signal for PC update
    input wire takeBranch,          // Signal to indicate if branch is taken
    input wire [31:0] branch_PC,    // Target address for branch/jump
    // input wire [31:0] instr_mem_data, // Instruction fetched from external memory

    // outputs
    output reg [31:0] instruction_IFID_in, // Fetched instruction for IF/ID stage
    output reg [31:0] PC_IFID_in,         // Current PC value
);

    // Declare instruction memory and load contents from the code we wish to execute. 
    reg [31:0] instr_mem[0:8191];

    initial begin
        $readmemh("instr_mem.hex",instr_mem);
    end

    // Instantiate PC_and_Branch module for PC updates
    PC_and_Branch pc_and_branch (
        .clk(clk),
        .rst_n(rst_n),
        .PC_enable(PC_enable),
        .branch(1'b0),               
        .jumpAL(1'b0),
        .takeBranch(takeBranch),
        .branch_PC(branch_PC),
        .PC_IFID_in(PC_IFID_in)
    );

    // Fetch instruction from memory
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            instruction_IFID_in <= 32'd0;
        end else begin
            // instruction_IFID_in <= instr_mem_data;
            instruction_IFID_in <= instr_mem[PC_IFID_in >> 2]; // divide by 4 to get location
        end
    end

endmodule

