module async_fifo 
#(
     parameter width = 16 // bits
    ,parameter depth = 16 // bits; avoid non-powers of 2
)
(
     input i_wclk
    ,input i_rclk
    ,input i_wr
    ,input i_rd
    ,input [width-1:0] i_wdata
    ,input i_wrst_n
    ,input i_rrst_n

    ,output [width-1:0] o_rdata
    ,output o_empty
    ,output o_full
);

    // declarations
    logic [width-1:0] mem [depth];
    logic [$clog2(depth):0] wptr, rptr;
    logic [$clog2(depth):0] wptr_syn2_b, rptr_syn2_b;
    logic [$clog2(depth):0] wptr_g, rptr_g;
    
    logic wen;

    assign o_rdata = mem[rptr[$clog2(depth)-1:0]];
    assign o_full = {~wptr[$clog2(depth)], wptr[$clog2(depth)-1:0]} == rptr_syn2_b;
    assign o_empty = wptr_syn2_b == rptr;

    assign wen = ~o_full & i_wr;

    // fifo memory write
    always_ff @(posedge i_wclk) begin
        if (wen)
            mem[wptr[$clog2(depth)-1:0]] <= i_wdata;
    end

    // write pointer
    always_ff @(posedge i_wclk, negedge i_wrst_n) begin
        if (!i_wrst_n)
            wptr <= 0;
        else if (i_wr & !o_full)
            wptr <= wptr + 1;
    end

    // read pointer
    always_ff @(posedge i_rclk, negedge i_rrst_n) begin
        if (!i_rrst_n)
            rptr <= 0;
        else if (i_rd & !o_empty)
            rptr <= rptr + 1;
    end

    // wptr & rptr 2-ff sync
    logic [$clog2(depth):0] wptr_syn1, wptr_syn2, rptr_syn1, rptr_syn2;

    always_ff @(posedge i_wclk) begin
        wptr_syn1 <= wptr_g;
        wptr_syn2 <= wptr_syn1;
    end

    always_ff @(posedge i_rclk) begin
        rptr_syn1 <= rptr_g;
        rptr_syn2 <= rptr_syn1;
    end

    // bin-gray code conversion
    always_comb begin
        integer i;
        // bin to gray
        wptr_g[$clog2(depth)] = wptr[$clog2(depth)];
        rptr_g[$clog2(depth)] = rptr[$clog2(depth)];
        for (i = 0; i < $clog2(depth); i = i+1) begin
            wptr_g[i] = wptr[i] ^ wptr[i+1];
            rptr_g[i] = rptr[i] ^ rptr[i+1];
        end
        
        // gray to bin
        wptr_syn2_b[$clog2(depth)] = wptr_syn2[$clog2(depth)];
        rptr_syn2_b[$clog2(depth)] = rptr_syn2[$clog2(depth)];
        for (i = $clog2(depth)-1; i >= 0; i = i-1) begin
            wptr_syn2_b[i] = wptr_syn2_b[i+1] ^ wptr_syn2[i];
            rptr_syn2_b[i] = rptr_syn2_b[i+1] ^ rptr_syn2[i];
        end
    end
endmodule