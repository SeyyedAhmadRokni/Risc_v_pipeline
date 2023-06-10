module HazardDetectorCnt(ex, lui, mem_we, id_rs1, id_rs2, ex_rd, mem_read, if_we);

    input [4:0] id_rs1, id_rs2, ex_rd;
    input mem_read, mem_we, lui;
    input [2:0] ex;
    output reg if_we;
    
    always @(ex, lui, mem_we, id_rs1, id_rs2, ex_rd, mem_read)begin
        if_we = 1'b1;
        if (ex < 3'b100)begin
            if (~lui)begin
                if_we = mem_read & (id_rs1 == ex_rd | id_rs2 == ex_rd) ? 1'b0 : 1'b1;     
            end
        end
        else if (mem_we)
            if_we = mem_read & (id_rs1 == ex_rd | id_rs2 == ex_rd) ? 1'b0 : 1'b1;
        else 
            if_we = mem_read & (id_rs1 == ex_rd) ? 1'b0 : 1'b1;
    end
    //hazard -> 0 else -> 1

endmodule