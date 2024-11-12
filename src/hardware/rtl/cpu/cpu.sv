`include "definitions.svh"
import alu_definitions::*;
import br_definitions::*;
import sext_definitions::*;
import pc_defnitions::*;
import mem_definitions::*;

module cpu
(
    input clk,
    input rst_n
);

// signal declarations
wire [31:0] PC_IFID_in, instruction_IFID_in;
wire [31:0] id_instru;
wire [31:0] id_pc, ex_pc;
wire [31:0] id_rs1_data, ex_rs1_data;
wire [31:0] id_rs2_data, ex_rs2_data;
wire [31:0] id_sext_out, ex_sext_out, m_sext_out;
wire [31:0] ex_alu_out, m_alu_out;
wire [31:0] ex_pc_inc_out, m_pc_inc_out;
wire [31:0] ex_mem_data, m_mem_data;
wire [31:0] read_data_MEMWB, wb_read_data;
wire [31:0] reg_data_MEMWB, wb_reg_data;
wire [4:0] id_rs1, ex_rs1;
wire [4:0] id_rs2, ex_rs2, m_rs2;
wire [4:0] id_rd, ex_rd, m_rd;
wire [1:0] ex_forward_rs1, ex_forward_rs2;
alu_ctrl_t id_ALU_ctrl, ex_ALU_ctrl;
br_func_t id_br_func, ex_br_func;
pc_source_t id_pc_source, ex_pc_source;
mem_mask_t id_Mmask, ex_Mmask, m_Mmask, wb_Mmask;
wire [1:0] m_bank_select, wb_bank_select;
wire [31:0] ex_br_jal_addr;
// fowarding signals
wire [31:0] ex_m_data, ex_w_data;

wire [31:0] writedata;
logic [31:0] wb_ldata;   // data to writeback after load
wire [4:0] write_rd;

wire load_use_hazard; // stall for load data hazard
wire stall_mem; // stall until memory write or read completes
wire stall_if, stall_id, stall_ex, stall_m;
wire if_id_flush;
wire id_ex_flush;
wire takeBranch;

assign stall_if = load_use_hazard | stall_mem;
assign stall_id = load_use_hazard | stall_mem;
assign stall_ex = stall_mem;
assign stall_m = stall_mem;

assign if_id_flush = takeBranch;
assign id_ex_flush = takeBranch;

assign PC_enable = ~stall_if;

assign m_bank_select = m_alu_out[1:0];

fetch u_fetch (
    // inputs
    .clk                    (clk),
    .rst_n                  (rst_n),
    .PC_enable              (PC_enable),
    .takeBranch             (takeBranch),
    .branch_PC              (ex_br_jal_addr),
    .stall                  (stall_if),
    .flush                  (if_id_flush),
    // .instr_mem_data         (instr_mem_data),
    // outputs
    .instruction_IFID_in    (instruction_IFID_in),
    .PC_IFID_in             (PC_IFID_in)
);

if_id_buffer u_if_id_buffer (
    .clk               (clk),
    .rst_n             (rst_n),
    .stall             (stall_if),
    .flush             (if_id_flush),
    .instruction_IF    (instruction_IFID_in),
    .pc_in             (PC_IFID_in),
    .instruction_ID    (id_instru),
    .pc_out            (id_pc)
);

decode u_decode (
    .clk            (clk),
    .rst_n          (rst_n),
    .instru         (id_instru),
    .pc             (id_pc),

    // writeback
    .writedata      (writedata),
    .write_rd       (write_rd),
    .wb_RegWrite    (wb_RegWrite),

    // outputs
    .rs1_data       (id_rs1_data),
    .rs2_data       (id_rs2_data),
    .sext_out       (id_sext_out),
    // control signals
    .id_MemToReg    (id_MemToReg),
    .id_RegWrite    (id_RegWrite),
    .id_JAL         (id_JAL),
    .id_LUI         (id_LUI),
    .id_MemWrite    (id_MemWrite),
    .id_MemRead     (id_MemRead),
    .id_Mmask       (id_Mmask),
    .id_ALU_pc      (id_ALU_pc),
    .id_ALU_imm     (id_ALU_imm),
    .id_JAL_addr    (id_JAL_addr),
    .id_ALU_ctrl    (id_ALU_ctrl),
    .id_br_func     (id_br_func),
    .id_pc_source   (id_pc_source),
    .id_rs1         (id_rs1),
    .id_rs2         (id_rs2),
    .id_rd          (id_rd)
);

id_ex_buffer u_id_ex_buffer (
    .clk            (clk),
    .rst_n          (rst_n),
    .stall          (stall_id),
    .flush          (id_ex_flush),
    // control 
    .id_rs1         (id_rs1),
    .id_rs2         (id_rs2),
    .id_rd          (id_rd),
    .ex_rs1         (ex_rs1),
    .ex_rs2         (ex_rs2),
    .ex_rd          (ex_rd),
    // writeback
    .id_MemToReg    (id_MemToReg),
    .id_RegWrite    (id_RegWrite),
    .ex_MemToReg    (ex_MemToReg),
    .ex_RegWrite    (ex_RegWrite),
    // memory
    .id_MemWrite    (id_MemWrite),
    .id_MemRead     (id_MemRead),
    .id_Mmask       (id_Mmask),
    .id_JAL         (id_JAL),
    .id_LUI         (id_LUI),
    .ex_MemWrite    (ex_MemWrite),
    .ex_MemRead     (ex_MemRead),
    .ex_Mmask       (ex_Mmask),
    .ex_JAL         (ex_JAL),
    .ex_LUI         (ex_LUI),
    // execute
    .id_ALU_ctrl    (id_ALU_ctrl),
    .id_ALU_pc      (id_ALU_pc),
    .id_ALU_imm     (id_ALU_imm),
    .id_br_func     (id_br_func),
    .id_JAL_addr    (id_JAL_addr),
    .id_pc_source   (id_pc_source),
    .ex_ALU_ctrl    (ex_ALU_ctrl),
    .ex_ALU_pc      (ex_ALU_pc),
    .ex_ALU_imm     (ex_ALU_imm),
    .ex_br_func     (ex_br_func),
    .ex_JAL_addr    (ex_JAL_addr),
    .ex_pc_source   (ex_pc_source),
    // datapath
    .id_pc          (id_pc),
    .id_rs1_data    (id_rs1_data),
    .id_rs2_data    (id_rs2_data),
    .id_sext_out    (id_sext_out),
    .ex_pc          (ex_pc),
    .ex_rs1_data    (ex_rs1_data),
    .ex_rs2_data    (ex_rs2_data),
    .ex_sext_out    (ex_sext_out)
);

execute u_execute (
    // control signals
    .ex_ALU_pc         (ex_ALU_pc),
    .ex_ALU_imm        (ex_ALU_imm),
    .ex_ALU_ctrl       (ex_ALU_ctrl),
    .ex_JAL_addr       (ex_JAL_addr),
    .ex_pc_source      (ex_pc_source),
    .ex_br_func        (ex_br_func),
    .ex_forward_rs1    (ex_forward_rs1),
    .ex_forward_rs2    (ex_forward_rs2),
    // datapath
    .ex_rs1_data       (ex_rs1_data),
    .ex_rs2_data       (ex_rs2_data),
    .ex_imm            (ex_sext_out),
    .ex_pc             (ex_pc),
    .ex_m_data         (reg_data_MEMWB),
    .ex_w_data         (writedata),
    // outputs
    .ex_alu_out        (ex_alu_out),
    .ex_pc_inc_out     (ex_pc_inc_out),
    .ex_mem_data       (ex_mem_data), 
    .ex_br_jal_addr    (ex_br_jal_addr),
    .takeBranch        (takeBranch)
);

ex_m_buffer u_ex_m_buffer (
    .clk             (clk),
    .rst_n           (rst_n),
    .stall           (stall_ex),
    .flush           (load_use_hazard),
    // control signals
    // writeback
    .ex_MemToReg      (ex_MemToReg),
    .ex_RegWrite      (ex_RegWrite),
    .m_MemToReg       (m_MemToReg),
    .m_RegWrite       (m_RegWrite),
    // memory
    .ex_MemWrite      (ex_MemWrite),
    .ex_MemRead       (ex_MemRead),
    .ex_JAL           (ex_JAL),
    .ex_LUI           (ex_LUI),
    .ex_Mmask         (ex_Mmask),
    .m_MemWrite       (m_MemWrite),
    .m_MemRead        (m_MemRead),
    .m_JAL            (m_JAL),
    .m_LUI            (m_LUI),
    .m_Mmask          (m_Mmask),
    .ex_rs2           (ex_rs2),
    .ex_rd            (ex_rd),
    .m_rs2            (m_rs2),
    .m_rd             (m_rd),
    // datapath
    .ex_alu_out       (ex_alu_out),
    .ex_mem_data      (ex_mem_data),
    .ex_sext_out      (ex_sext_out),
    .ex_pc_inc_out    (ex_pc_inc_out),
    .m_alu_out        (m_alu_out),
    .m_mem_data       (m_mem_data),
    .m_sext_out       (m_sext_out),
    .m_pc_inc_out     (m_pc_inc_out)
);

memory u_memory (
    .clk                (clk),
    .rst_n              (rst_n),
    .m_MemRead          (m_MemRead),
    .m_MemWrite         (m_MemWrite),
    .m_JAL              (m_JAL),
    .m_LUI              (m_LUI),
    .m_mem_type         (m_Mmask),
    .m_alu_out          (m_alu_out),
    .m_mem_data         (m_mem_data),
    .wb_data            (writedata),
    .wb_forward         (wb_forward),
    .m_imm              (m_sext_out),
    .m_pc_inc           (m_pc_inc_out),
    .m_rd               (m_rd),
    .stall_mem          (stall_mem),
    .read_data_MEMWB    (read_data_MEMWB),
    .reg_data_MEMWB     (reg_data_MEMWB)
);

mem_wb_buffer u_mem_wb_buffer (
    .clk             (clk),
    .rst_n           (rst_n),
    .stall           (stall_m),
    .m_MemToReg      (m_MemToReg),
    .m_RegWrite      (m_RegWrite),
    .m_read_data     (read_data_MEMWB),
    .m_reg_data      (reg_data_MEMWB),
    .m_rd            (m_rd),
    .m_Mmask         (m_Mmask),
    .m_bank_select   (m_bank_select),
    .wb_read_data    (wb_read_data),
    .wb_reg_data     (wb_reg_data),
    .wb_rd           (write_rd),
    .wb_RegWrite     (wb_RegWrite),
    .wb_MemToReg     (wb_MemToReg),
    .wb_Mmask        (wb_Mmask),
    .wb_bank_select  (wb_bank_select)
);

forwardToEX u_forwardToEX (
    .ex_rs1              (ex_rs1),
    .ex_rs2              (ex_rs2),
    .m_rd                (m_rd),
    .wb_rd               (write_rd),
    .we_EXMEM            (m_RegWrite),
    .we_MEMWB            (wb_RegWrite),
    .MemRead_EXMEM       (m_MemRead),
    .ex_ALU_pc           (ex_ALU_pc),
    .ex_ALU_imm          (ex_ALU_imm),
    .ex_br_func          (ex_br_func),

    .ALU_1_forward_EX    (ex_forward_rs1),
    .ALU_2_forward_EX    (ex_forward_rs2),
    .load_use_hazard     (load_use_hazard)
);

forwardToMem u_forwardToMem (
    .m_rs2                 (m_rs2),
    .wb_rd                 (write_rd),
    .we_MEMWB              (wb_RegWrite),
    .memWrite_EXMEM        (m_MemWrite),
    .RegData2_forward_M    (wb_forward)
);

// writeback
always_comb begin
    wb_ldata = 32'h00000000;

    unique case (wb_Mmask)
        // LB (signed)
        MEM_BYTE: begin
            case (wb_bank_select)
                2'b00: begin 
                    wb_ldata = {{24{wb_read_data[7]}}, wb_read_data[7:0]};
                end

                2'b01: begin 
                    wb_ldata = {{24{wb_read_data[15]}}, wb_read_data[15:8]}; 
                end

                2'b10: begin 
                    wb_ldata = {{24{wb_read_data[23]}}, wb_read_data[23:16]}; 
                end

                2'b11: begin 
                    wb_ldata = {{24{wb_read_data[31]}}, wb_read_data[31:24]}; 
                end
            endcase
        end

        // LH (signed)
        MEM_HALF: begin
            if (wb_bank_select[1]) begin // upper 16 bits
                wb_ldata = {{16{wb_read_data[31]}}, wb_read_data[31:16]};
            end 
            else begin  // lower 16 bits
                wb_ldata = {{16{wb_read_data[15]}}, wb_read_data[15:0]};
            end
        end

        // LW
        MEM_WORD: begin
            wb_ldata = wb_read_data;
        end

        // LBU (zero-extended)
        MEM_UBYTE: begin
            case (wb_bank_select)
                2'b00: begin 
                    wb_ldata = {24'h0, wb_read_data[7:0]}; 
                end
                2'b01: begin 
                    wb_ldata = {24'h0, wb_read_data[15:8]};
                end
                2'b10: begin 
                    wb_ldata = {24'h0, wb_read_data[23:16]}; 
                end
                2'b11: begin 
                    wb_ldata = {24'h0, wb_read_data[31:24]}; 
                end
            endcase
        end

        // LHU (zero-extended)
        MEM_UHALF: begin
            if (wb_bank_select[1]) begin // upper 16 bits
                wb_ldata = {16'h0, wb_read_data[31:16]};
            end 
            else begin  // lower 16 bits
                wb_ldata = {16'h0, wb_read_data[15:0]};
            end
        end
    endcase
end

assign writedata = wb_MemToReg ? wb_ldata : wb_reg_data;

endmodule