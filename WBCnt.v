module WBCnt(j_type, memory_read, m4_2_cnt);

    parameter JAL = 2'b01;
    parameter JAL_R = 2'b10;
    parameter BRANCH = 2'b11;
    
    input [1:0] j_type;
    input memory_read;
    output [1:0] m4_2_cnt;
    assign m4_2_cnt = j_type == JAL | j_type == JAL_R ? 2'b00 :
                      memory_read == 1'b1 ? 2'b01 :
                      2'b10;

endmodule