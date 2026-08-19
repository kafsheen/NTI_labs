`timescale 1ns / 1ps

module control (
    input wire clk,
    input wire rst,
    input wire zero,
    input wire [2:0] opcode,
    input wire [2:0] Phase,
    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg halt,
    output reg inc_pc,
    output reg ld_ac,
    output reg ld_pc,
    output reg wr,
    output reg data_e
);

    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND = 3'b011;
    localparam XOR = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;

    localparam INST_ADDR = 3'b000;
    localparam INST_FETCH = 3'b001;
    localparam INST_LOAD  = 3'b010;
    localparam IDLE       = 3'b011;
    localparam OP_ADDR    = 3'b100;
    localparam OP_FETCH   = 3'b101;
    localparam ALU_OP_PH  = 3'b110;
    localparam STORE      = 3'b111;

    reg alu_op_active;
    reg halt_active;

    always @(posedge clk) begin
        if (rst) begin
            sel    <= 1'b0;
            rd     <= 1'b0;
            ld_ir  <= 1'b0;
            halt   <= 1'b0;
            inc_pc <= 1'b0;
            ld_ac  <= 1'b0;
            ld_pc  <= 1'b0;
            wr     <= 1'b0;
            data_e <= 1'b0;
        end else begin
            alu_op_active = (opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA);
            halt_active   = (opcode == HLT);

            sel    <= 1'b0;
            rd     <= 1'b0;
            ld_ir  <= 1'b0;
            halt   <= 1'b0;
            inc_pc <= 1'b0;
            ld_ac  <= 1'b0;
            ld_pc  <= 1'b0;
            wr     <= 1'b0;
            data_e <= 1'b0;

            case (Phase)
                INST_ADDR: begin
                end
                
                INST_FETCH: begin
                    rd <= 1'b1;
                end
                
                INST_LOAD: begin
                    rd    <= 1'b1;
                    ld_ir <= 1'b1;
                end
                
                IDLE: begin
                    rd    <= 1'b1;
                    ld_ir <= 1'b1;
                end
                
                OP_ADDR: begin
                    sel    <= 1'b1;
                    halt   <= halt_active;
                    inc_pc <= 1'b1;
                end
                
                OP_FETCH: begin
                    sel <= 1'b1;
                    rd  <= alu_op_active;
                end
                
                ALU_OP_PH: begin
                    sel <= 1'b1;
                    rd  <= alu_op_active;
                    if (opcode == JMP) begin
                        ld_pc <= 1'b1;
                    end
                    if (opcode == STO) begin
                        data_e <= 1'b1;
                    end
                end
                
                STORE: begin
                    rd <= alu_op_active;
                    if (opcode == SKZ && zero == 1'b1) begin
                        inc_pc <= 1'b1;
                    end
                    
                    ld_ac <= alu_op_active;
                    
                    if (opcode == JMP) begin
                        ld_pc <= 1'b1;
                    end
                    if (opcode == STO) begin
                        wr     <= 1'b1;
                        data_e <= 1'b1;
                    end
                end
                
                default: begin
                end
            endcase
        end
    end

endmodule
