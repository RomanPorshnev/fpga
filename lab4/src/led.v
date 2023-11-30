module led #(parameter package_size = 8)
(
    input clk,
    input [package_size-1:0]data,
    input data_ready,
    output led
);
    reg led_ready = 0;
    reg [23:0] counter = 0;
    reg [package_size-1:0] flash_counter = 0;

    assign led = ((counter <= 6_750_000) && ((led_ready) || data_ready));


    always @(posedge clk) begin
        if (data_ready || led_ready) begin
            led_ready = 1;
            if (counter == 13_500_000) begin
                counter = 0;
                flash_counter = flash_counter + 1; 
            end
            else begin
                counter = counter + 1;
            end
            if (flash_counter == data) begin
                flash_counter = 0;
                led_ready = 0;
            end
        end
    end
endmodule