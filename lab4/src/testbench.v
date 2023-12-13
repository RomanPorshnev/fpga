`timescale 1 ms / 1 ms

module testbench();
    reg clk = 0;
    reg button1 = 1;
    wire transmitted_signal;
    top top_inst(
        .clk(clk),
        .button1(button1),
        .transmitted_signal(transmitted_signal)
    );

    always #5 clk = ~clk;
    initial begin
        $dumpvars;
        $display("Test started...");
        #100 button1 = ~button1;
        #100 button1 = ~button1;
        #20000 button1 = ~button1;
        #100 button1 = ~button1;
        #20000 $finish;
    end

endmodule