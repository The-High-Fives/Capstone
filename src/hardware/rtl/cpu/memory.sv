import mem_definitions::*

module memory (
    input logic clk,
    input logic rst_n,

    // Control signals from EX/MEM buffer
    input logic m_MemRead,         // Memory read enable
    input logic m_MemWrite,        // Memory write enable 
    input m_JAL,
    input m_LUI,

    // Data signals from EX/MEM buffer
    input logic [31:0] m_alu_out,      
    input logic [31:0] m_mem_data, // Data to write to memory
    input [31:0] wb_data, // Data forwarded from writeback
    input wb_forward, // selects data source for memory writes
    input [31:0]       m_imm,
    input logic [31:0] m_pc_inc,
    input logic [4:0] m_rd,          

    // Stall control
    output logic stall_mem,           // Stall signal for memory read delay

    // Output signals to MEM/WB buffer
    output logic [31:0] read_data_MEMWB, // Data read from memory for WB stage
    output logic [31:0] reg_data_MEMWB       

    // Memory interface
    // output logic [31:0] memory_data_out, // Data to memory (write)
    // input  logic [31:0] memory_data_in,  // Data from memory (read)
    // output logic [14:0] memory_addr,     // Memory address
    // output logic memory_we,              // Memory write enable
    // output logic memory_re               // Memory read enable
);

    // assign reg_data = m_JAL ? m_pc_inc : (m_LUI ? m_imm : m_alu_out);
    wire [31:0] write_data;
    assign write_data = wb_forward ? wb_data : m_mem_data; // also check on this

    logic [1:0] bank_select;
    assign bank_select = m_alu_out[1:0]; // can get rid of the variable tbh

    mem_mask_t mem_type;

    // Output data from each memory bank
    logic [31:0] bank_rdata[0:3];
    logic [7:0] bank_wdata[0:3];

    logic we0, we1, we2, we3;
    logic re0, re1, re2, re3;

    // Instantiate four banks of dmem32 for the memory
    dmem32 dmem_bank0 (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[31:17]), .re(re0), .we(we0), 
                        .wdata(bank_wdata[0]), .rdata(bank_rdata[0]));

    dmem32 dmem_bank1 (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[32:17]), .re(re1), .we(we1), 
                        .wdata(bank_wdata[1]), .rdata(bank_rdata[1]));

    dmem32 dmem_bank2 (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[32:17]), .re(re2), .we(we2), 
                        .wdata(bank_wdata[2]), .rdata(bank_rdata[2]));

    dmem32 dmem_bank3 (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[32:17]), .re(re3), .we(we3), 
                        .wdata(bank_wdata[3]), .rdata(bank_rdata[3]));

    // Memory read data multiplexing based on selected bank
    always_comb begin
        we0 = 0;
        we1 = 0;
        we2 = 0;
        we3 = 0;
        re0 = 0;
        re1 = 0;
        re2 = 0;
        re3 = 0;
        bank_wdata[0] = 8'h0;
        bank_wdata[1] = 8'h0;
        bank_wdata[2] = 8'h0;
        bank_wdata[3] = 8'h0;
        memDataOut = 0;

        case (mem_type)
            // SB and LB (sign-extended)
            MEM_BYTE: begin
                case (bank_select)
                    2'b00: begin 
                        we0 = m_MemWrite; // 1
                        re0 = m_MemRead; // 1
                        bank_wdata[0] = write_data[7:0]; // Least significant byte stored
                        memDataOut = {{24{bank_rdata[0][7]}}, bank_rdata[0]}; // Load (sign extended)
                    end

                    2'b01: begin 
                        we1 = m_MemWrite; 
                        re1 = m_MemRead; 
                        bank_wdata[1] = write_data[7:0];
                        memDataOut = {{24{bank_rdata[1][7]}}, bank_rdata[1]}; 
                    end

                    2'b10: begin 
                        we2 = m_MemWrite; 
                        re2 = m_MemRead; 
                        bank_wdata[2] = write_data[7:0];
                        memDataOut = {{24{bank_rdata[2][7]}}, bank_rdata[2]}; 
                    end

                    2'b11: begin 
                        we3 = m_MemWrite; 
                        re3 = m_MemRead; 
                        bank_wdata[3] = write_data[7:0];
                        memDataOut = {{24{bank_rdata[3][7]}}, bank_rdata[3]}; 
                    end
                endcase
            end

            // For SH and LH (sign-extended)
            MEM_HALF: begin
                if (!bank_select[1]) begin
                    // Lower halfword: banks 0 and 1
                    we0 = m_MemWrite; 
                    we1 = m_MemWrite; 
                    re0 = m_MemRead; 
                    re1 = m_MemRead;

                    bank_wdata[0] = write_data[7:0];
                    bank_wdata[1] = write_data[15:8];

                    memDataOut = {{16{bank_rdata[1][7]}}, bank_rdata[1], bank_rdata[0]};
                end 
                else begin
                    // Upper halfword: banks 2 and 3
                    we2 = m_MemWrite; 
                    we3 = m_MemWrite; 
                    re2 = m_MemRead; 
                    re3 = m_MemRead;

                    bank_wdata[2] = write_data[7:0];
                    bank_wdata[3] = write_data[15:8];

                    memDataOut = {{16{bank_rdata[3][7]}}, bank_rdata[3], bank_rdata[2]};
                end
            end

            // Fro SW and LW
            MEM_WORD: begin
                // All banks
                we0 = m_MemWrite;
                we1 = m_MemWrite;
                we2 = m_MemWrite;
                we3 = m_MemWrite;
                re0 = m_MemRead;
                re1 = m_MemRead;
                re2 = m_MemRead;
                re3 = m_MemRead;

                bank_wdata[0] = write_data[7:0];
                bank_wdata[1] = write_data[15:8];
                bank_wdata[2] = write_data[23:16];
                bank_wdata[3] = write_data[31:24];

                memDataOut = {bank_rdata[3], bank_rdata[2], bank_rdata[1], bank_rdata[0]};
            end

            // For LBU (zero-extended)
            MEM_UBYTE: begin
                case (bank_select)
                    2'b00: begin 
                        re0 = m_MemRead; 
                        memDataOut = {24'h0, bank_rdata[0]}; 
                    end
                    2'b01: begin 
                        re1 = m_MemRead; 
                        memDataOut = {24'h0, bank_rdata[1]};
                    end
                    2'b10: begin 
                        re2 = m_MemRead; 
                        memDataOut = {24'h0, bank_rdata[2]}; 
                    end
                    2'b11: begin 
                        re3 = m_MemRead; 
                        memDataOut = {24'h0, bank_rdata[3]}; 
                    end
                endcase
            end

            // For LHU (zero-extended)
            MEM_UHALF: begin
                if (bank_select[1] == 0) begin
                    re0 = m_MemRead; 
                    re1 = m_MemRead;
                    memDataOut = {16'h0, bank_rdata[1], bank_rdata[0]};
                end 
                else begin
                    re2 = m_MemRead; 
                    re3 = m_MemRead;
                    memDataOut = {16'h0, bank_rdata[3], bank_rdata[2]};
                end
            end

            default: memDataOut = 32'h0;
        endcase
    end

    assign read_data_MEMWB = memDataOut;

    // Stall signal for memory reads (CHECK ON THIS)
    // assign stall_mem = m_MemRead;
    assign stall_mem = 0;

endmodule
