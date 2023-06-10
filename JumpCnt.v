module JumpCnt(j_type, branch_t, sign_bit, zero, flush, m4_1_cnt);

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
    output reg [1:0] m4_1_cnt;

    always @(j_type, branch_t, sign_bit, zero) begin

        {flush, m4_1_cnt} = 0;
        if (j_type == JAL | j_type == JAL_R)begin
            flush = 1'b1;
            m4_1_cnt = 2'b10;
        end
        if (j_type == BRANCH)begin

            if (branch_t == BEQ)begin
                if (zero == 1'b1)begin
                    flush = 1'b1;
                    m4_1_cnt = 2'b01;
                end
            end
            if (branch_t == BNE)begin
                if(zero == 1'b0)begin
                    flush = 1'b1;
                    m4_1_cnt = 2'b01;
                end
            end
            if (branch_t == BLT)begin
                if (sign_bit == 1'b1)begin
                    flush = 1'b1;
                    m4_1_cnt = 2'b01;
                end
            end
            if (branch_t == BGE)begin
                if (sign_bit == 1'b0)begin
                    flush = 1'b1;
                    m4_1_cnt = 2'b01;
                end
            end

        end
    end





endmodule