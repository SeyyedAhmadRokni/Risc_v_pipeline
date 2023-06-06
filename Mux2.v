module Mux2(a, b, cnt, out);
    input [31:0] a, b;
    input cnt;
    output [31:0] out;
    assign out = cnt ? b : a;
endmodule