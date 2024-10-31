module ex_m_buffer
(
    // control signals
    // writeback
    input ex_MemToReg,
    input ex_RegWrite,
    output logic m_MemToReg,
    output logic m_RegWrite,

    // memory
    input ex_MemWrite,
    input ex_MemRead,
    input ex_JAL,
    input ex_LUI,
    output logic m_MemWrite,
    output logic m_MemRead,
    output logic m_JAL,
    output logic m_LUI,

    input [4:0] ex_rs2,
    input [4:0] ex_rd,
    output logic [4:0] m_rs2,
    output logic [4:0] m_rd,

    // datapath
    input [31:0] ex_alu_out,
    input [31:0] ex_mem_data,
    input [31:0] ex_sext_out,
    input [31:0] ex_pc_inc_out,
    output logic [31:0] m_alu_out,
    output logic [31:0] m_mem_data
    output logic [31:0] m_sext_out,
    output logic [31:0] m_pc_inc_out,
);

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            m_MemToReg <= 0;
            m_RegWrite <= 0;
            m_JAL <= 0;
            m_LUI <= 0;
            m_MemWrite <= 0;
            m_MemRead <= 0;
            m_rs2 <= 0;
            m_rd <= 0;
            m_alu_out <= 0;
            m_mem_data <= 0;
        end
        else begin
            m_MemToReg <= ex_MemToReg;
            m_RegWrite <= ex_RegWrite;
            m_JAL = ex_JAL;
            m_LUI = ex_LUI;
            m_MemWrite <= ex_MemWrite;
            m_MemRead <= ex_MemRead;
            m_rs2 <= ex_rs2;
            m_rd <= ex_rd;
            m_alu_out <= ex_alu_out;
            m_mem_data <= ex_mem_data;
        end
    end

endmodule