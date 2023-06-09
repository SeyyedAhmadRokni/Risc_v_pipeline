module HazardDetectorCnt(id_rs1, id_rs2, ex_rd, mem_read, if_we);

    input [4:0] id_rs1, id_rs2, ex_rd;
    input mem_read;
    output if_we;
    
    assign if_we = mem_read & (id_rs1 == ex_rd | id_rs2 == ex_rd) ? 1'b0 : 1'b1;
    //hazard -> 0 else -> 1

endmodule