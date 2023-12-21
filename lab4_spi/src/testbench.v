`timescale 1 ms / 1 ms

module testbench();
    reg clk = 0;
    reg button1 = 1;
    wire MOSI, MISO, SS;
    top top_inst(
        .clk(clk),
        .button1(button1),
        .MOSI(MOSI),
        .MISO(MISO),
        .SS(SS)
    );

    always #5 clk = ~clk;
    initial begin
        $dumpvars;
        $display("Test started...");
        #100 button1 = ~button1;
        #100 button1 = ~button1;
        #10000 $finish;
    end

endmodule