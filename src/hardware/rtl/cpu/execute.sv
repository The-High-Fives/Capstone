import alu_definitions::*;

module execute
(
    input clk,
    input rst_n,
    // control signals
    input ALUSrc,
    input alu_ctrl_t ALU_ctrl,

    input [1:0] forward_rs1,
    input [1:0] forward_rs2,

    // datapath
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [31:0] imm,

    input [31:0] m_data,
    input [31:0] w_data,

    output [31:0] alu_out,
    output [31:0] mem_data
);

    logic [31:0] alu_op1, alu_op2, alu_result;
    logic alu_src; 

    always_comb begin
        unique case (forward_rs1)
            2'b00: alu_op1 = m_data;
            2'b01: alu_op1 = w_data;
            2'b10: alu_op1 = rs1_data;
        endcase
    end
     
    always_comb begin
        unique case (forward_rs2)
            2'b00: alu_op2 = m_data;
            2'b01: alu_op2 = w_data;
            2'b10: alu_op2 = ALUSrc ? imm : rs2_data;
        endcase
    end

    alu u_alu (
        .alu_op1       (alu_op1),
        .alu_op2       (alu_op2),
        .alu_ctrl      (ALU_ctrl),
        .alu_result    (alu_result),
    );  

endmodule