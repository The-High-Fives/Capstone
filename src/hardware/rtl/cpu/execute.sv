`include "definitions.svh"
import alu_definitions::*;
import br_definitions::*;
import pc_defnitions::*;

module execute
(
    // control signals
    input ex_ALU_imm,
    input ex_ALU_pc,
    input alu_ctrl_t ex_ALU_ctrl,
    input ex_JAL_addr,
    input pc_source_t ex_pc_source,
    input br_func_t ex_br_func,

    input [1:0] ex_forward_rs1,
    input [1:0] ex_forward_rs2,

    // datapath
    input [31:0] ex_rs1_data,
    input [31:0] ex_rs2_data,
    input [31:0] ex_imm,
    input [31:0] ex_pc,

    input [31:0] ex_m_data,
    input [31:0] ex_w_data,

    // outputs
    output [31:0] ex_alu_out,
    output [31:0] ex_pc_inc_out,
    output [31:0] ex_mem_data,
    output logic [31:0] ex_br_jal_addr,
    output logic takeBranch
);

    logic [31:0] rs1_data, rs2_data;
    logic [31:0] alu_op1, alu_op2;
    logic alu_src; 
    logic br_taken; // 1 if branch function is true
    wire [31:0] ex_br_addr, ex_jal_addr;

    // forwarding
    always_comb begin
        unique case (ex_forward_rs1)
            2'b00: rs1_data = ex_m_data;
            2'b01: rs1_data = ex_w_data;
            2'b10: rs1_data = ex_rs1_data;
        endcase
    end
    always_comb begin
        unique case (ex_forward_rs2)
            2'b00: rs2_data = ex_m_data;
            2'b01: rs2_data = ex_w_data;
            2'b10: rs2_data = ex_rs2_data;
        endcase
    end

    // select alu sources
    assign alu_op1 = ex_ALU_pc ? ex_pc : rs1_data;
    assign alu_op2 = ex_ALU_imm ? ex_imm : rs2_data;

    alu u_alu (
        .alu_op1       (alu_op1),
        .alu_op2       (alu_op2),
        .alu_ctrl      (ex_ALU_ctrl),
        .alu_result    (ex_alu_out)
    );  

    // branch resolve
    always_comb begin
        unique case (ex_br_func)
            BR_BEQ: br_taken = (rs1_data == rs2_data);
            BR_BNE: br_taken = (rs1_data != rs2_data);
            BR_NONE: br_taken = 0;
            BR_BLT: br_taken = ($signed(rs1_data) < $signed(rs2_data));
            BR_BGE: br_taken = ($signed(rs1_data) >= $signed(rs2_data));
            BR_BLTU: br_taken = (rs1_data <= rs2_data);
            BR_BGEU: br_taken = (rs1_data >= rs2_data);
        endcase
    end

    // pc source
    always_comb begin
        unique case (ex_pc_source) 
            PC_INC: begin
                takeBranch = 0;
                ex_br_jal_addr = 32'hxxxxxxxx;
            end
            PC_BR: begin
                takeBranch = br_taken;
                ex_br_jal_addr = ex_br_addr;
            end
            PC_JAL: begin
                takeBranch = 1'b1;
                ex_br_jal_addr = ex_jal_addr;
            end
        endcase
    end

    // branch address
    assign ex_br_addr = ex_pc + ex_imm;

    // jal address
    assign ex_jal_addr = (ex_JAL_addr ? ex_pc : rs1_data) + ex_imm;
    
    assign ex_mem_data = rs2_data;
    assign ex_pc_inc_out = ex_pc + 4;
endmodule