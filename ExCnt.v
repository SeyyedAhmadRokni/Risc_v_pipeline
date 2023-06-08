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


module DataForwarding(rs1, rs2, reg_rd, mem_rd, reg_reg_we, mem_reg_we, reg_jump_t, mem_jump_t, m8_1_cnt, m8_2_cnt);
    parameter NO_JUMP = 2'b00;
    parameter JAL = 2'b01;
    parameter JAL_R = 2'b10;

    input [4:0] rs1, rs2, reg_rd, mem_rd;
    input [1:0] reg_jump_t, mem_jump_t;
    output [2:0] m8_1_cnt, m8_2_cnt;

    always@(rs1, rs2, reg_rd, mem_rd, reg_jump_t, mem_jump_t)begin
        {m8_1_cnt, m8_2_cnt} = 6'b0;

        if (rs1 == reg_rd)begin
            if (reg_reg_we == 1'b1)begin
                if (rs1 != 5'b0)begin
                    if (reg_jump_t == JAL | reg_jump_t == JAL)begin
                        m8_1_cnt = 3'b001;
                    end
                    else begin
                        m8_1_cnt = 3'b011;
                    end
                end
            end
        end
        else begin
            if (rs1 == mem_rd)begin
                if (mem_reg_we == 1'b1)begin
                    if (rs1 != 5'b0)begin
                        if (reg_jump_t == JAL | reg_jump_t == JAL)begin
                            m8_1_cnt = 3'b010;
                        end
                        else begin
                            m8_1_cnt = 3'b100;
                        end
                    end
                end
            end
        end

        if (rs2 == reg_rd)begin
            if (reg_reg_we == 1'b1)begin
                if (rs2 != 5'b0)begin
                    if (reg_jump_t == JAL | reg_jump_t == JAL)begin
                        m8_1_cnt = 3'b001;
                    end
                    else begin
                        m8_1_cnt = 3'b011;
                    end
                end
            end
        end
        else begin
            if (rs2 == mem_rd)begin
                if (mem_reg_we == 1'b1)begin
                    if (rs2 != 5'b0)begin
                        if (reg_jump_t == JAL | reg_jump_t == JAL)begin
                            m8_1_cnt = 3'b010;
                        end
                        else begin
                            m8_1_cnt = 3'b100;
                        end
                    end
                end
            end
        end

    end

endmodule

module ExCnt(ex, slt, sign_bit, lui, jump_t, m2_3_cnt, m2_4_cnt, m2_5_cnt, m2_6_cnt, m4_1_cnt);

    parameter JAL = 2'b01;
    parameter JAL_R = 2'b10;
    parameter BRANCH = 2'b11;

    input [2:0] ex;
    input [1:0] jump_t;
    input slt, sign_bit;
    output m2_3_cnt, m2_4_cnt, m2_5_cnt, m2_6_cnt;
    output [1:0] m4_1_cnt;
    output [2:0] alu_cnt;

    assign m2_6_cnt = sign_bit == 1'b1;
    assign m2_5_cnt = ex[2] == 1'b1;
    assign m2_4_cnt = jump_t != JAL;
    assign m2_3_cnt = jump_t == BRANCH;

    assign m4_1_cnt = slt ? 2'b10 : lui ? 2'b01 : 2'b00;

    AluCnt alu_cnt(ex, alu_cnt);

endmodule