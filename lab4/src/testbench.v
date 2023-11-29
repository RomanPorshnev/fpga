`timescale 1 ms / 1 ms

module testbench();
    reg clk = 0;
    reg button1 = 1;
    reg button2 = 1;
    wire led;
    top top_inst(
        .clk(clk),
        .button1(button1),
        .button2(button2),
        .led(led)
    );

    always #5 clk = ~clk;
    initial begin
        $dumpvars;
        $display("Test started...");
        #100 button1 = ~button1;
        #100 button1 = ~button1;
        #200 button2 = ~button2;
        #200 button2 = ~button2;
        /*
        #1000 button1 = ~button1;
        #30 button1 = ~button1;
        #30 button1 = ~button1;
        #30 button1 = ~button1;
        #30 button2 = ~button2;
        #30 button2 = ~button2;
        */
        #10000 $finish;
    end

endmodule