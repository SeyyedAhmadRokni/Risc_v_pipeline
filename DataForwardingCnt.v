module DataForwarding(rs1, rs2, reg_rd, mem_rd, reg_reg_we, mem_reg_we, reg_jump_t, mem_jump_t, m8_1_cnt, m8_2_cnt);
    parameter NO_JUMP = 2'b00;
    parameter JAL = 2'b01;
    parameter JAL_R = 2'b10;

    input [4:0] rs1, rs2, reg_rd, mem_rd;
    input [1:0] reg_jump_t, mem_jump_t;
    input reg_reg_we, mem_reg_we;
    output reg [2:0] m8_1_cnt, m8_2_cnt;

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