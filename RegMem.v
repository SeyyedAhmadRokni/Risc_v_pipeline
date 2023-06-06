module RegMem(clk, rst, we, a1, a2, a3, wd, rd1, rd2);
    input clk, we, rst;
    input [4:0] a1, a2, a3;
    input [31:0] wd;
    output[31:0] rd1, rd2;
    reg [31:0] regmem [31:0];
    assign rd1 = regmem[a1];
    assign rd2 = regmem[a2];
    always @(posedge clk, posedge rst)begin
        if (rst) begin
            regmem[0] = 32'b0;
            regmem[8] = 32'b0;//for head of array input
        end
        if (clk & we & a3 != 5'b0)
            regmem[a3] = wd;      
    end

endmodule