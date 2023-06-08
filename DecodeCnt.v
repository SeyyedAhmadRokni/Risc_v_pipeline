module DecodeCnt(op, f7, f3,
    memory_we, reg_we, memory_read, slt, lui,
    ex, imm_op,
    jump_t, branch_t);

    parameter LU_I_OP =7'b0110111;
    parameter B_TYPE_OP = 7'b1100011;
    parameter SW_OP =7'b0100011;
    parameter JALR_OP =7'b1100111;
    parameter R_TYPE_OP = 7'b0110011;
    parameter I_TYPE_ARITHMATIC_OP = 7'b0010011;
    parameter LW_OP = 7'b0000011;
    parameter JAL_OP =7'b1101111;

    parameter ADD_3 = 3'b000;
    parameter SUB_3 = 3'b000;
    parameter AND_3 = 3'b111;
    parameter OR_3 = 3'b110;
    parameter SLT_3 = 3'b010;

    parameter BEQ_3 = 3'b0;
    parameter BNE_3 = 3'b001;
    parameter BGE_3 = 3'b101;
    parameter BLT_3 = 3'b100;

    parameter ADD_I_3 = 3'b0;
    parameter XOR_I_3 = 3'b100;
    parameter OR_I_3 = 3'b110;
    parameter SLT_I_3 = 3'b010;

    parameter ADD_7 = 7'b0;
    parameter SUB_7 = 7'b0100000;
    parameter AND_7 = 7'b0;
    parameter OR_7 = 7'b0;
    parameter SLT_7 = 7'b0;

    parameter EX_ADD = 3'd0;
    parameter EX_SUB = 3'd1;
    parameter EX_AND = 3'd2;
    parameter EX_OR = 3'd3;
    parameter EX_ADD_I = 3'd4;
    parameter EX_SLT_I = 3'd5;
    parameter EX_OR_I = 3'd6;
    parameter EX_XOR_I = 3'd7;

    parameter JAL = 2'b01;
    parameter JAL_R = 2'b10;
    parameter BRANCH = 2'b11;

    parameter BEQ = 2'b00;
    parameter BNE = 2'b01;
    parameter BLT = 2'b10;
    parameter BGE = 2'b11;

    input [6:0] op, f7;
    input [2:0] f3;
    output memory_we, reg_we, memory_read, slt, lui;
    output [2:0] ex, imm_op;
    output [1:0] jump_t, branch_t;

    assign is_i_type = op == LW_OP | op == I_TYPE_ARITHMATIC_OP | op == JALR_OP;

    assign memory_we = op == SW_OP;
    assign reg_we = op == R_TYPE_OP | op == JAL_OP | is_i_type;
    assign memory_read = op == LW_OP;
    assign ex = op == R_TYPE_OP ? 
                f3 == ADD_3 & f7 == ADD_7 ? EX_ADD : 
                f3 == SUB_3 & f7 == SUB_7 ? EX_SUB :
                f3 == AND_3 & f7 == AND_7 ? EX_AND :
                f3 == OR_3 & f7 == OR_7 ? EX_OR :
                f3 == SLT_3 & f7 == SLT_7 ? EX_SUB :
                EX_SUB: //default value
                op == I_TYPE_ARITHMATIC_OP ?
                f3 == ADD_I_3 ? EX_ADD_I :
                f3 == XOR_I_3 ? EX_XOR_I :
                f3 == OR_I_3 ? EX_OR_I :
                f3 == SLT_I_3 ? EX_SLT_I :
                EX_SUB: //default value
                op == LW_OP ? EX_ADD_I :
                op == SW_OP ? EX_ADD_I :
                op == JAL_OP ? EX_ADD :
                op == B_TYPE_OP ? EX_SUB :
                op == LU_I_OP ? EX_ADD:
                EX_SUB; //default value
    assign imm_op = is_i_type ? 3'b000 :
                    op == SW_OP ? 3'b001 : 
                    op == B_TYPE_OP ? 3'b010 : 
                    op == JAL_OP ? 3'b011 : 
                    op == LU_I_OP ? 3'b100 : 3'b101;
    assign jump_t = op == JAL_OP ? JAL :
                    op == JALR_OP ? JAL_R :
                    op == B_TYPE_OP ? BRANCH :
                    2'b00;
    assign branch_t = op == B_TYPE_OP ?
                      f3 == BEQ_3 ? BEQ :
                      f3 == BNE_3 ? BNE :
                      f3 == BLT_3 ? BLT :
                      f3 == BGE_3 ? BGE :
                      BEQ : BEQ; //default value
    assign slt = op == R_TYPE_OP & f7 == SLT_7 & f3 == SLT_3 |
                 op == I_TYPE_ARITHMATIC_OP & f3 == SLT_I_3;
    assign lui = op == LU_I_OP;






endmodule