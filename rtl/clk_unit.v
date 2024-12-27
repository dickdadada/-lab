module clk_unit(
	input clk,
	input rst_n,
	output reg clk_n
	);
	

    reg clk_tmp;
    always @(posedge clk_tmp or negedge rst_n) begin
       if (!rst_n)
        clk_n <= 0;
      else
        clk_n <= ~clk_n;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_tmp <= 0;
        else
            clk_tmp <= ~clk_tmp;
    end
endmodule
