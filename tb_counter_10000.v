`timescale 1ns / 1ps

module tb_counter_10000 ();

    reg clk, rst;
    reg btnL, btnR, btnD;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;


    counter_10000 dut (
        .clk(clk),
        .rst(rst),
        .btnL(btnL),
        .btnR(btnR),
        .btnD(btnD),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        btnL = 0;
        btnR = 0;
        btnD = 0;

        repeat(2) @(negedge clk); //리셋중
        rst   = 0;

        //case1. run 제어
        btnR = 1;
        repeat(10000) @(negedge clk); //debounce가 8000에 한번 되니까
        btnR = 0;
        #500_000

        //case2. stop 제어
        btnR = 1;
        repeat(10000) @(negedge clk);
        btnR = 0;
        #500_000

        //case3. mode 제어
        btnD = 1; //down
        repeat(10000) @(negedge clk);
        btnD = 0;
        btnR = 1; //run
        repeat(10000) @(negedge clk);
        btnR = 0;
        #500_000

        //case4. clear 제어
        btnR = 1; //stop
        repeat(10000) @(negedge clk);
        btnR = 0;
        btnL = 1; //clear
        repeat(10000) @(negedge clk);
        btnL = 0;
        #500_000


        $stop;
    end


endmodule
