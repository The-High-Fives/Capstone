// opcodes
localparam OPCODE_REG			=7'b0110011;
localparam OPCODE_IMM			=7'b0010011;
localparam OPCODE_LOAD			=7'b0000011;
localparam OPCODE_STORE			=7'b0100011;
localparam OPCODE_BRANCH		=7'b1100011;
localparam OPCODE_JAL			=7'b1101111;
localparam OPCODE_JALR			=7'b1100111;
localparam OPCODE_LUI			=7'b0110111;
localparam OPCODE_AUIPC			=7'b0010111;
localparam OPCODE_EXCEPTION		=7'b1110011;

// funct3 REG
localparam FUNCT3_ADD_SUB		=3'b000;
localparam FUNCT3_XOR			=3'b100;
localparam FUNCT3_OR			=3'b110;
localparam FUNCT3_AND			=3'b111;
localparam FUNCT3_SLL			=3'b001;
localparam FUNCT3_SRL_SRA		=3'b101;
localparam FUNCT3_SLT			=3'b010;
localparam FUNCT3_SLTU			=3'b011;

// funct7 REG
localparam FUNC7_DEFAULT		=7'b0000000;
localparam FUNC7_SUB_SRA		=7'b0100000;

// funct3 IMM
localparam FUNCT3_ADDI			=3'b000;
localparam FUNCT3_XORI			=3'b100;
localparam FUNCT3_ORI			=3'b110;
localparam FUNCT3_ANDI			=3'b111;
localparam FUNCT3_SLLI			=3'b001;
localparam FUNCT3_SRLI_SRAI		=3'b101;
localparam FUNCT3_SLTI			=3'b010;
localparam FUNCT3_SLTIU			=3'b011;

// funct3 LOAD
localparam FUNCT3_LB			=3'b000;
localparam FUNCT3_LH			=3'b001;
localparam FUNCT3_LW			=3'b010;
localparam FUNCT3_LBU			=3'b100;
localparam FUNCT3_LHU			=3'b101;

// funct3 STORE
localparam FUNCT3_SB			=3'b000;
localparam FUNCT3_SH			=3'b001;
localparam FUNCT3_SW			=3'b010;
		
// funct3 BRANCH
localparam FUNCT3_BEQ			=3'b000;
localparam FUNCT3_BNE			=3'b001;
localparam FUNCT3_BLT			=3'b100;
localparam FUNCT3_BGE			=3'b101;
localparam FUNCT3_BLTU			=3'b110;
localparam FUNCT3_BGEU			=3'b111;

// opcodes
// `define OPCODE_REG			7'b0110011
// `define OPCODE_IMM			7'b0010011
// `define OPCODE_LOAD			7'b0000011
// `define OPCODE_STORE		7'b0100011
// `define OPCODE_BRANCH		7'b1100011
// `define OPCODE_JAL			7'b1101111
// `define OPCODE_JALR			7'b1100111
// `define OPCODE_LUI			7'b0110111
// `define OPCODE_AUIPC		7'b0010111
// `define OPCODE_EXCEPTION	7'b1110011

// // funct3 REG
// `define FUNCT3_ADD_SUB		3'b000
// `define FUNCT3_XOR			3'b100
// `define FUNCT3_OR			3'b110
// `define FUNCT3_AND			3'b111
// `define FUNCT3_SLL			3'b001
// `define FUNCT3_SRL_SRA		3'b101
// `define FUNCT3_SLT			3'b010
// `define FUNCT3_SLTU			3'b011

// // funct7 REG
// `define FUNC7_DEFAULT		7'b0000000
// `define FUNC7_SUB_SRA		7'h0100000

// // funct3 IMM
// `define FUNCT3_ADDI			3'b000
// `define FUNCT3_XORI			3'b100
// `define FUNCT3_ORI			3'b110
// `define FUNCT3_ANDI			3'b111
// `define FUNCT3_SLLI			3'b001
// `define FUNCT3_SRLI_SRAI	3'b101
// `define FUNCT3_SLTI			3'b010
// `define FUNCT3_SLTIU		3'b011

// // funct3 LOAD
// `define FUNCT3_LB			3'b000
// `define FUNCT3_LH			3'b001
// `define FUNCT3_LW			3'b010
// `define FUNCT3_LBU			3'b100
// `define FUNCT3_LHU			3'b101

// // funct3 STORE
// `define FUNCT3_SB			3'b000
// `define FUNCT3_SH			3'b001
// `define FUNCT3_SW			3'b010
		
// // funct3 BRANCH
// `define FUNCT3_BEQ			3'b000
// `define FUNCT3_BNE			3'b001
// `define FUNCT3_BLT			3'b100
// `define FUNCT3_BGE			3'b101
// `define FUNCT3_BLTU			3'b110
// `define FUNCT3_BGEU			3'b111