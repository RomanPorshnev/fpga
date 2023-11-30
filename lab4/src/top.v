module top (
    input clk,
    input button1,
    input button2,
    output transmitted_signal
);
    wire [10:0] data_input;
    wire [7:0] data_output;
    data_reader #(8, 27_000_000) data_reader_inst (.clk(clk), .button1(button1), .button2(button2), .data(data_input), .data_update(data_update));
    uart_tx #(4800, 8, 27_000_000) uart_tx_inst(.clk(clk), .data(data_input), .data_update(data_update), .transmitted_signal(transmitted_signal));
    //uart_rx #(4800, 8, 27_000_000) uart_rx_inst(.clk(clk), .recieved_signal(transmitted_signal), .data_ready(data_ready), .data(data_output));
    //led #(8) led_inst(.clk(clk), .data(data_output), .data_ready(data_ready), .led(led));
endmodule