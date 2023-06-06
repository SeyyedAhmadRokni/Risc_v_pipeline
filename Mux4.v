module Mux4(a1, a2, a3, a4, cnt, out);
    input [31:0] a1, a2, a3, a4;
    input [1:0] cnt;
    output [31:0] out;
    assign out = cnt[1] ? (cnt[0] ? a4 : a3) : cnt[0] ? a2 : a1;
endmodule