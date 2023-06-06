module Alu(op, a, b, out , zero);
    input [2:0] op;
    input [31:0] a, b;
    output reg [31:0] out;
    output zero;
    assign zero = (out == 32'b0);
    always @(op, a, b)begin
        out = 32'b0;
        case (op)
            3'b000: out = a+b;
            3'b001: out = a-b;
            3'b010: out = a&b;
            3'b011: out = a|b;
            3'b100: out = a^b;
            // must change to their equal
        endcase
    end

endmodule