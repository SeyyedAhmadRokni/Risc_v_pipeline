module CA4(clk, rst);

    input clk, rst;
    wire [2:0] alu_op, imm_ext_cnt, f3;
    wire zero, sign_bit, ex_reg_we_out, mem_reg_we_out, id_slt_out, id_lui_out;
    wire [4:0] id_rs1_out, id_rs2_out, ex_rd_out, mem_rd_out;
    wire [1:0] ex_jump_t_out, mem_jump_t_out, id_branch_t_out, id_jump_t_out;
    wire [6:0] op, f7;
    wire [2:0] id_ex_out;
    wire [4:0] if_rs1_out, if_rs2_out, id_rd_out;
    wire id_mem_read_out, mem_mem_read_out;

    wire [1:0] id_jump_t_in, id_branch_t_in;
    wire [2:0] m8_1_cnt, m8_2_cnt, id_ex_in;
    wire id_mem_we_in, id_reg_we_in, id_mem_read_in, id_slt_in, id_lui_in;
    wire m2_1_cnt, m2_2_cnt, m2_3_cnt, m2_4_cnt, if_we, flush;
    wire [1:0] m4_1_cnt, m4_2_cnt, m4_3_cnt;
    wire id_mem_we;

    Datapath dp(clk, rst, if_we,
        id_reg_we_in, id_mem_we_in, id_mem_read_in, id_slt_in, id_lui_in,
        id_ex_in, id_jump_t_in, id_branch_t_in, flush,
        m2_1_cnt,  m2_2_cnt, m2_3_cnt, m2_4_cnt,
        m4_1_cnt, m4_2_cnt, m4_3_cnt,
        m8_1_cnt, m8_2_cnt,
        alu_op, imm_ext_cnt, zero, sign_bit,

        id_mem_we, id_rs1_out, id_rs2_out, ex_rd_out, mem_rd_out,//Forward
        ex_jump_t_out, mem_jump_t_out, ex_reg_we_out, mem_reg_we_out,
        op, f7, f3, //Decode
        id_ex_out, id_slt_out, id_lui_out, id_jump_t_out, //ExCnt
        if_rs1_out, if_rs2_out, id_rd_out, id_mem_read_out, //hazardDetect
        id_branch_t_out, //jumpCnt
        mem_mem_read_out); //WBCnt
    
    Controller cnt (id_mem_we, id_rs1_out, id_rs2_out, ex_rd_out, mem_rd_out, ex_reg_we_out, mem_reg_we_out,//DataForwarding
        ex_jump_t_out, mem_jump_t_out, m8_1_cnt, m8_2_cnt,
        op, f7, f3,//Decode
        id_mem_we_in, id_reg_we_in, id_mem_read_in, id_slt_in, id_lui_in,
        id_ex_in, imm_ext_cnt, id_jump_t_in, id_branch_t_in,
        id_ex_out, id_slt_out, sign_bit, id_lui_out, id_jump_t_out, m2_1_cnt,//ExCnt
        m2_2_cnt, m2_3_cnt, m2_4_cnt, m4_2_cnt, alu_op,
        if_rs1_out, if_rs2_out, id_rd_out, id_mem_read_out, if_we, //hazardDetecotr
        id_branch_t_out, zero, flush, m4_1_cnt,//jumpCnt
        mem_jump_t_out, mem_mem_read_out, m4_3_cnt,//WBCnt
        );

endmodule