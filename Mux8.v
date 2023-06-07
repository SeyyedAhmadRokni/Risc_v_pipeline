module Mux4(a1, a2, a3, a4, a5, a6, a7, a8, cnt, out);
    input [31:0] a1, a2, a3, a4;
    input [2:0] cnt;
    output [31:0] out;
    assign out = cnt[2] ? cnt [1] ? (cnt [0] ? a8 : a7) : (cnt[0] ? a6 : a5) : cnt [1] ? (cnt [0] ? a4 : a3) : (cnt[0] ? a2 : a1);
endmodule