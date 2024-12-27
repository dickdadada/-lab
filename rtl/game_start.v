
`define RED    24'hFF0000//red    
`define GREEN  24'h00FF00//green        
`define BLUE   24'h0000FF//blue         
`define PURPLE 24'hFF00FF//purple       
`define YELLOW 24'hFFFF00//yellow       
`define CYAN   24'h00FFFF//cyan         
`define ORANGE 24'hFFC125//orange       
`define WHITE  24'hFFFFFF//white        
`define BLACK  24'h000000//black    

`define S1_POS  (pix_x>220&&pix_x<421&&pix_y>190&&pix_y<291) //640x480
`define SNAKE_POS (pix_x>155&&pix_x<220&&pix_y>208&&pix_y<273) //640x480
module game_start(
    input   wire            tft_clk_9m  ,   //输入时钟,频率9MHz
    input   wire            sys_rst_n   ,   //系统复位,低电平有效

    input  wire    [9:0]   pix_x       ,   //输出TFT有效显示区域像素点X轴坐标
    input  wire    [9:0]   pix_y       ,   //输出TFT有效显示区域像素点Y轴坐标
    output  reg    [23:0]    rgb_data     ,   //TFT显示数据
    input  wire             hsync       ,   //TFT行同步信号
    input  wire             vsync         //TFT场同步信号
       );

reg [14:0] s1_addr;
wire [0:0] s1;

reg [11:0] addr;
wire [7:0] snaker,sankeg,snakeb;

always @(posedge tft_clk_9m or negedge sys_rst_n) begin
  if(!sys_rst_n) begin
     rgb_data <= `BLACK;
	  s1_addr<=0;
     addr<=0;
  end
  else begin
    if(vsync == 1'b1)
      if(`S1_POS)begin
		  s1_addr <= s1_addr + 1;
	     rgb_data <= ~{24{s1}};
	   end
		else if(`SNAKE_POS)begin
		  addr<=addr+1;
		  rgb_data <= {snaker,snakeg,snakeb};
		end
	   else begin
	     rgb_data <= `BLACK; 
		end
	 else begin
	   s1_addr<=0;
		addr<=0;
	   rgb_data <= `BLACK;
	 end
  end
end

rom_st Urom_st(
       .clock(tft_clk_9m), 
		 .address(s1_addr), 
		 .q(s1)
		 );

rom_snaker Urom_snaker(
       .clock(tft_clk_9m), 
		 .address(addr), 
		 .q(snaker)
		 );
		 
rom_snakeg Urom_snakeg(
       .clock(tft_clk_9m), 
		 .address(addr), 
		 .q(snakeg)
		 );
		 
rom_snakeb Urom_snakeb(
       .clock(tft_clk_9m), 
		 .address(addr), 
		 .q(snakeb)
		 );
endmodule

