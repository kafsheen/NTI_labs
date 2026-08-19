`timescale 1ns / 1ps

module system_top_tb;

    parameter NUM_TESTS = 8;

    reg        clk, rst_n, start;
    reg  [7:0] addr;
    wire [7:0] alu_out;
    wire       a_is_zero;

    integer i;

    system_top dut (
        .clk(clk), .rst_n(rst_n), .start(start),
        .addr(addr), .alu_out(alu_out), .a_is_zero(a_is_zero)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; start = 0; addr = 0;
        #20; rst_n = 1; #10;

        for (i = 0; i < NUM_TESTS; i = i + 1) begin
            dut.u_ram.mem_array[i][19]    = $random % 2;
            dut.u_ram.mem_array[i][18:16] = $random % 6;
            dut.u_ram.mem_array[i][15:8]  = $random;
            dut.u_ram.mem_array[i][7:0]   = $random;
            $display("RAM[%0d] = %b", i, dut.u_ram.mem_array[i]);
        end

        for (i = 0; i < NUM_TESTS; i = i + 1) begin
            addr = i;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;

            @(posedge dut.u_piso.valid);
            @(negedge dut.u_piso.valid);
            repeat (2) @(posedge clk);

            $display("Test[%0d]: alu_out=%0d  a_is_zero=%b", i, alu_out, a_is_zero);
        end

        #20; $finish;
    end

endmodule
