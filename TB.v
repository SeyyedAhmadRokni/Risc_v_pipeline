module TB ();
    reg clk=0,rst=0;
    CA4 ca(clk,rst);
    always 
        #10 clk=~clk;
    initial begin
        #10 rst=1;
        #20 rst=0;
        #2500 $stop;
    end
endmodule