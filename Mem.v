module Mem(clk, rst, a, we, wd, out);
    input clk, we,rst;
    input [31:0] wd;
    input [15:0] a;
    wire [31:0] address;
    assign address = {16'b0,a};
    output reg [31:0] out;
    reg [31:0] mem [16000:0];

    always @(address, posedge clk, posedge rst)begin
        if (rst)
            $readmemb("C:/Users/AliGH/Desktop/Ca2/testArray.txt", mem);
        else begin
            out = mem[address>>2];
            if (clk & we)
                mem[address>>2] = wd;
        end
    end
endmodule


