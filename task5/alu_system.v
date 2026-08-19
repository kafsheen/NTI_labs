module alu_system (
    input wire clk,
    input wire rst_n,
    input wire shift_en,
    input wire serial_in,
    output wire [7:0] alu_out,
    output wire a_is_zero
);

   
    wire [19:0] parallel_data;


    sipo_reg #(
        .WIDTH(20)
    ) u_sipo_reg (
        .clk(clk),
        .rst_n(rst_n),
        .shift_en(shift_en),
        .serial_in(serial_in),
        .parallel_out(parallel_data)
    );

    
    alu #(
        .WIDTH(8)
    ) u_alu (
        .alu_en(parallel_data[19]),        
        .opcode(parallel_data[18:16]),     
        .in_a(parallel_data[15:8]),        
        .in_b(parallel_data[7:0]),         
        .alu_out(alu_out),
        .a_is_zero(a_is_zero)
    );

endmodule
