module spart_bus_intf(
    input tbr,  // transmit ready
    input rda,  // receive 

    inout [7:0] databus_in,
    output rx_read,
    output tx_read, 

    // bus signals
    input write_i,
    input read_i,
    input [31:0] addr_i,
    input [31:0] data_i,
    inout [31:0] data_o,
    inout ack_o
);
    wire cs; // device 'cs' enable based on address
    wire [7:0] status_reg;
    assign status_reg = {6'b000000, tbr, rda};

    // Control the bidirectional databus
    assign cs = (addr_i[7:2] == 6'h07);

    assign databus_in = write_i ? data_i[7:0] : 8'hzz;

    // communicates a write or read to tx and rx respectively
    assign tx_write = ((addr_i[1:0] == 2'b00) & cs & write_i);
    assign rx_read = ((addr_i[1:0] == 2'b01) & cs & read_i);

    // bus signals
    assign tx_ack = ((addr_i[1:0] == 2'b00) & ((write_i & TBR) | read_i)); 
    assign rx_ack = ((addr_i[1:0] == 2'b01) & (write_i | (read_i & RDA))); 
    assign ack_o = cs ? (tx_ack | rx_ack) : 1'bz;

    assign data_o = cs ? databus_in : 8'hzzzzzzzz
endmodule

