module sending_data#(
    parameter transfer_speed = 4800,
    parameter package_size = 8, 
    parameter frequency = 27_000_000
)
(
    input clk,
    input button1,
    output reg [package_size+1:0] data,
    output reg data_update = 0,
    output clk_div
);

    integer i = 0;
    parameter debouncer_limit = (frequency / 100) + 1;
    parameter count_of_strobe = frequency / transfer_speed;
    reg [26:0] count = 0;
    reg [26:0] counter = 0;
    
    reg prev_button1 = 1;
    reg button1_pressed = 0;
    reg button1_stable = 0;
    reg [18:0] button1_counter = 0;
    reg [package_size-1:0] messages [0:26];

    assign data_ready = (button1_counter == debouncer_limit - 1) && (!button1);
    assign clk_div = (counter == 1);

    initial begin
        messages[0] = 104;
        messages[1] = 101;
        messages[2] = 108;
        messages[3] = 108;
        messages[4] = 111;
        messages[5] = 44;
        messages[6] = 32;

        messages[7] = 118;
        messages[8] = 108;
        messages[9] = 97;
        messages[10] = 100;
        messages[11] = 105;
        messages[12] = 109;
        messages[13] = 105;
        messages[14] = 114;
        messages[15] = 32;

        messages[16] = 118;
        messages[17] = 105;
        messages[18] = 99;
        messages[19] = 116;
        messages[20] = 111;
        messages[21] = 114;
        messages[22] = 111;
        messages[23] = 118;
        messages[24] = 105;
        messages[25] = 99;
        messages[26] = 104;
    end

    always @(posedge clk) begin
        /*Начало устранение дребезга контактов на button1.*/
        if (!button1 && prev_button1) begin
            button1_pressed = 1;
        end
        else if (button1_pressed)
            button1_counter = button1_counter + 1;
        if (button1_counter == debouncer_limit)
            button1_stable = 1;
        /*Конец устранение дребезга контактов на button1.*/

        /*Кнопка button1 "явно" нажата.*/
        if (button1_stable && !button1) begin
            button1_stable = 0;
            button1_pressed = 0;
            button1_counter = 0;
        end
        prev_button1 = button1;
    end

    always @(posedge clk) begin
        if (counter == 1) begin
            counter = 0;
        end
        else begin
            counter = counter + 1;
        end
    end

    always @(posedge clk_div) begin
        if (data_ready || data_update) begin
            data_update = 1;
            count = count + 1;
            if ((count == count_of_strobe * 10 + 2) && (i == 0)) begin
                i = i + 1;
                count = 1;
            end
            else if ((count == count_of_strobe * 10 + 1) && (i > 0)) begin
                i = i + 1;
                count = 1;
            end
            if (i == 27) begin
                count = 0;
                i = 0;
                data_update = 0;
            end
            else begin
                data = {1'b1, messages[i], 1'b0};
            end
        end
    end
endmodule