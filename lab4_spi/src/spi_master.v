module spi_master #(parameter package_size = 8)
(
    input clk_div,
    input [package_size+1:0] data,
    input data_update,
    input MISO,
    output reg MOSI,
    output reg SS = 1
);


    reg [package_size+1:0] recieved_data = 0;
    reg [package_size+1:0] temp_data;
    integer i = 0;
    
    
    //запись в MOSI
    always @(posedge clk_div) begin
        if (data_update) begin
            SS = 0;
            i = i + 1; 
            if (i == 1) begin
                temp_data = data;
            end
            if (i == package_size + 2) begin
                i <= 0;
            end
            MOSI = temp_data[0];
            temp_data = temp_data >> 1;
        end
        else begin
            SS = 1;
        end
    end

    //считывание с MISO
    always @(posedge clk_div) begin
        if (data_update) begin
            recieved_data = recieved_data >> 1;
            recieved_data[package_size-1] = MISO;
        end
    end
endmodule