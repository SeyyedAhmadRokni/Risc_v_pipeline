module JumpCnt(j_type, branch_t, sign_bit, zero, flush, m4_0_cnt);

    parameter JAL = 2'b01;
    parameter JAL_R = 2'b10;
    parameter BRANCH = 2'b11;

    parameter BEQ = 2'b00;
    parameter BNE = 2'b01;
    parameter BLT = 2'b10;
    parameter BGE = 2'b11;

    input [1:0] j_type, branch_t;
    input sign_bit, zero;
    output reg flush;
    output reg [1:0] m4_0_cnt;

    always @(j_type, branch_t, sign_bit, zero) begin
        {flush, m4_0_cnt} = 3'b0;
        if (j_type == JAL | j_type == JAL_R)begin
            flush = 1'b1;
            m4_0_cnt = 2'b10;
        end
        if (j_type == BRANCH)begin

            if (branch_t == BEQ)begin
                flush = 1'b1;
                m4_0_cnt = zero == 1'b1 ? 2'b01 : 2'b10;
            end
            if (branch_t == BNE)begin
                flush = 1'b1;
                m4_0_cnt = zero == 1'b0 ? 2'b01 : 2'b10;
            end
            if (branch_t == BLT)begin
                flush = 1'b1;
                m4_0_cnt = sign_bit == 1'b1 ? 2'b01 : 2'b10;
            end
            if (branch_t == BGE)begin
                flush = 1'b1;
                m4_0_cnt = sign_bit == 1'b0 ? 2'b01 : 2'b10;
            end

        end
    end





endmodule