module mem_wb_buffer (
    input logic clk,
    input logic rst_n,
    input stall,

    // Control signals from MEM stage
    input logic m_MemToReg,       
    input logic m_RegWrite,       

    // Data from MEM stage
    input logic [31:0] m_read_data,      
    input logic [31:0] m_reg_data, // Data read from memory
    input logic [4:0] m_rd,

    // Forwarded data to WB stage
    output logic [31:0] wb_read_data, // Data to write back to register
    output logic [31:0] wb_reg_data,
    output logic [4:0] wb_rd,          
    output logic wb_RegWrite, // Write enable for register in WB stage
    output logic wb_MemToReg
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wb_read_data <= 32'd0;
            wb_reg_data <= 32'd0;
            wb_rd <= 5'd0;
            wb_RegWrite <= 1'b0;
            wb_MemToReg <= 1'b0
        end 
        else if (!stall) begin
            // Select either memory or ALU result based on MemToReg control signal
            wb_read_data <= m_read_data;
            wb_reg_data <= m_reg_data;
            wb_rd <= m_rd;
            wb_RegWrite <= m_RegWrite;
            wb_MemToReg <= m_MemToReg;
        end
    end

endmodule
