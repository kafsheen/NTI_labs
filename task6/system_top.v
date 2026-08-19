module system_top #(
    parameter DATA_WIDTH = 20,
    parameter ADDR_WIDTH = 8,
    parameter ALU_WIDTH  = 8
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  start,          
    input  wire [ADDR_WIDTH-1:0] addr,           
    output wire [ALU_WIDTH-1:0]  alu_out,        
    output wire                  a_is_zero       
);

    wire                  ram_rd_en;
    wire [DATA_WIDTH-1:0] ram_dout;
    wire                  serial_bit;
    wire                  valid;

    memory #(
        .AWIDTH(ADDR_WIDTH),
        .DWIDTH(DATA_WIDTH)
    ) u_ram (
        .clk     (clk),
        .wr      (1'b0),
        .rd      (ram_rd_en),
        .addr    (addr),
        .data_in ({DATA_WIDTH{1'b0}}),
        .data_out(ram_dout)
    );

    piso_reg #(
        .WIDTH     (DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_piso (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (start),
        .addr      (addr),
        .ram_dout  (ram_dout),
        .ram_rd_en (ram_rd_en),
        .serial_out(serial_bit),
        .valid     (valid)
    );

    alu_system u_alu_sys (
        .clk       (clk),
        .rst_n     (rst_n),
        .shift_en  (valid),
        .serial_in (serial_bit),
        .alu_out   (alu_out),
        .a_is_zero (a_is_zero)
    );

endmodule

