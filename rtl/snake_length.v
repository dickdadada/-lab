


module snake_length(
       input clk,//50MHZ
	    input rst_n,
		 
		 input add_cube,
		 input  [1:0]game_status,
		 
       output [7:0] num
       );

reg [7:0] cnt_num;
wire [3:0] numH,numL;
assign num =cnt_num;

reg add_cube_r;
reg add_cube_pos;
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_num<=0;
  end
  else begin
    add_cube_r<=add_cube;
	 add_cube_pos<=(!add_cube_r&add_cube);
    if(game_status==2'b00)
	    cnt_num<=0;
	 else begin
	   if(add_cube_pos==1'b1)
		    cnt_num<=cnt_num+1;
	 end
  end
end


endmodule
