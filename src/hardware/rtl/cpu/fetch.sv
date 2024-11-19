import pc_defnitions::*;

module fetch (
    // inputs 
    input wire clk,
    input wire rst_n,
    input wire PC_enable,           // Enable signal for PC update
    input wire takeBranch,          // Signal to indicate if branch is taken
    input wire [31:0] branch_PC,    // Target address for branch/jump
    input flush,                    // inserts NOP
    input stall,                    // stalls instruction read
    // input wire [31:0] instr_mem_data, // Instruction fetched from external memory

    // outputs
    output reg [31:0] instruction_IFID_in, // Fetched instruction for IF/ID stage
    output reg [31:0] PC_IFID_in         // Current PC value
);

    // Declare instruction memory and load contents from the code we wish to execute. 
    reg [31:0] instr_mem[0:8191];
    wire [7:0] bank_rdata[0:3];

    dmem32 #(.FILENAME("init0.hex")) dmem_bank0 (.clk(clk), .rst_n(rst_n), .addr(PC_IFID_in[15:2]), .re(~stall), .we(1'b0), 
    .wdata(8'h00), .rdata(bank_rdata[0]));

    dmem32 #(.FILENAME("init1.hex")) dmem_bank1 (.clk(clk), .rst_n(rst_n), .addr(PC_IFID_in[15:2]), .re(~stall), .we(1'b0), 
    .wdata(8'h00), .rdata(bank_rdata[1]));

    dmem32 #(.FILENAME("init2.hex")) dmem_bank2 (.clk(clk), .rst_n(rst_n), .addr(PC_IFID_in[15:2]), .re(~stall), .we(1'b0), 
    .wdata(8'h00), .rdata(bank_rdata[2]));

    dmem32 #(.FILENAME("init3.hex")) dmem_bank3 (.clk(clk), .rst_n(rst_n), .addr(PC_IFID_in[15:2]), .re(~stall), .we(1'b0), 
    .wdata(8'h00), .rdata(bank_rdata[3]));

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

    assign instruction_IFID_in = {bank_rdata[3], bank_rdata[2], bank_rdata[1], bank_rdata[0]};
endmodule

