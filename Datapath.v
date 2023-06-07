module Datapath(clk, rst, if_we,
    imm_ext_cnt, reg_mem_we, id_we, empty_id,
    id_reg_we_in, id_mem_we_in, id_mem_read_in,
    id_ex_in, id_jump_t_in, m8_1_cnt, m8_2_cnt, alu_op, 
    m2_1_cnt, ex_we, mem_we, mem_reg_we_out, m4_3_cnt, zero, sign_bit);

    input clk, rst, if_we;
    input [1:0] m4_1_cnt;

    wire [31:0] pc_in, pc_out, inst_out, add1_out, if_pc_out, if_inst_out;

    Mux4 m4_1(add1_out, ex_pc_out, ex_alu_out, 32'b0, m4_1_cnt, pc_in);
    Pc pc(clk, rst, pc_in, pc_out);
    AddAlu add1(32'd4, pc_out, add1_out);
    InstMemory inst_mem(pc_out, inst_out);

    Register #(32) if_pc (clk, rst, if_we, pc_out, if_pc_out);
    Register #(32) if_inst (clk, rst, if_we, inst_out, if_inst_out);

    //-------------------------------------    
    input imm_ext_cnt, reg_mem_we, id_we, empty_id;
    input id_reg_we_in, id_mem_we_in, id_mem_read_in;
    input id_ex_in, id_jump_t_in

    wire [31:0] rd1_data, rd2_data, reg_wd, imm_ext_out, id_pc_out;
    wire [31:0] id_rs1_out, id_rs2_out, id_imm, id_rd;
    wire id_reg_we_out, id_mem_we_out, id_mem_read_out;
    wire # id_ex_out;//
    wire # id_jump_t_out;//

    RegMem reg_mem(clk, rst, reg_mem_we, if_inst_out[19:15], if_inst_out[24:20], if_inst_out[11:7], reg_wd, rd1_data, rd2_data);
    ImmExtend imm_ext(imm_ext_cnt, if_inst_out, imm_ext_out);

    Register #(32) id_pc (clk, rst, id_we, if_pc_out, id_pc_out);
    Register #(32) id_rs1_data (clk, rst, id_we, rd1_data, id_rs1_out);
    Register #(32) id_rs2_data (clk, rst, id_we, rd2_data, id_rs2_out);

    Register #(32) id_imm (clk, rst, id_we, imm_ext_out, id_imm_out);
    Register #(5) id_rd (clk, rst, id_we, if_inst_out[11:7], id_rd_out);
    
    Register #(1) id_reg_we(clk, rst, id_we, id_reg_we_in, id_reg_we_out);
    Register #(1) id_mem_we(clk, rst, id_we, id_mem_we_in, id_mem_we_out);
    Register #() id_ex(clk, rst, id_we, id_ex_in, id_ex_out);
    Register #(1) id_mem_read(clk, rst, id_we, id_mem_read_in, id_mem_read_out);
    Register #() id_jump_t(clk, rst, id_we, id_jump_t_in, id_jump_t_out);
    Register #(5) id_rs1 (clk, rst, id_we, if_inst_out[19:15], id_rs1_out);
    Register #(5) id_rs2 (clk, rst, id_we, if_inst_out[24:20], id_rs2_out);

    //-------------------------------------
    
    input [2:0] m8_1_cnt, m8_2_cnt, alu_op;
    input m2_1_cnt, ex_we;
    output zero;
    output sign_bit;
    assign sign_bit = alu_out[31];
    wire [31:0] m8_1_out, m8_2_out, alu_out, m2_1_out, add2_out, ex_pc_out, m4_2_out, ex_rd_out, ex_rs2_data_out;
    wire ex_reg_we_out, ex_mem_we_out, ex_mem_read_out
    wire[#:0] ex_jump_t_out;
    Mux8 m8_1(id_pc_out, ex_alu_out, ex_pc_out, mem_alu_out, id_rs1_data, 32'b0, 32'b0, 32'b0, m8_1_cnt, m8_1_out);
    Mux8 m8_2(ex_alu_out, id_rs2_data, ex_pc_out, mem_alu_out, id_imm_out, 32'b0, 32'b0, 32'b0, m8_2_cnt, m8_2_out);
    Alu alu(alu_op, m8_1_out, m8_2_out, alu_out, zero);

    Mux2 m2_1(32'd4, id_imm_out, m2_1_cnt, m2_1_out);
    AddAlu add2(id_pc_out, m2_1_out, add2_out);
    Mux4 m4_2(alu_out, id_imm_out, 32'b0, {31'b0, 1'b1}, m4_2_out);

    Register #(32) ex_pc(clk, rst, ex, add2_out, ex_pc_out);
    Register #(32) ex_alu(clk, rst, ex_we, m4_2_out, ex_alu_out);
    Register #(32) ex_rd(clk, rst, ex_we, id_rd_out, ex_rd_out);
    Register #(32) ex_rs2_data(clk, rst, ex_we, id_rs2_data, ex_rs2_data_out);

    Register #(1) ex_reg_we(clk, rst, ex_we, id_reg_we_out, ex_reg_we_out);
    Register #(1) ex_mem_we(clk, rst, ex_we, id_mem_we_in, ex_mem_we_out);
    Register #(1) ex_mem_read(clk, rst, ex_we, id_mem_read_out, ex_mem_read_out);
    Register #() ex_jump_t(clk, rst, ex_we, id_jump_t_out, ex_jump_t_out);

    //-------------------------------------

    wire [31:0] memory_out, mem_pc_out, mem_mem_data_out, mem_alu_out, mem_rd_out;
    input mem_we, mem_reg_we_out;
    Mem memory(clk, rst, ex_alu_out, ex_mem_we_out, ex_rs2_data_out, memory_out);

    Register #(32) mem_pc (clk, rst, mem_we, ex_pc_out, mem_pc_out);
    Register #(32) mem_mem_data (clk, rst, mem_we, memory_out, mem_mem_data_out);
    Register #(32) mem_alu (clk, rst, mem_we, ex_alu_out, mem_alu_out);
    Register #(32) mem_rd (clk, rst, mem_we, ex_rd_out, mem_rd_out);

    Register #(1) mem_reg_we(clk, rst, mem_we, ex_reg_we_out, mem_reg_we_out);

    //-------------------------------------
    wire [31:0] m4_3_out
    input [1:0] m4_3_cnt;
    Mux4 m4_3(mem_pc_out, mem_mem_data_out, ex_alu_out, 32'b0, m4_3_cnt, m4_3_out);



endmodule