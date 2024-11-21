module group_detection (
    iColor,
    iDVAL,
    iCLK,
    iRST,
    oX,
    oY,
    oVALID_COORD
);

input [11:0] iColor;
input iDVAL;
input [10:0] iX_Cont;
input [10:0] iY_Cont;
input iCLK;
input iRST;

output [10:0] oX;
output [10:0] oY;
output oVALID_COORD;

logic [16:0] y_accum; // column accumulation
logic [18:0] total_col_accumulate // column average accumulate
logic [9:0] act_row_count; // count of rows active in column
logic active_row; // if this row is active

logic [16:0] x_accum; // row accumulation
logic [18:0] total_row_accumulate; // row average accumulate
logic [9:0] act_col_count; // count of cols active in total row accumation
 
logic [9:0] col_count; // counts current pixel col
logic [9:0] row_count; // counts current pixel row

// control signals
logic y_init, y_acc, tcol_init, tcol_acc;

assign oVALID_COORD = (row_count == 0) & (col_count == 0) & (act_row_count != 0); // TODO maybe add act_col_count? or add threshold

always_comb begin
    oY = total_col_accumulate/act_row_count;
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
        active_row <= 0;
    end 
    else if (y_acc) begin
        active_row <= 1;
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
        total_col_accumulate <= (iColor != 0) ? 1 : 0;
    end
    else if (tcol_acc) begin
        total_col_accumulate <= total_col_accumulate + (y_accum/480);
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
        act_row_count <= act_row_count + active_row;
    end
end

// always_ff @(posedge iCLK or negedge iRST) begin
//     if (!iRST) begin
//         x_accum <= 0;
//     end
// end

// always_ff @(posedge iCLK or negedge iRST) begin
//     if (!iRST) begin
//         total_row_accumulate <= 0;
//     end
// end

// always_ff @(posedge iCLK or negedge iRST) begin
//     if (!iRST) begin
//         act_col_count <= 0;
//     end
// end

endmodule