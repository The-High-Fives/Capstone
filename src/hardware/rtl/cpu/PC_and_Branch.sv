module PC_and_Branch (
    // inputs
    input wire clk, 
    input wire rst_n, 
    input wire PC_enable,        // Enable signal to update the PC
    input wire branch,           // Branch control signal
    input wire jumpAL,           // Jump control signal (JAL or JALR)
    input wire takeBranch,       // Is the branch taken or not?
    input wire [31:0] branch_PC, // Target address for branch or jump
    input wire [31:0] PC_plus_4, // PC + 4 from fetch stage

    // output
    output reg [31:0] PC_IFID_in  // Program counter output to fetch stage
);

    // Internal register for next PC value
    reg [31:0] next_PC;

    // Determine next PC value based on control signals
    always @(*) begin
        if (branch && takeBranch) begin
            next_PC = branch_PC; // Take branch
        end 
        else if (jumpAL) begin
            next_PC = branch_PC; // Jump instruction
        end 
        else begin
            next_PC = PC_plus_4; // Default: Increment PC by 4
        end
    end

    // Update PC at every clock edge if PC_enable is high, or reset on rst_n
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            PC_IFID_in <= 32'h0;
        else if (PC_enable)
            PC_IFID_in <= next_PC; // Update PC to next_PC if enabled
    end

endmodule
