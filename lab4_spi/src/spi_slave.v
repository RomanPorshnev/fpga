module spi_slave #(parameter package_size = 8)
(
    input clk_div,
    input MOSI,
    input SS,
    output reg MISO,
    output reg [package_size+1:0] data_output,
    output reg data_output_uart = 0
);

    integer i = 0;
    reg [26:0] count = 0;
    reg [package_size+1:0] data = 0;
    reg [package_size+1:0] data_to_send = 8'b10101010;

    //считывание с MOSI
    always @(negedge clk_div) begin
        if (!SS) begin
            count = count + 1;
            data = data >> 1;
            data[package_size+1] = MOSI;
            if (count == 10) begin
                data_output = data;
                count = 0;
                data_output_uart = 1;
            end
            else begin
                data_output_uart = 0;
            end
        end
    end

    //запись в  MISO
    always @(posedge clk_div) begin
        if (!SS) begin
            MISO = data_to_send[0];
            data_to_send[package_size-2:0] = data_to_send[package_size-1:1];
        end
        else begin
            data_to_send = 8'b10101010;
        end
    end
endmodule