`timescale 1ns / 1ps

module alu_mem_tb;

    parameter SIPO_WIDTH = 20;
    
    reg clk;
    reg rst_n;
    reg shift_en;
    reg serial_in;
    wire [SIPO_WIDTH-1:0] parallel_out;
    
    parameter ALU_WIDTH = 8;
    
    reg [ALU_WIDTH-1:0] in_a;
    reg [ALU_WIDTH-1:0] in_b;
    reg [2:0] opcode;
    reg alu_en;
    wire [ALU_WIDTH-1:0] alu_out;
    wire a_is_zero;
    
    sipo_reg #(
        .WIDTH(SIPO_WIDTH)
    ) dut_sipo (
        .clk(clk),
        .rst_n(rst_n),
        .shift_en(shift_en),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );
    

    alu #(
        .WIDTH(ALU_WIDTH)
    ) dut_alu (
        .in_a(in_a),
        .in_b(in_b),
        .opcode(opcode),
        .alu_en(alu_en),
        .alu_out(alu_out),
        .a_is_zero(a_is_zero)
    );
    
    integer i;
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        
        rst_n = 0;
        shift_en = 0;
        serial_in = 0;
        
        in_a = 0;
        in_b = 0;
        opcode = 0;
        alu_en = 0;
        
        #10;
        rst_n = 1;
        
        shift_en = 1;
        alu_en = 1;
        
        for (i = 0; i < 20; i = i + 1) begin
            // SIPO random inputs
            serial_in = $random % 2;
            
            // ALU random inputs
            in_a = $random;
            in_b = $random;
            opcode = $random % 6;
            
            #10;
        end
        
        shift_en = 0;
        alu_en = 0;
        #20;
        
        $finish;
    end
    
    initial begin
            
            $monitor("Time=%0t | rst_n=%b shift_en=%b ser_in=%b par_out=%h | alu_en=%b op=%b a=%d b=%d out=%d zero=%b", 
                 $time, rst_n, shift_en, serial_in, parallel_out, alu_en, opcode, in_a, in_b, alu_out, a_is_zero);
    end
    
endmodule
