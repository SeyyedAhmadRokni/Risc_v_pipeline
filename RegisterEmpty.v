module RegisterEmpty #(parameter SIZE = 32) (clk, rst, empty, we, in_data, out);
    input clk, rst, we, empty;
    input [SIZE-1:0] in_data;
    reg [SIZE-1:0] data;
    output [SIZE-1:0] out;
    assign out = data;
    always @(posedge clk, posedge rst) begin
        if (rst)
            data <= 0;
        else begin
            if (we) begin
                if (empty)
                    data <= 0;
                else
                    data <= in_data;
            end
        end
    end

endmodule