module uart_tx#(parameter transfer_speed = 4800, parameter package_size = 8, 
                parameter frequency = 27_000_000)
(
    input clk,
    input [package_size+2:0] data,
    input data_update,
    output reg transmitted_signal
);


    parameter count_of_strobe = frequency / transfer_speed;
    reg [26:0] count = 0;
    integer i = package_size + 2;
    reg sending_data = 0;
    reg [package_size-1:0] flash_counter = 0;
    reg [package_size+2:0] recieved_data = 0;

    always @(posedge clk) begin
        if (data_update || sending_data) begin
            if (i == -1) begin
                count = 0;
                i = package_size + 2;
                sending_data = 0;
            end
            else begin
                if (!sending_data) begin
                    sending_data = 1;
                    recieved_data = data;
                end
                count = count + 1;
                transmitted_signal = recieved_data[i];
                if (count == count_of_strobe) begin
                    count = 0;
                    i = i - 1;
                end
            end
            
        end
        else begin
            transmitted_signal = 1;
        end
    end    
endmodule