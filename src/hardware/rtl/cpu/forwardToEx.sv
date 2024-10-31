// ALU operations
module forwardToEX (
    // Inputs in current instruction read registers in EX stage
    input [4:0] ex_rs1,
    input [4:0] ex_rs2,
    input [4:0] m_rd,
    input [4:0] wb_rd,

    input wire we_EXMEM, // write enable saying data is valid and can be forwarded
    input wire we_MEMWB,
    input wire MemRead_EXMEM, // indicates load in EX/MEM stage
    
    // Output data
    output wire [1:0] ALU_1_forward_EX, // ALU input 1
    output wire [1:0] ALU_2_forward_EX, // ALU input 2
    
    // Stall signal for load-to-use hazard
    output wire load_use_hazard
);

    // source and destination registers
    wire [4:0] rs1_IDEX, rs2_IDEX; // source registers in EX stage
    wire [4:0] rd_EXMEM, rd_MEMWB; // destination registers in MEM, WB stages
    
    // source registers
    assign rs1_IDEX = ex_rs1;
    assign rs2_IDEX = ex_rs2;

    // destination register
    assign rd_EXMEM = m_rd;
    assign rd_MEMWB = wb_rd;

    // Forwarding logic for the first ALU input (rs1)
    // check if rs matched rd in EX/MEM or MEM/WB
    // need to check if assignments are right
    wire [1:0] ALU_1_MEMtoEX_forward, ALU_2_MEMtoEX_forward;
    assign ALU_1_MEMtoEX_forward = (we_MEMWB && (rd_MEMWB == rs1_IDEX) && (rd_MEMWB != 0)) ? 2'b01 : 2'b10;
    assign ALU_1_forward_EX = (we_EXMEM && (rd_EXMEM == rs1_IDEX) && (rd_EXMEM != 0)) ? 2'b00 : ALU_1_MEMtoEX_forward;

    // Forwarding logic for the second ALU input (rs2)
    assign ALU_2_MEMtoEX_forward = (we_MEMWB && (rd_MEMWB == rs2_IDEX) && (rd_MEMWB != 0)) ? 2'b01 : 2'b10;
    assign ALU_2_forward_EX = (we_EXMEM && (rd_EXMEM == rs2_IDEX) && (rd_EXMEM != 0)) ? 2'b00 : ALU_2_MEMtoEX_forward;

    // If the EX stage depends on a value being loaded in MEM, stall
    // check if load is happening (MemRead_EXMEM), rd matched the rs in ID/EX
    assign load_use_hazard = (MemRead_EXMEM && ((rd_EXMEM == rs1_IDEX) || (rd_EXMEM == rs2_IDEX)) && (rd_EXMEM != 0));

endmodule
