`include "definitions.svh"

module decode
(
    input clk,
    input rst_n,
    input [31:0] instru,
    input [31:0] pc,

    // writeback
    input [31:0] writedata,
    input [4:0] write_rd,
    input wb_RegWrite,

    // outputs
    output [31:0] rs1_data,
    output [31:0] rs2_data,
    output logic [31:0] sext_out,

    // control signals
    output id_MemToReg,
    output id_RegWrite,
    output id_JAL,
    output id_LUI,
    output id_MemWrite,
    output id_MemRead,
    output id_ALU_pc,
    output id_ALU_imm,
    output id_JAL_addr,
    output alu_ctrl_t id_ALU_ctrl,
    output br_func_t id_br_func,
    output pc_source_t id_pc_source, 

    output [4:0] id_rs1,
    output [4:0] id_rs2,
    output [4:0] id_rd
);

    logic [31:0] reg_file [31:0];
    logic [4:0] rs1, rs2;

    // register file 
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            for (int i=0; i<32; i=i+1) begin
                reg_file[i] <= 0;
            end
        end
        else if (wb_RegWrite) begin
            reg_file[write_rd] <= writedata;
        end
    end

    // instruction breakdown
    assign rs1 = instru[19:15];
    assign rs2 = instru[24:20];

    control u_control (
        .opcode      (instru[6:0]),
        .funct3      (instru[14:12]),
        .funct7      (instru[31:25]),

        // TODO FIX
        .MemToReg    (id_MemToReg),
        .RegWrite    (id_RegWrite),
 
        .JAL         (id_JAL),
        .LUI         (id_LUI),
        .MemWrite    (id_MemWrite),
        .MemRead     (id_MemRead),

        .ALU_ctrl    (id_ALU_ctrl),
        .ALU_pc      (id_ALU_pc),
        .ALU_imm     (id_ALU_imm),
        .br_func     (id_br_func),
        .JAL_addr    (id_JAL_addr),

        .sext_op     (sext_op),
        .pc_source   (id_pc_source),
    );

    always_comb begin
        unique case (sext_op)
            sext_I_type: sext_out = {{20{instru[31]}}, instru[31:20]};
            sext_U_type: sext_out = {instru[31:12], 12'h000};
            sext_S_type: sext_out = {{20{instru[31]}}, instru[31:25], instru[11:7]};
            sext_J_type: sext_out = {{12{instru[31]}}, instru[19:12], instru[20], instru[30:21], 1'b0};
            sext_B_type: sext_out = {{20{instru[31]}}, instru[7], instru[30:25], instru[11:8], 1'b0};
        endcase
    end

    // stall

    // rf bypassing
    assign rs1_data = (wb_RegWrite && (rs1 == write_rd)) ? writedata : reg_file[rs1];
    assign rs2_data = (wb_RegWrite && (rs2 == write_rd)) ? writedata : reg_file[rs2];
 
endmodule