module id_ex_buffer 
(
    input clk,
    input rst_n,
    input flush,
    input stall,

    // control 
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input [4:0] id_rd,
    output logic [4:0] ex_rs1,
    output logic [4:0] ex_rs2,
    output logic [4:0] ex_rd
    // writeback
    input id_MemToReg,
    input id_RegWrite,
    output logic ex_MemToReg,
    output logic ex_RegWrite, 
    // memory
    input id_MemWrite,
    input id_MemRead,
    input id_JAL,
    input id_LUI,
    output logic ex_MemWrite,
    output logic ex_MemRead,
    output logic ex_JAL,
    output logic ex_LUI,
    // execute
    input alu_ctrl_t id_ALU_ctrl,
    input id_ALU_pc,
    input id_ALU_imm,
    input br_func_t id_br_func,
    input id_JAL_addr,
    input pc_source_t id_pc_source
    output alu_ctrl_t ex_ALU_ctrl,
    output logic ex_ALU_pc,
    output logic ex_ALU_imm,
    output br_func_t ex_br_func,
    output logic ex_JAL_addr,
    output pc_source_t ex_pc_source,

    // datapath
    input [31:0] id_pc,
    input [31:0] id_rs1_data,
    input [31:0] id_rs2_data,
    input [31:0] id_sext_out,    
    output logic [31:0] ex_pc,
    output logic [31:0] ex_rs1_data,
    output logic [31:0] ex_rs2_data,
    output logic [31:0] ex_sext_out
);

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            ex_rs1 <= 0;
            ex_rs2 <= 0;
            ex_rd <= 0;
            ex_MemToReg <= 0;
            ex_RegWrite <= 0;
            ex_MemWrite <= 0;
            ex_MemRead <= 0;
            ex_JAL <= 0;
            ex_LUI <= 0;
            ex_ALU_ctrl <= ALU_ADD;
            ex_ALU_pc <= 0;
            ex_ALU_imm <= 0;
            ex_br_func <= 0;
            ex_JAL_addr <= 0;
            ex_pc <= 0;
            ex_rs1_data <= 0;
            ex_rs2_data <= 0;
            ex_sext_out <= 0;
            ex_pc_source <= PC_INC;
        end
        else if (!stall) begin
            if (flush) begin
                ex_rs1 <= 0;
                ex_rs2 <= 0;
                ex_rd <= 0;
                //ex_MemToReg <= id_MemToReg;
                ex_RegWrite <= 0;
                ex_MemWrite <= 0;
                ex_MemRead <= 0;
                ex_JAL <= 0;
                ex_LUI <= 0;
                ex_ALU_ctrl <= ALU_ADD;
                ex_ALU_pc <= 0;
                ex_ALU_imm <= 0;
                ex_br_func <= BR_NONE;
                ex_JAL_addr <= 0;
                // ex_pc <= id_pc;
                // ex_rs1_data <= id_rs1_data;
                // ex_rs2_data <= id_rs2_data;
                // ex_sext_out <= id_sext_out;
                // ex_pc_source <= id_pc_source;
            end
            else begin
                ex_rs1 <= id_rs1;
                ex_rs2 <= id_rs2;
                ex_rd <= id_rd;
                ex_MemToReg <= id_MemToReg;
                ex_RegWrite <= id_RegWrite;
                ex_MemWrite <= id_MemWrite;
                ex_MemRead <= id_MemRead;
                ex_JAL <= id_JAL;
                ex_LUI <= id_LUI;
                ex_ALU_ctrl <= id_ALU_ctrl;
                ex_ALU_pc <= id_ALU_pc;
                ex_ALU_imm <= id_ALU_imm;
                ex_br_func <= id_br_func;
                ex_JAL_addr <= id_JAL_addr;
                ex_pc <= id_pc;
                ex_rs1_data <= id_rs1_data;
                ex_rs2_data <= id_rs2_data;
                ex_sext_out <= id_sext_out;
                ex_pc_source <= id_pc_source;
            end
        end
    end
endmodule