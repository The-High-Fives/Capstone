`include "definitions.svh"

module control
(
    input [6:0] opcode,
    input [14:12] funct3,
    input [31:25] funct7,

    // writeback
    output logic MemToReg,  // 1: selects memory output for register writeback
    output logic RegWrite,  // enables register write
    // memory
    output logic MemWrite,  // enables memory write
    output logic MemRead,   // enables memory read
    output logic JAL,       // selects JAL source for writeback
    output logic LUI,       // selects LUI source for writeback
    // execute
    output alu_ctrl_t ALU_ctrl, // alu function
    output logic ALU_pc,    // 0: register source for alu_op1, 1: PC into alu_op1
    output logic ALU_imm,   // 0: register source for alu_op2, 1: immediate source for alu_op2
    output br_func_t br_func,
    output logic JAL_addr,  // 0: calculate JALR address, 1: calculate JAL address
    // decode
    output sext_ctrl_t sext_op,
    // fetch
    output pc_source_t pc_source
);

    always_comb begin
        // defaults
        br_func = BR_NONE;
        JAL_addr = 1'bx;

        MemToReg = 1'bx;
        RegWrite = 1'b0;
        JAL = 1'bx;
        LUI = 1'bx;

        MemWrite = 1'b0;
        MemRead = 1'b0;

        ALU_ctrl = ALU_ADD;
        ALU_pc = 1'bx;
        ALU_imm = 1'bx;

        sext_op = sext_I_type;

        pc_source = PC_INC;

        unique case (opcode)
            OPCODE_REG: begin
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                JAL = 1'b0;
                LUI = 1'b0;
                ALU_pc = 1'b0;
                ALU_imm = 1'b0;

                unique case (funct3)
                    FUNCT3_ADD_SUB: ALU_ctrl = (FUNC7_SUB_SRA == funct7) ? ALU_SUB : ALU_ADD;
                    FUNCT3_XOR: ALU_ctrl = ALU_XOR;
                    FUNCT3_OR: ALU_ctrl = ALU_OR;
                    FUNCT3_AND: ALU_ctrl = ALU_AND;
                    FUNCT3_SLL: ALU_ctrl = ALU_SLL;
                    FUNCT3_SRL_SRA: ALU_ctrl = (FUNC7_SUB_SRA == funct7) ? ALU_SRA : ALU_SRL;
                    FUNCT3_SLT: ALU_ctrl = ALU_SLT;
                    FUNCT3_SLTU: ALU_ctrl = ALU_SLTU;
                endcase
            end

            OPCODE_IMM: begin
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                JAL = 1'b0;
                LUI = 1'b0;
                ALU_pc = 1'b0;
                ALU_imm = 1'b1;

                unique case (funct3)
                    FUNCT3_ADD_SUB: ALU_ctrl = ALU_ADD;
                    FUNCT3_XOR: ALU_ctrl = ALU_XOR;
                    FUNCT3_OR: ALU_ctrl = ALU_OR;
                    FUNCT3_AND: ALU_ctrl = ALU_AND;
                    FUNCT3_SLL: ALU_ctrl = ALU_SLL;
                    FUNCT3_SRL_SRA: ALU_ctrl = (FUNC7_SUB_SRA == funct7) ? ALU_SRA : ALU_SRL;
                    FUNCT3_SLT: ALU_ctrl = ALU_SLT;
                    FUNCT3_SLTU: ALU_ctrl = ALU_SLTU;
                endcase
            end

            OPCODE_LOAD: begin
                MemToReg = 1'b1;
                MemRead = 1'b1;
                RegWrite = 1'b1;
                ALU_pc = 1'b0;
                ALU_imm = 1'b1;
                ALU_ctrl = ALU_ADD;
            end

            OPCODE_STORE: begin
                MemWrite = 1'b1;
                ALU_pc = 1'b0;
                ALU_imm = 1'b1;
                ALU_ctrl = ALU_ADD;
                sext_op = sext_S_type;
            end

            OPCODE_BRANCH: begin
                pc_source = PC_BR;
                case (funct3)
                    FUNCT3_BEQ: br_func = BR_BEQ;
                    FUNCT3_BNE: br_func = BR_BNE;
                    FUNCT3_BLT: br_func = BR_BLT;
                    FUNCT3_BGE: br_func = BR_BGE;
                    FUNCT3_BLTU: br_func = BR_BLTU;
                    FUNCT3_BGEU: br_func = BR_BGEU;
                endcase
            end

            OPCODE_JAL: begin
                pc_source = PC_JAL;
                JAL_addr = 0;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                JAL = 1'b1;
                LUI = 1'b0;
            end

            OPCODE_JALR: begin
                pc_source = PC_JAL;
                JAL_addr = 1;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                JAL = 1'b1;
                LUI = 1'b0;
            end

            OPCODE_LUI: begin
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                JAL = 1'b0;
                LUI = 1'b1;
                sext_op = sext_U_type
            end
            
            OPCODE_AUIPC: begin
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                JAL = 1'b0;
                LUI = 1'b0;
                ALU_pc = 1'b1;
                ALU_imm = 1'b1;
                sext_op = sext_U_type 
            end

            // OPCODE_EXCEPTION: begin
                
            // end
        endcase
    end
endmodule