module piso_reg #(
    parameter WIDTH     = 20,
    parameter ADDR_WIDTH = 8
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  start,         
    input  wire [ADDR_WIDTH-1:0] addr,          
    input  wire [WIDTH-1:0]      ram_dout,      
    output reg                   ram_rd_en,     
    output wire                  serial_out,    
    output reg                   valid          
);

    reg [WIDTH-1:0]  shift_reg;
    reg [$clog2(WIDTH):0] bit_cnt;  

    // State machine states
    localparam IDLE    = 2'd0;
    localparam FETCH   = 2'd1;   
    localparam LOAD    = 2'd2;   
    localparam SHIFT   = 2'd3;   

    reg [1:0] state;

    assign serial_out = shift_reg[WIDTH-1]; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            shift_reg  <= {WIDTH{1'b0}};
            bit_cnt    <= 0;
            ram_rd_en  <= 1'b0;
            valid      <= 1'b0;
        end else begin
            case (state)

                IDLE: begin
                    ram_rd_en <= 1'b0;
                    valid     <= 1'b0;
                    if (start) begin
                        ram_rd_en <= 1'b1;   
                        state     <= FETCH;
                    end
                end

                FETCH: begin
                    
                    ram_rd_en <= 1'b0; //return it again to zero to not take two words from teh mem
                    state     <= LOAD;
                end

                LOAD: begin

                    shift_reg <= ram_dout;
                    bit_cnt   <= WIDTH;
                    valid     <= 1'b1;
                    state     <= SHIFT;
                end

                SHIFT: begin
                    if (bit_cnt > 0) begin
                        shift_reg <= {shift_reg[WIDTH-2:0], 1'b0}; // Shift left
                        bit_cnt   <= bit_cnt - 1;
                    end else begin
                        valid <= 1'b0;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
