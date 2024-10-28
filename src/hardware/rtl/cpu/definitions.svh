// opcodes
`define OPCODE_REG			7'b0110011
`define OPCODE_IMM			7'b0010011
`define OPCODE_LOAD			7'b0000011
`define OPCODE_STORE		7'b0100011
`define OPCODE_BRANCH		7'b1100011
`define OPCODE_JAL			7'b1101111
`define OPCODE_JALR			7'b1100111
`define OPCODE_LUI			7'b0110111
`define OPCODE_AUIPC		7'b0010111
`define OPCODE_EXCEPTION	7'b1110011

// funct3 REG
`define FUNCT3_ADD_SUB		3'b000
`define FUNCT3_XOR			3'b100
`define FUNCT3_OR			3'b110
`define FUNCT3_AND			3'b111
`define FUNCT3_SLL			3'b001
`define FUNCT3_SRL_SRA		3'b101
`define FUNCT3_SLT			3'b010
`define FUNCT3_SLTU			3'b011

// funct7 REG
`define FUNC7_DEFAULT		7'b0000000
`define FUNC7_SUB_SRA		7'h0100000

// funct3 IMM
`define FUNCT3_ADDI			3'b000
`define FUNCT3_XORI			3'b100
`define FUNCT3_ORI			3'b110
`define FUNCT3_ANDI			3'b111
`define FUNCT3_SLLI			3'b001
`define FUNCT3_SRLI_SRAI	3'b101
`define FUNCT3_SLTI			3'b010
`define FUNCT3_SLTIU		3'b011

// funct3 LOAD
`define FUNCT3_LB			3'b000
`define FUNCT3_LH			3'b001
`define FUNCT3_LW			3'b010
`define FUNCT3_LBU			3'b100
`define FUNCT3_LHU			3'b101

// funct3 STORE
`define FUNCT3_SB			3'b000
`define FUNCT3_SH			3'b001
`define FUNCT3_SW			3'b010
		
// funct3 BRANCH
`define FUNCT3_BEQ			3'b000
`define FUNCT3_BNE			3'b001
`define FUNCT3_BLT			3'b100
`define FUNCT3_BGE			3'b101
`define FUNCT3_BLTU			3'b110
`define FUNCT3_BGEU			3'b111

package br_definitions;
	typedef enum logic [2:0] {
		BR_BEQ,
		BR_BNE,
		BR_NONE,	// DO NOT BRANCH
		BR_BLT = 3'b100,
		BR_BGE,
		BR_BLTU,
		BR_BGEU
	} br_func_t;
endpackage

package alu_definitions;
	typedef enum logic [3:0] {
		ALU_ADD,
		ALU_SUB,
		ALU_XOR,
		ALU_OR,
		ALU_AND,
		ALU_SLL,
		ALU_SRL,
		ALU_SRA,
		ALU_SLT,
		ALU_SLTU,
	} alu_ctrl_t;	
endpackage

package sext_definitions;
	typedef enum logic [1:0] {
		sext_I_type,	// sign extend immediate
		sext_U_type,	// left shift by 12
		sext_S_type
	} sext_ctrl_t;
endpackage

package pc_defnitions;
	typedef enum logic {
		PC_INC,
		PC_BR,
		PC_JAL
	} pc_source_t;
endpackage