module Controller(rs1, rs2, ex_reg_rd, mem_rd, ex_reg_we, mem_reg_we,//DataForwarding
                  ex_jump_t,mem_jump_t, m8_1_cnt, m8_2_cnt,
                  op, f7, f3,//Decode
                  memory_we, reg_we, memory_read, slt_out, lui_out,
                  ex_out, imm_op, jump_t_out, branch_t_out,
                  id_ex, slt, sign_bit, lui, id_jump_t, m2_1_cnt,//ExCnt
                  m2_2_cnt, m2_3_cnt, m2_4_cnt, m4_2_cnt, alu_cnt,
                  if_rs1, if_rs2, id_rd, mem_read, if_we,//hazardDetecotr
                  id_jump_t, branch_t, zero, flush, m4_1_cnt,//jumpCnt
                  mem_j_type, mem_memory_read, m4_3_cnt,//WBCnt
                  );

    input [2:0] id_ex;
    input [4:0] rs1, rs2, ex_reg_rd, mem_rd;
    input [1:0] ex_jump_t, mem_jump_t;
    input ex_reg_we, mem_reg_we;
    output [2:0] m8_1_cnt, m8_2_cnt;
    input [6:0] op, f7;
    input [2:0] f3;
    output memory_we, reg_we, memory_read, slt_out, lui_out;
    output [2:0] ex_out, imm_op;
    output [1:0] jump_t_out, branch_t_out;
    input slt, sign_bit, lui;
    output m2_3_cnt, m2_4_cnt, m2_1_cnt, m2_2_cnt;
    output [1:0] m4_2_cnt;
    output [2:0] alu_cnt;
    input [4:0] if_rs1, if_rs2, id_rd;
    input mem_read;
    output if_we;
    input [1:0] id_jump_t, branch_t;
    input zero;
    output flush;
    output [1:0] m4_1_cnt;
    input [1:0] mem_j_type;
    input mem_memory_read;
    output [1:0] m4_3_cnt;
    DataForwarding df(rs1, rs2, ex_reg_rd, mem_rd, ex_reg_we, mem_reg_we, mem_memory_read,//DataForwarding
                  ex_jump_t,mem_jump_t, m8_1_cnt, m8_2_cnt);

    DecodeCnt dec(op, f7, f3,
                  memory_we, reg_we, memory_read, slt_out, lui_out,
                  ex_out, imm_op, jump_t_out, branch_t_out);
    
    ExCnt exc(id_ex, slt, sign_bit, lui, id_jump_t, m2_1_cnt,
                  m2_2_cnt, m2_3_cnt, m2_4_cnt, m4_2_cnt, alu_cnt);
    HazardDetectorCnt hzdc(ex_out, lui_out, memory_we, if_rs1, if_rs2, id_rd, mem_read, if_we);
    JumpCnt jcnt(id_jump_t, branch_t, sign_bit, zero, flush, m4_1_cnt);
    WBCnt wbc(mem_j_type, mem_memory_read, m4_3_cnt);




endmodule