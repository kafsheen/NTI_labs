module alu #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] in_a,
    input wire [WIDTH-1:0] in_b,
    input wire [2:0] opcode,
    input wire alu_en,
    output reg [WIDTH-1:0] alu_out,
    output wire a_is_zero
);

    assign a_is_zero = (in_a == {WIDTH{1'b0}}) ? 1'b1 : 1'b0;

    always @(*) begin
        if (!alu_en) begin
            alu_out = {WIDTH{1'b0}};
        end else begin
            case (opcode)
                3'b000: alu_out = in_a + in_b;
                3'b001: alu_out = in_a - in_b;
                3'b010: alu_out = in_a & in_b;
                3'b011: alu_out = in_a ^ in_b;
                3'b100: alu_out = in_a | in_b;
                3'b101: alu_out = in_a;
                default: alu_out = {WIDTH{1'b0}};
            endcase
        end
    end

endmodule
