// ALU operations
module forwardToEX (
    // Inputs in current instruction read registers in EX stage
    input wire [31:0] Instruction_IDEX, // instruction in the EX stage (contains rs1/rs2)
    input wire [31:0] Instruction_EXMEM, // instruction in the MEM stage (rd)
    input wire [31:0] Instruction_MEMWB, // instruction in the WB stage (rd)

    input wire we_EXMEM, // write enable saying data is valid and can be forwarded
    input wire we_MEMWB,
    input wire MemRead_EXMEM, // indicates load in EX/MEM stage
    
    // Data to be forwarded
    input wire [31:0] output_EXMEM, // result from EX/MEM stage
    input wire [31:0] WB_data, // data from MEM/WB stage
    
    // Data if no forwarding
    input wire [31:0] RegData1_IDEX, // rs1 in EX stage
    input wire [31:0] RegData2_IDEX, // rs2 in EX stage
    
    // Output data
    output wire [31:0] ALU_1_forward_EX, // ALU input 1
    output wire [31:0] ALU_2_forward_EX, // ALU input 2
    
    // Stall signal for load-to-use hazard
    output wire load_use_hazard
);

    // source and destination registers
    wire [4:0] rs1_IDEX, rs2_IDEX; // source registers in EX stage
    wire [4:0] rd_EXMEM, rd_MEMWB; // destination registers in MEM, WB stages
    
    // source registers
    assign rs1_IDEX = Instruction_IDEX[19:15];
    assign rs2_IDEX = Instruction_IDEX[24:20];

    // destination register
    assign rd_EXMEM = Instruction_EXMEM[11:7];
    assign rd_MEMWB = Instruction_MEMWB[11:7];

    // Forwarding logic for the first ALU input (rs1)
    // check if rs matched rd in EX/MEM or MEM/WB
    // need to check if assignments are right
    wire [31:0] ALU_1_MEMtoEX_forward;
    assign ALU_1_MEMtoEX_forward = (we_MEMWB && (rd_MEMWB == rs1_IDEX) && (rd_MEMWB != 0)) ? WB_data : RegData1_IDEX;
    assign ALU_1_forward_EX = (rs1_IDEX == 0) ? 32'b0 :
                              (we_EXMEM && (rd_EXMEM == rs1_IDEX) && (rd_EXMEM != 0)) ? output_EXMEM : ALU_1_MEMtoEX_forward;

    // Forwarding logic for the second ALU input (rs2)
    wire [31:0] ALU_2_MEMtoEX_forward;
    assign ALU_2_MEMtoEX_forward = (we_MEMWB && (rd_MEMWB == rs2_IDEX) && (rd_MEMWB != 0)) ? WB_data : RegData2_IDEX;
    assign ALU_2_forward_EX = (rs2_IDEX == 0) ? 32'b0 :
                              (we_EXMEM && (rd_EXMEM == rs2_IDEX) && (rd_EXMEM != 0)) ? output_EXMEM : ALU_2_MEMtoEX_forward;

    // If the EX stage depends on a value being loaded in MEM, stall
    // check if load is happening (MemRead_EXMEM), rd matched the rs in ID/EX
    assign load_use_hazard = (MemRead_EXMEM && ((rd_EXMEM == rs1_IDEX) || (rd_EXMEM == rs2_IDEX)) && (rd_EXMEM != 0));

endmodule
