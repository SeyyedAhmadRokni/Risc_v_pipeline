module Controller(id_ex, alu_op,//AluCnt
                  rs1, rs2, reg_rd, mem_rd, reg_reg_we, mem_reg_we,//DataForwarding
                  reg_jump_t,mem_jump_t, m8_1_cnt, m8_2_cnt,
                  op, f7, f3,//Decode
                  memory_we, reg_we, memory_read, slt_out, lui_out,
                  ex_out, imm_op, jump_t_out, branch_t_out,
                  ex, slt, sign_bit, lui, jump_t, m2_1_cnt,//ExCnt
                  m2_2_cnt, m2_3_cnt, m2_4_cnt, m4_2_cnt, alu_cnt,
                  id_rs1, id_rs2, ex_rd, mem_read, if_we, empty_contrl,//hazardDetecotr
                  id_j_type, branch_t, zero, flush, m4_1_cnt,//jumpCnt
                  mem_j_type, mem_memory_read, m4_3_cnt,//WBCnt
                  );

    input [2:0] id_ex;
    output reg [2:0] alu_op;
    input [4:0] rs1, rs2, reg_rd, mem_rd;
    input [1:0] reg_jump_t, mem_jump_t;
    input reg_reg_we, mem_reg_we;
    output reg [2:0] m8_1_cnt, m8_2_cnt;
    input [6:0] op, f7;
    input [2:0] f3;
    output memory_we, reg_we, memory_read, slt_out, lui_out;
    output [2:0] ex_out, imm_op;
    output [1:0] jump_t_out, branch_t_out;
    input [2:0] ex;
    input [1:0] jump_t;
    input slt, sign_bit, lui;
    output m2_3_cnt, m2_4_cnt, m2_1_cnt, m2_2_cnt;
    output [1:0] m4_2_cnt;
    output [2:0] alu_cnt;
    input [4:0] id_rs1, id_rs2, ex_rd;
    input mem_read;
    output if_we, empty_contrl;
    input [1:0] id_j_type, branch_t;
    input zero;
    output reg flush;
    output reg [1:0] m4_1_cnt;
    input [1:0] mem_j_type;
    input mem_memory_read;
    output [1:0] m4_3_cnt;

    AluCnt alcnt(id_ex, alu_op);

    DataForwarding df(rs1, rs2, reg_rd, mem_rd, reg_reg_we, mem_reg_we,//DataForwarding
                  reg_jump_t,mem_jump_t, m8_1_cnt, m8_2_cnt);

    DecodeCnt dec(op, f7, f3,
                  memory_we, reg_we, memory_read, slt_out, lui_out,
                  ex_out, imm_op, jump_t_out, branch_t_out);
    
    ExCnt exc(ex, slt, sign_bit, lui, jump_t, m2_1_cnt,
                  m2_2_cnt, m2_3_cnt, m2_4_cnt, m4_2_cnt, alu_cnt);
    HazardDetectorCnt hzdc(id_rs1, id_rs2, ex_rd, mem_read, if_we, empty_contrl);
    JumpCnt jcnt(id_j_type, branch_t, sign_bit, zero, flush, m4_1_cnt);
    WBCnt wbc(mem_j_type, mem_memory_read, m4_3_cnt);




endmodule