module cpu
(
    input clk,
    input rst_n
);


wire [31:0] id_instru;
wire [31:0] id_pc, ex_pc;
wire [31:0] id_rs1_data, ex_rs1_data;
wire [31:0] id_rs2_data, ex_rs2_data;
wire [31:0] id_sext_out, ex_sext_out;
wire [4:0] id_rs1, ex_rs1;
wire [4:0] id_rs2, ex_rs2;
wire [4:0] id_rd, ex_rd;
alu_ctrl_t id_ALU_ctrl, ex_ALU_ctrl;
br_func_t id_br_func, ex_br_func;
pc_source_t id_pc_source, ex_pc_source;

// fowarding signals
wire [31:0] ex_m_data, ex_w_data;

wire [31:0] writedata;
wire [4:0] write_rd;

fetch u_fetch (
    // inputs
    .clk                    (clk),
    .rst_n                  (rst_n),
    .PC_enable              (PC_enable),
    .takeBranch             (takeBranch),
    .branch_PC              (branch_PC),
    .instr_mem_data         (instr_mem_data),
    // outputs
    .PC_plus4_IFID_in       (PC_plus4_IFID_in),
    .instruction_IFID_in    (instruction_IFID_in),
    .PC_IFID_in             (PC_IFID_in),
);

decode u_decode (
    .clk            (clk),
    .rst_n          (rst_n),
    .instru         (id_instru),
    .pc             (id_pc),

    // writeback
    .writedata      (writedata),
    .write_rd       (write_rd),
    .wb_RegWrite    (wb_RegWrite)

    // outputs
    .rs1_data       (id_rs1_data),
    .rs2_data       (id_rs2_data),
    .sext_out       (sext_out),
    // control signals
    .id_MemToReg    (id_MemToReg),
    .id_RegWrite    (id_RegWrite),
    .id_JAL         (id_JAL),
    .id_LUI         (id_LUI),
    .id_MemWrite    (id_MemWrite),
    .id_MemRead     (id_MemRead),
    .id_ALU_pc      (id_ALU_pc),
    .id_ALU_imm     (id_ALU_imm),
    .id_JAL_addr    (id_JAL_addr),
    .id_ALU_ctrl    (id_ALU_ctrl),
    .id_br_func     (id_br_func),
    .id_pc_source    (id_pc_source),
    .id_rs1         (id_rs1),
    .id_rs2         (id_rs2),
    .id_rd          (id_rd)
);

id_ex_buffer u_id_ex_buffer (
    .clk            (clk),
    .rst_n          (rst_n),
    // control 
    .id_rs1         (id_rs1),
    .id_rs2         (id_rs2),
    .id_rd          (id_rd),
    .ex_rs1         (ex_rs1),
    .ex_rs2         (ex_rs2),
    // writeback
    .id_MemToReg    (id_MemToReg),
    .id_RegWrite    (id_RegWrite),
    .ex_MemToReg    (ex_MemToReg),
    .ex_RegWrite    (ex_RegWrite),
    // memory
    .id_MemWrite    (id_MemWrite),
    .id_MemRead     (id_MemRead),
    .id_JAL         (id_JAL),
    .id_LUI         (id_LUI),
    .ex_MemWrite    (ex_MemWrite),
    .ex_MemRead     (ex_MemRead),
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
    .ex_pc_source   (ex_pc_source)
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
    .clk               (clk),
    .rst_n             (rst_n),
    // control signals
    .ex_ALU_pc         (ex_ALU_pc),
    .ex_ALU_imm        (ex_ALU_imm),
    .ex_ALU_ctrl       (ex_ALU_ctrl),
    .ex_JAL_addr       (ex_JAL_addr),
    .ex_pc_source      (ex_pc_source),
    .ex_forward_rs1    (ex_forward_rs1),
    .ex_forward_rs2    (ex_forward_rs2),
    // datapath
    .ex_rs1_data       (ex_rs1_data),
    .ex_rs2_data       (ex_rs2_data),
    .ex_imm            (ex_sext_out),
    .ex_pc             (ex_pc),
    .ex_m_data         (ex_m_data),
    .ex_w_data         (ex_w_data),
    // outputs
    .ex_alu_out        (ex_alu_out),
    .ex_pc_inc_out     (ex_pc_inc_out),
    .ex_br_addr        (ex_br_addr),
    .ex_jal_addr       (ex_jal_addr),
    .pc_source         (pc_source),
    .flush             (flush),
    .stall             (stall)
);
endmodule