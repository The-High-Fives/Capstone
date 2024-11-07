module if_id_buffer (
    input wire clk,                  
    input wire rst_n,              
    input wire stall,
    input flush,
    
    // Inputs from Fetch stage
    input wire [31:0] instruction_IF, // Instruction fetched in IF stage
    input wire [31:0] pc_in, // Program counter from IF stage
    
    // Outputs to Decode stage
    output reg [31:0] instruction_ID,  // Instruction passed to ID stage
    output reg [31:0] pc_out // Program counter passed to ID stage
);
    assign instruction_ID = instruction_IF;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_out <= 32'b0;
        end else if (!stall) begin
            pc_out <= pc_in;
        end
    end
endmodule
