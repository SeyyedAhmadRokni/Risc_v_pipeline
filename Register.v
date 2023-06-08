module Register #(parameter SIZE = 32) (clk, rst, we, in_data, out);
    input clk, rst, we;
    input [SIZE-1:0] in_data;
    reg [SIZE-1:0] data;
    output [SIZE-1:0] out;
    always @(posedge clk, posedge rst) begin
        if (rst)
            data = 0;
        else begin
            if (we) begin
                data = in_data;
            end
        end
    end

endmodule