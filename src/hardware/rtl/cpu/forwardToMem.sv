// store instructions
module forwardToMem (
    // Inputs for MEM stage instruction
    input wire [4:0] m_rs2, // instruction in the MEM stage
    input wire [4:0] wb_rd, // instruction in the WB stage
    input wire we_MEMWB,                     
    input wire memWrite_EXMEM, // indicates store operation in MEM stage

    // Output data
    output wire RegData2_forward_M
);

    // Source/Destination registers
    wire [4:0] rs2_EXMEM;
    wire [4:0] rd_MEMWB;
    
    assign rs2_EXMEM = m_rs2; // Source register for store
    assign rd_MEMWB = wb_rd;

    // Forwarding for store data (rs2 in MEM stage)
    // check if rs2 in MEM matches rd in WB
    assign RegData2_forward_M = (we_MEMWB && (rd_MEMWB == rs2_EXMEM) && (rd_MEMWB != 0) && memWrite_EXMEM) ? 1'b1 : 1'b0;

endmodule
