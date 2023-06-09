module ExCnt(ex, slt, sign_bit, lui, jump_t, m2_1_cnt, m2_2_cnt, m2_3_cnt, m2_4_cnt, m4_2_cnt, alu_cnt);

    parameter JAL = 2'b01;
    parameter JAL_R = 2'b10;
    parameter BRANCH = 2'b11;

    input [2:0] ex;
    input [1:0] jump_t;
    input slt, sign_bit, lui;
    output m2_3_cnt, m2_4_cnt, m2_1_cnt, m2_2_cnt;
    output [1:0] m4_2_cnt;
    output [2:0] alu_cnt;

    assign m2_4_cnt = sign_bit == 1'b1;
    assign m2_3_cnt = ex[2] == 1'b1;
    assign m2_2_cnt = jump_t != JAL;
    assign m2_1_cnt = jump_t == BRANCH;

    assign m4_2_cnt = slt ? 2'b10 : lui ? 2'b01 : 2'b00;

    AluCnt alu_cnt_obj(ex, alu_cnt);

endmodule