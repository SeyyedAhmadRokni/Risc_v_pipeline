module AluCnt(ex, alu_op);
    parameter ADD = 3'd0;
    parameter SUB = 3'd1;
    parameter AND = 3'd2;
    parameter OR = 3'd3;
    parameter ADD_I = 3'd4;
    parameter SLT_I = 3'd5;
    parameter OR_I = 3'd6;
    parameter XOR_I = 3'd7;

    input [2:0] ex;
    output [2:0] op;

    always@(ex)begin
        case(ex)
            ADD: ex = 3'b000;
            SUB: ex = 3'b001;
            AND: ex = 3'b010;
            OR: ex = 3'b011;
            ADD_I: ex = 3'b000;
            SLT_I: ex = 3'b001;
            OR_I: ex = 3'b011;
            XOR_I: ex = 3'b100;
        endcase
    end

endmodule