`timescale 1ns / 1ps

module full_adder_tb;
    reg a,b,cin;
    wire sum,cout;
    full_adder dut (
        .a(a), 
        .b(b), 
        .cin(cin), 
        .sum(sum), 
        .cout(cout)
    );

    integer i;

    initial begin
        a = 0;
        b = 0;
        cin = 0;
        #10;
        for (i = 0; i < 20; i = i + 1) begin
            a = $random % 2;
            b = $random % 2;
            cin = $random % 2;
            #10;
        end
        $finish;
    end
      
    initial begin
        $monitor("Time = %0t | a = %b, b = %b, cin = %b | sum = %b, cout = %b", $time, a, b, cin, sum, cout);
    end
      
endmodule
