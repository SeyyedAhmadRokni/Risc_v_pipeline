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
    output reg [2:0] alu_op;

    always@(ex)begin
        case(ex)
            ADD: alu_op = 3'b000;
            SUB: alu_op = 3'b001;
            AND: alu_op = 3'b010;
            OR: alu_op = 3'b011;
            ADD_I: alu_op = 3'b000;
            SLT_I: alu_op = 3'b001;
            OR_I: alu_op = 3'b011;
            XOR_I: alu_op = 3'b100;
        endcase
    end

endmodule