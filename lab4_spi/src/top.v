module top (
    input clk,
    input button1,
    output MOSI,
    output MISO,
    output SS
);

    wire [9:0] data_input;
    wire [9:0] data_output;

    sending_data #(100, 8, 100) data_reader_inst (.clk(clk), .button1(button1), .data(data_input), .data_update(data_update), .clk_div(clk_div));
    //spi_master #(8) spi_master_inst(.clk_div(clk_div), .data(data_input), .data_update(data_update), .MISO(MISO), .MOSI(MOSI), .SS(SS));
    //spi_slave #(8) spi_slave_inst(.clk_div(clk_div), .MOSI(MOSI), .SS(SS), .MISO(MISO), .data_output(data_output), .data_output_uart(data_output_uart));
    //uart_tx #(100, 8, 100) uart_tx_inst(.clk(clk), .data(data_output), .data_update_uart(data_output_uart), .transmitted_signal(transmitted_signal));

endmodule