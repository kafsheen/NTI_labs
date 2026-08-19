module ram_memory #(
    parameter DEPTH = 256,
    parameter WIDTH = 32
)(
    input  wire                      clk,
    input  wire                      wr_en,
    input  wire [$clog2(DEPTH)-1:0]  addr,
    input  wire [WIDTH-1:0]          wr_data,
    output wire [WIDTH-1:0]          rd_data
);

(* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];

initial begin
    mem[0]  = 32'h20100AF0;
    mem[1]  = 32'h201104B0;
    mem[2]  = 32'h02119020;
    mem[3]  = 32'h20080FA0;
    mem[4]  = 32'h12480001;
    mem[5]  = 32'h08000016;
    mem[6]  = 32'h02119822;
    mem[7]  = 32'h20090640;
    mem[8]  = 32'h12690001;
    mem[9]  = 32'h08000016;
    mem[10] = 32'h0211A024;
    mem[11] = 32'h200A00B0;
    mem[12] = 32'h128A0001;
    mem[13] = 32'h08000016;
    mem[14] = 32'h0211A825;
    mem[15] = 32'h200B0EF0;
    mem[16] = 32'h12AB0001;
    mem[17] = 32'h08000016;
    mem[18] = 32'h200C0064;
    mem[19] = 32'hAD900032;
    mem[20] = 32'h8D8D0032;
    mem[21] = 32'h120D0002;
    mem[22] = 32'h2010DEAD;
    mem[23] = 32'h08000018;
    mem[24] = 32'h2010D08E;
    mem[25] = 32'h00000000;
end

always @(posedge clk) begin
    if (wr_en)
        mem[addr] <= wr_data;
end

assign rd_data = mem[addr];

endmodule