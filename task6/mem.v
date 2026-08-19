module memory #(
    parameter AWIDTH = 5,
    parameter DWIDTH = 8,
    parameter DEPTH  = 2**AWIDTH
)(
    input clk,
    input wr,
    input rd,
    input [AWIDTH-1:0] addr,
    input [DWIDTH-1:0] data_in,
    output reg [DWIDTH-1:0] data_out
);

    reg [DWIDTH-1:0] mem_array [0:DEPTH-1];

    integer i;
    initial begin
        data_out = 0;
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem_array[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (wr) begin
            mem_array[addr] <= data_in;
        end
        if (rd) begin
            data_out <= mem_array[addr];
        end
    end

endmodule
