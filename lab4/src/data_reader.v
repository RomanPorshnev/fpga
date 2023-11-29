module data_reader#(parameter package_size = 8, parameter frequency = 27_000_000)
(
    input clk,
    input button1,
    input button2,
    output reg [package_size+2:0] data,
    output reg data_update
);


    parameter debouncer_limit = frequency / 100;
    integer i = 0;
    reg prev_button1 = 1;
    reg prev_button2 = 1;
    reg button1_pressed = 0;
    reg button2_pressed = 0;
    reg button1_stable = 0;
    reg button2_stable = 0;
    reg [18:0] button1_counter = 0;
    reg [18:0] button2_counter = 0;
    reg [package_size-1:0] number_of_press = 0;
    reg [package_size-1:0] press_counter = 0;
    reg [package_size-1:0] count_ones = 0;
    reg even_bit;
 

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
            number_of_press = number_of_press + 1;
            button1_stable = 0;
            button1_pressed = 0;
            button1_counter = 0;
        end
        prev_button1 = button1;


        /*Начало устранение дребезга контактов на button2.*/
        if (!button2 && prev_button2) begin
            button2_pressed = 1;
        end
        else if (button2_pressed)
            button2_counter = button2_counter + 1;
        if (button2_counter == debouncer_limit)
            button2_stable = 1;
        /*Конец устранение дребезга контактов на button2.*/

        /*Кнопка button2 "явно" нажата.*/
        if (button2_stable && !button2) begin
            i = 0;
            for (i = 0; i < package_size; i = i + 1)
                count_ones = count_ones + number_of_press[i];
            even_bit = count_ones % 2;
            data = {1'b0, number_of_press, even_bit, 1'b1};
            data_update = 1;
            button2_stable = 0;
            button2_pressed = 0;
            button2_counter = 0;
            number_of_press = 0;
            count_ones = 0;
        end
        else begin
            data_update = 0;
        end
        prev_button2 = button2;
    end
endmodule