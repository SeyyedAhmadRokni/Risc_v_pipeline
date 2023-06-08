module Pc(clk, rst, we, in, out);
    input clk, rst;
    input [31:0] in;
    output reg [31:0] out;
    always @(posedge clk, posedge rst)begin
        if (rst)
            out = 32'b0;
        else begin
            if (we)
                out = in;
        end
    end

endmodule