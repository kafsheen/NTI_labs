`timescale 1ns / 1ps

module register_tb;
    parameter WIDTH = 8;

    reg clk;
    reg rst;
    reg load;
    reg [WIDTH-1:0] data_in;

    wire [WIDTH-1:0] data_out;

    register dut (
        .clk(clk), 
        .rst(rst), 
        .load(load), 
        .data_in(data_in), 
        .data_out(data_out)
    );

    integer i;

    always #25000 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        load = 0;
        data_in = 0;
        
        #50000;
        rst = 0;
        for (i = 0; i < 50; i = i + 1) begin
            data_in = $random;
            load = $random % 2;
            #50000;
        end
        $finish;
    end
      
    initial begin
        
        $monitor("Time = %0t | clk = %b, rst = %b, load = %b, data_in = %b | data_out = %b", 
                 $time, clk, rst, load, data_in, data_out);
    end
      
endmodule
