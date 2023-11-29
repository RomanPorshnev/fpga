module uart_rx#(parameter transfer_speed = 4800, parameter package_size = 8, 
                parameter frequency = 27_000_000)
(
    input clk,
    input recieved_signal,
    output reg data_ready,
    output reg [package_size-1:0] data
);
    
    integer i = package_size - 1;
    parameter count_of_strobe = frequency / transfer_speed;
    parameter PAUSE = 0; parameter START = 1; 
    parameter READ = 2; parameter PARITY_CHECK = 3; 
    parameter STOP = 4;

    reg prev_recieved_signal;
    reg [2:0] state = 0;
    reg [25:0] count = 0;
    reg [package_size-1:0] count_ones = 0;

    always @(posedge clk) begin
        case(state)
            PAUSE: begin
                data_ready = 0;
                if (recieved_signal == 0)
                    count = count + 1;
                else
                    count = 0;
                if (count == count_of_strobe / 2)
                    state = state + 1;
            end

            START: begin
                if (recieved_signal == 0) begin
                    count = count + 1;
                end
                else begin
                    state = PAUSE;
                    count = 0;
                end
                if (count == count_of_strobe) begin
                    count = 0;
                    state = state + 1;
                end
            end

            READ: begin
                count = count + 1;
                if (count == 1) begin
                    prev_recieved_signal = recieved_signal;
                end
                if (prev_recieved_signal != recieved_signal) begin
                    state = PAUSE;
                    count = 0;
                end
                else begin
                    data[i] = recieved_signal;
                    if (count == count_of_strobe) begin
                        count = 0;
                        i = i - 1;
                    end
                    if (i == -1) begin
                        state = state + 1;
                        i = package_size - 1;
                    end
                    prev_recieved_signal = recieved_signal;
                end
            end

            PARITY_CHECK: begin
                count = count + 1;
                if (count == 1) begin
                    prev_recieved_signal = recieved_signal;
                end
                if (prev_recieved_signal != recieved_signal) begin
                    state = PAUSE;
                    count = 0;
                end
                else begin
                    if (count == count_of_strobe) begin
                        count = 0;
                        i = 0;
                        for (i = 0; i < package_size; i = i + 1)
                            count_ones = count_ones + data[i];
                        if ((count_ones + recieved_signal) % 2 == 0) begin
                            state = state + 1;
                        end
                        else begin
                            state = PAUSE;
                            count = 0;
                        end
                        count_ones = 0;
                        i = package_size - 1;
                    end
                end
            end

            STOP: begin
                if (recieved_signal == 1) begin
                    count = count + 1;
                end
                else begin
                    state = PAUSE;
                    count = 0;
                end
                if (count == count_of_strobe) begin
                    count = 0;
                    state = PAUSE;
                    data_ready = 1;
                end
            end
        endcase
    end
endmodule