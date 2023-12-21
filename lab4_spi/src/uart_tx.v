module uart_tx#(parameter transfer_speed = 4800, parameter package_size = 8, 
                parameter frequency = 27_000_000)
(
    input clk,
    input [package_size+1:0] data,
    input data_update_uart,
    output reg transmitted_signal = 1
);


    parameter count_of_strobe = frequency / transfer_speed;
    reg [26:0] count = 0;
    integer i = 0;
    reg [package_size + 1:0] recieved_data = 0;
    reg sending_data = 0;

    always @(posedge clk) begin
        if (data_update_uart || sending_data) begin
            if (i == package_size + 2) begin
                count = 0;
                i = 0;
                sending_data = 0;
            end
            else begin
                count = count + 1;
                if (count == 1) begin
                    sending_data = 1;
                    recieved_data = data;
                end
                transmitted_signal = recieved_data[i];
                if (count == count_of_strobe) begin
                    count = 0;
                    i = i + 1;
                end
            end
            
        end
        else begin
            transmitted_signal = 1;
        end
    end    
endmodule