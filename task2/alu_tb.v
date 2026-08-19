`timescale 1ns / 1ps

module alu_tb;
    parameter WIDTH = 8;

    reg [WIDTH-1:0] in_a;
    reg [WIDTH-1:0] in_b;
    reg [2:0] opcode;

    wire [WIDTH-1:0] alu_out;
    wire a_is_zero;

    alu dut (
        .in_a(in_a), 
        .in_b(in_b), 
        .opcode(opcode), 
        .alu_out(alu_out), 
        .a_is_zero(a_is_zero)
    );

    integer i;

    initial begin
        in_a = 0;
        in_b = 0;
        opcode = 0;
        #10;
        for (i = 0; i < 20; i = i + 1) begin
            in_a = $random;
            in_b = $random;
            opcode = $random % 8; // Generates random 3-bit values (0 to 7)
            #10;
        end
        $finish;
    end
      
    initial begin
        // Monitor will print the values whenever any of them change
        $monitor("Time = %0t | opcode = %b, in_a = %b, in_b = %b | alu_out = %b, a_is_zero = %b", 
                 $time, opcode, in_a, in_b, alu_out, a_is_zero);
    end
      
endmodule
