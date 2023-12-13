module top (
    input clk,
    input button1,
    output transmitted_signal
);
    wire [9:0] data_input;
    sending_data #(4800, 8, 27_000_000) sending_data_inst (.clk(clk), .button1(button1), .data(data_input), .data_update(data_update));
    uart_tx #(4800, 8, 27_000_000) uart_tx_inst(.clk(clk), .data(data_input), .data_update(data_update), .transmitted_signal(transmitted_signal));
    //uart_rx #(4800, 8, 27_000_000) uart_rx_inst(.clk(clk), .recieved_signal(transmitted_signal), .data_ready(data_ready), .data(data_output));
    //led #(8) led_inst(.clk(clk), .data(data_output), .data_ready(data_ready), .led(led));
endmodule