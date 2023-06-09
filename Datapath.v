module Datapath( clk, rst, if_we, m4_1_cnt,
    reg_file_we, id_we,
    id_reg_we_in, id_mem_we_in, id_mem_read_in, id_slt_in, id_lui_in,
    imm_ext_cnt, id_ex_in,
    id_jump_t_in, id_branch_t_in,
    m8_1_cnt, m8_2_cnt, alu_op,
    m2_1_cnt, ex_we, m2_2_cnt, m2_3_cnt, m2_4_cnt,
    m4_2_cnt, mem_we, m4_3_cnt, zero, sign_bit);

    input clk, rst, if_we;
    input [1:0] m4_1_cnt;

    wire [31:0] pc_in, pc_out, inst_out, add1_out, if_pc_out, if_inst_out;
    wire [31:0] ex_pc_out, mem_pc_out, mem_alu_out, mem_rd_out, m4_3_out;

    Mux4 m4_1(add1_out, ex_pc_out, ex_alu_out, 32'b0, m4_0_cnt, pc_in);
    Pc pc(clk, rst, pc_in, if_we, pc_out);
    AddAlu add1(32'd4, pc_out, add1_out);
    InstMemory inst_mem(pc_out, inst_out);

    Register #(32) if_pc (clk, rst, if_we, pc_out, if_pc_out);
    Register #(32) if_inst (clk, rst, if_we, inst_out, if_inst_out);

    //-------------------------------------    

    input reg_file_we, id_we;
    input id_reg_we_in, id_mem_we_in, id_mem_read_in, id_slt_in, id_lui_in;
    input [2:0] imm_ext_cnt, id_ex_in;
    input [1:0] id_jump_t_in, id_branch_t_in;

    wire [31:0] rd1_data, rd2_data, reg_wd, imm_ext_out, id_pc_out;
    wire [31:0] id_rs1_data_out, id_rs2_data_out, id_imm_out, id_rd_out;
    wire id_reg_we_out, id_mem_we_out, id_mem_read_out, id_slt_out, id_lui_out;
    wire [4:0] id_rs1_out, id_rs2_out;
    wire [2:0] id_ex_out;
    wire [1:0] id_jump_t_out, id_branch_t_out;

    RegMem reg_mem(clk, rst, reg_file_we, if_inst_out[19:15], if_inst_out[24:20], mem_rd_out, m4_3_out, rd1_data, rd2_data);
    ImmExtend imm_ext(imm_ext_cnt, if_inst_out, imm_ext_out);

    Register #(1) id_mem_we(clk, rst, id_we, id_mem_we_in, id_mem_we_out);
    Register #(1) id_reg_we(clk, rst, id_we, id_reg_we_in, id_reg_we_out);
    Register #(1) id_mem_read(clk, rst, id_we, id_mem_read_in, id_mem_read_out);
    Register #(3) id_ex(clk, rst, id_we, id_ex_in, id_ex_out);
    Register #(2) id_jump_t(clk, rst, id_we, id_jump_t_in, id_jump_t_out);
    Register #(2) id_branch_t(clk, rst, id_we, id_branch_t_in, id_branch_t_out);
    Register #(1) id_slt(clk, rst, id_we, id_slt_in, id_slt_out);
    Register #(1) id_lui(clk, rst, id_we, id_lui_in, id_lui_out);

    Register #(32) id_pc (clk, rst, id_we, if_pc_out, id_pc_out);
    Register #(32) id_rs1_data (clk, rst, id_we, rd1_data, id_rs1_data_out);
    Register #(32) id_rs2_data (clk, rst, id_we, rd2_data, id_rs2_data_out);
    Register #(5) id_rs1 (clk, rst, id_we, if_inst_out[19:15], id_rs1_out);
    Register #(5) id_rs2 (clk, rst, id_we, if_inst_out[24:20], id_rs2_out);
    Register #(5) id_rd (clk, rst, id_we, if_inst_out[11:7], id_rd_out);
    Register #(32) id_imm (clk, rst, id_we, imm_ext_out, id_imm_out);

    //-------------------------------------
    
    input [2:0] m8_1_cnt, m8_2_cnt, alu_op;
    input m2_1_cnt, ex_we, m2_2_cnt, m2_3_cnt, m2_4_cnt;
    input m4_2_cnt;

    output zero;
    output sign_bit;

    wire [31:0] m8_1_out, m8_2_out, alu_out, m2_1_out, add2_out, m4_2_out, ex_rd_out, ex_rs2_data_out;
    wire [31:0] m2_2_out, m2_3_out, m2_4_out;
    wire ex_reg_we_out, ex_mem_we_out, ex_mem_read_out;
    wire[2:0] ex_jump_t_out;
    assign sign_bit = alu_out[31];

    AddAlu add2(id_pc_out, m2_1_out, add2_out);
    Mux2 m2_1(32'd4, id_imm_out, m2_1_cnt, m2_1_out);
    Mux2 m2_2(id_pc_out, id_rs1_data_out, m2_2_cnt, m2_2_out);
    Mux8 m8_1(m2_2_out, ex_pc_out, ex_alu_out, mem_pc_out, mem_alu_out, 32'b0, 32'b0, 32'b0, m8_1_cnt, m8_1_out);
    Mux2 m2_3(id_rs2_data_out, id_imm_out, m2_3_cnt, m2_3_out);
    Mux8 m8_2(m2_3_out, ex_pc_out, ex_alu_out, mem_pc_out, mem_alu_out, 32'b0, 32'b0, 32'b0, m8_2_cnt, m8_2_out);
    Alu alu(alu_op, m8_1_out, m8_2_out, alu_out, zero);
    Mux2 m2_4(32'b0, 32'd1, m2_4_cnt, m2_4_out);
    Mux4 m4_2(alu_out, id_imm_out, m2_4_out, 32'b0, m4_2_cnt, m4_2_out);

    Register #(1) ex_mem_we(clk, rst, ex_we, id_mem_we_in, ex_mem_we_out);
    Register #(1) ex_mem_read(clk, rst, ex_we, id_mem_read_out, ex_mem_read_out);
    Register #(1) ex_reg_we(clk, rst, ex_we, id_reg_we_out, ex_reg_we_out);
    Register #(2) ex_jump_t(clk, rst, ex_we, id_jump_t_out, ex_jump_t_out);

    Register #(32) ex_pc(clk, rst, ex, add2_out, ex_pc_out);
    Register #(32) ex_rs2_data(clk, rst, ex_we, id_rs2_data_out, ex_rs2_data_out);
    Register #(5) ex_rd(clk, rst, ex_we, id_rd_out, ex_rd_out);
    Register #(32) ex_alu(clk, rst, ex_we, m4_2_out, ex_alu_out);

    //-------------------------------------

    input mem_we;//for register
    wire mem_mem_read_out;
    wire [31:0] memory_out, mem_mem_data_out;
    wire [31:0] mem_jump_t_out, mem_reg_we_out;

    Mem memory(clk, rst, ex_alu_out, ex_mem_we_out, ex_rs2_data_out, memory_out);

    Register #(1) mem_reg_we(clk, rst, mem_we, ex_reg_we_out, mem_reg_we_out);
    Register #(1) mem_mem_read (clk, rst, mem_we, ex_mem_read_out, mem_mem_read_out);
    Register #(2) mem_jump_t(clk, rst, mem_we, ex_jump_t_out, mem_jump_t_out);

    Register #(32) mem_pc (clk, rst, mem_we, ex_pc_out, mem_pc_out);
    Register #(32) mem_mem_data (clk, rst, mem_we, memory_out, mem_mem_data_out);
    Register #(32) mem_alu(clk, rst, mem_we, ex_alu_out, mem_alu_out);
    Register #(5) mem_rd(clk, rst, mem_we, ex_rd_out, mem_rd_out);

    //-------------------------------------

    input [1:0] m4_3_cnt;

    Mux4 m4_3(mem_pc_out, mem_mem_data_out, mem_alu_out, 32'b0, m4_3_cnt, m4_3_out);


endmodule