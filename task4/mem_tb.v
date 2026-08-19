`timescale 1ns / 1ps

module mem_tb;
    parameter DWIDTH = 8;
    parameter AWIDTH = 5;

    reg clk;
    reg wr;
    reg rd;
    reg [AWIDTH-1:0] addr;
    reg [DWIDTH-1:0] data_in;
    
    wire [DWIDTH-1:0] data_out;

    memory #(
        .DWIDTH(DWIDTH),
        .AWIDTH(AWIDTH)
    ) dut (
        .clk(clk), 
        .wr(wr), 
        .rd(rd),
        .addr(addr), 
        .data_in(data_in),
        .data_out(data_out)
    );

    integer i;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        wr = 0;
        rd = 0;
        addr = 0;
        data_in = 0;
        
        #10;

        for (i = 0; i < 20; i = i + 1) begin
            wr = $random % 2; 
            if (wr) rd = 0;
            else rd = $random % 2;
            
            addr = $random;
            data_in = $random;
            #10;
        end
        
        
        wr = 0;
        rd = 1;
        #20;
        
        $finish;
    end
      
    initial begin
            
        $monitor("Time = %0t | clk = %b, wr = %b, rd = %b, addr = %h, data_in = %h | data_out = %h", 
                 $time, clk, wr, rd, addr, data_in, data_out);
    end
      
endmodule
