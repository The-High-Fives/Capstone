import mem_definitions::*;

module memory (
    input logic clk,
    input logic rst_n,

    input bl_stall,
    input stall, // same as mem_wb_buffer

    // Control signals from EX/MEM buffer
    input logic m_MemRead,         // Memory read enable
    input logic m_MemWrite,        // Memory write enable 
    input m_JAL,
    input m_LUI,
    input  mem_mask_t m_mem_type,

    // Data signals from EX/MEM buffer
    input logic [31:0] m_alu_out,      
    input logic [31:0] m_mem_data, // Data to write to memory
    input [31:0] wb_data, // Data forwarded from writeback
    input wb_forward, // selects data source for memory writes
    input [31:0]       m_imm,
    input logic [31:0] m_pc_inc,
    input logic [4:0] m_rd,
    
    // Data signals from bus
    inout [31:0] b_addr_o, // bus r/w address
    input [31:0] b_data_i,  // bus data input
    inout [31:0] b_data_o, // bus data output
    inout b_read_o,        // bus read
    inout b_write_o,       // bus write
    input b_ack_i,          // bus acknowledgement signal

    // Stall control
    output logic stall_mem,           // Stall signal for memory read delay, stalls entire pipeline

    // Output signals to MEM/WB buffer
    output logic [31:0] read_data_MEMWB, // Data read from memory for WB stage
    output logic [31:0] reg_data_MEMWB       
);
    localparam IO_MEM_SPACE = 20'h40000; // top 24 bits of IO address space

    wire bus_transaction;
    wire [31:0] write_data;
    logic [1:0] bank_select;

    assign write_data = wb_forward ? wb_data : m_mem_data;
    assign bank_select = m_alu_out[1:0]; // selects banks for read and write enable

    // Output data from each memory bank
    logic [7:0] bank_rdata[0:3];
    logic [7:0] bank_wdata[0:3];

    logic we0, we1, we2, we3;
    logic re0, re1, re2, re3;
    logic [31:0] memDataOut;

    assign reg_data_MEMWB = m_JAL ? m_pc_inc : (m_LUI ? m_imm : m_alu_out);

    // Instantiate four banks of dmem32 for the memory
    //#(.depth(16384),.FILENAME("pruTest_byte3.hex"))
    dmem32 dmem_bank0 (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[15:2]), .re(!stall & re0), .we(we0), 
                        .wdata(bank_wdata[0]), .rdata(bank_rdata[0]));

    dmem32 dmem_bank1  (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[15:2]), .re(!stall & re1), .we(we1), 
                        .wdata(bank_wdata[1]), .rdata(bank_rdata[1]));

    dmem32 dmem_bank2  (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[15:2]), .re(!stall & re2), .we(we2), 
                        .wdata(bank_wdata[2]), .rdata(bank_rdata[2]));

    dmem32 dmem_bank3  (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[15:2]), .re(!stall & re3), .we(we3), 
                        .wdata(bank_wdata[3]), .rdata(bank_rdata[3]));

    // Memory read data multiplexing based on selected bank
    assign memDataOut = {bank_rdata[3], bank_rdata[2], bank_rdata[1], bank_rdata[0]};

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
        if (!bus_transaction) begin
            unique case (m_mem_type)
                // SB and LB (sign-extended)
                MEM_BYTE: begin
                    case (bank_select)
                        2'b00: begin 
                            we0 = m_MemWrite; // 1
                            re0 = m_MemRead; // 1
                            bank_wdata[0] = write_data[7:0]; // Least significant byte stored
                        end

                        2'b01: begin 
                            we1 = m_MemWrite; 
                            re1 = m_MemRead; 
                            bank_wdata[1] = write_data[7:0];
                        end

                        2'b10: begin 
                            we2 = m_MemWrite; 
                            re2 = m_MemRead; 
                            bank_wdata[2] = write_data[7:0];
                        end

                        2'b11: begin 
                            we3 = m_MemWrite; 
                            re3 = m_MemRead; 
                            bank_wdata[3] = write_data[7:0];
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
                    end 
                    else begin
                        // Upper halfword: banks 2 and 3
                        we2 = m_MemWrite; 
                        we3 = m_MemWrite; 
                        re2 = m_MemRead; 
                        re3 = m_MemRead;

                        bank_wdata[2] = write_data[7:0];
                        bank_wdata[3] = write_data[15:8];
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
                end

                // For LBU (zero-extended)
                MEM_UBYTE: begin
                    case (bank_select)
                        2'b00: begin 
                            re0 = m_MemRead; 
                        end
                        2'b01: begin 
                            re1 = m_MemRead; 
                        end
                        2'b10: begin 
                            re2 = m_MemRead; 
                        end
                        2'b11: begin 
                            re3 = m_MemRead; 
                        end
                    endcase
                end

                // For LHU (zero-extended)
                MEM_UHALF: begin
                    if (bank_select[1] == 0) begin
                        re0 = m_MemRead; 
                        re1 = m_MemRead;
                    end 
                    else begin
                        re2 = m_MemRead; 
                        re3 = m_MemRead;
                    end
                end
            endcase
        end
    end

    // bus controller
    assign bus_transaction = (m_alu_out[31:12] == IO_MEM_SPACE); // checks if address is in IO space
    assign b_addr_o = bl_stall ? 32'hzzzzzzzz : m_alu_out;
    assign b_data_o = bl_stall ? 32'hzzzzzzzz : write_data;
    assign b_read_o = bl_stall ? 1'bz : (bus_transaction ? m_MemRead : 1'b0);
    assign b_write_o = bl_stall ? 1'bz : (bus_transaction ? m_MemWrite : 1'b0);
    assign stall_mem = (b_read_o | b_write_o) & ~b_ack_i;

    // b_data_i buffer & bus transaction buffer
    // delayed selection since memory reads are flopped
    logic [31:0] b_data_buffer;
    logic bus_transaction_buffer;
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            b_data_buffer <= 0;
            bus_transaction_buffer <= 0;
        end 
        else if (!stall) begin
            b_data_buffer <= b_data_i;
            bus_transaction_buffer <= bus_transaction;
        end
    end

    assign read_data_MEMWB = bus_transaction_buffer ? b_data_buffer : memDataOut;
endmodule
