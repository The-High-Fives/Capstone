module mem_wb_buffer (
    input logic clk,
    input logic rst_n,

    // Control signals from MEM stage
    input logic m_MemToReg,       
    input logic m_RegWrite,       

    // Data from MEM stage
    input logic [31:0] m_alu_out,      
    input logic [31:0] m_mem_data, // Data read from memory
    input logic [4:0] m_rd,

    // Forwarded data to WB stage
    output logic [31:0] wb_data, // Data to write back to register
    output logic [4:0] wb_rd,          
    output logic wb_RegWrite // Write enable for register in WB stage
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wb_data <= 32'd0;
            wb_rd <= 5'd0;
            wb_RegWrite <= 1'b0;
        end 
        else begin
            // Select either memory or ALU result based on MemToReg control signal
            wb_data <= m_MemToReg ? m_mem_data : m_alu_out;
            wb_rd <= m_rd;
            wb_RegWrite <= m_RegWrite;
        end
    end

endmodule
