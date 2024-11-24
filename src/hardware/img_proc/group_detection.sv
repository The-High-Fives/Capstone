module group_detection (
    iColor,
    iDVAL,
    iCLK,
    iRST,
    oRow,
    oCol,
    oVALID_COORD
);

input [11:0] iColor;
input iDVAL;
input iCLK;
input iRST;

output [10:0] oRow;
output [10:0] oCol;
output oVALID_COORD;

logic [16:0] y_accum; // column accumulation
logic [18:0] total_col_accumulate; // column average accumulate
logic [9:0] act_row_count; // count of rows active in total_col_accumulate
logic [9:0] red_row_count; // number of red pixels in row

logic [18:0] total_row_accumulate; // row average accumulate
 
logic [9:0] col_count; // counts current pixel col
logic [9:0] row_count; // counts current pixel row

// control signals
logic y_init, y_acc, tcol_init, tcol_acc;

assign oVALID_COORD = (row_count == 0) & (col_count == 0) & (act_row_count != 0); // TODO maybe add act_col_count? or add threshold
assign oRow = total_row_accumulate/act_row_count;
assign oCol = total_col_accumulate/act_row_count;

always_comb begin
    y_init = 0;
    y_acc = 0;
    tcol_init = 0;
    tcol_acc = 0;
    
    if ((row_count == 0) & (col_count == 0) & iDVAL) begin
        tcol_init = 1;
    end
    if (col_count == 0 & iDVAL) begin
        y_init = 1;
        tcol_acc = 1;
    end
    if (iDVAL & (iColor != 0))
        y_acc = 1;
end

// col counter
always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        col_count <= 0;
    end 
    else if (iDVAL) begin
        if (col_count == 479)
            col_count <= 0;
        else 
            col_count <= col_count+1;
    end
end

// row counter
always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        row_count <= 0;
    end 
    else if (iDVAL) begin
        if (col_count == 479) begin
            if (row_count == 639) begin
                row_count <= 0;
            end else 
                row_count <= row_count+1;
            
        end
    end
end

// active row
always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        red_row_count <= 0;
    end 
    else if (y_init) begin
        red_row_count <= (iColor != 0) ? 1 : 0;
    end
    else if (y_acc) begin
        red_row_count <= red_row_count + 1;
    end
end

// current row y accumulate
always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        y_accum <= 0;
    end 
    else if (y_init) begin
        y_accum <= 0;
    end
    else if (y_acc) begin
        y_accum <= y_accum + col_count;
    end
end

// accumulates average col for all rows
always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        total_col_accumulate <= 0;
    end 
    else if (tcol_init) begin
        total_col_accumulate <= 0;
    end
    else if (tcol_acc) begin
        if (red_row_count != 0)
            total_col_accumulate <= total_col_accumulate + (y_accum/red_row_count);
    end
end

// counts number of rows that have red in total_col_accumulate
always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        act_row_count <= 0;
    end
    else if (tcol_init) begin
        act_row_count <= 0;
    end
    else if (tcol_acc) begin
        if (red_row_count != 0)
            act_row_count <= act_row_count + 1;
    end
end

always_ff @(posedge iCLK or negedge iRST) begin
    if (!iRST) begin
        total_row_accumulate <= 0;
    end
    else if (tcol_init) begin
        total_row_accumulate <= 0;
    end
    else if (tcol_acc) begin
        if (red_row_count != 0)
            total_row_accumulate <= total_row_accumulate + row_count;
    end
end


endmodule