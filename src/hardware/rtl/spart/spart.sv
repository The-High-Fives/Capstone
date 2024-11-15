// supports 8 bit receiving, 8 bit trasmiting at a time
module spart(
    input clk,
    input rst_n,
    input write_i,
    input read_i,
    input [31:0] addr_i,
    input [31:0] data_i,
    inout [31:0] data_o,
    inout ack_o
);
    wire [7:0] databus_in;

    // spart transfer
    spart_tx iSPART_TX(.clk(clk), .rst_n(rst_n), .enable(enable), .tx_write(tx_write), .tx_data(databus_in), .TBR(tbr), .TX(txd));

    // spart receive
    spart_rx iSPART_RX(.clk(clk), .rst_n(rst_n), .enable(enable), .rx_read(rx_read), .rx_data(databus_in), .RDA(rda), .RX(rxd));

    // baud generator
    baud_gen iBAUD_GEN(.clk(clk), .rst_n(rst_n), .enable(enable));

    // bus interface
    spart_bus_intf iBUS_INTF(.tbr(tbr), .rda(rda), .databus_in(databus_in), .rx_read(rx_read), .tx_read(tx_read), .write_i(write_i),
                                .read_i(read_i), .addr_i(addr_i), .data_i(data_i), .data_o(data_o), .ack_o(ack_o));
endmodule
