//����ģ��

module top_greedy_snake
(
    input clk,
	input rst_n,
	
	input left,
	input right,
	input up,
	input down,
	
	output                  beep,           //输出蜂鸣器控制信号
	output  wire    [3:0]   led_out,        //输出控制led灯
	
	output  wire            stcp        ,   //输出数据存储寄时钟
   output  wire            shcp        ,   //移位寄存器的时钟输入
   output  wire            ds          ,   //串行数据输入
   output  wire            oe          ,   //输出使能信号

	output hsync,
	output vsync,
	output  wire    [15:0]  rgb            //输出像素信息

	
);

	wire left_key_press;
	wire right_key_press;
	wire up_key_press;
	wire down_key_press;
	wire [1:0]snake;
	wire [9:0]x_pos;
	wire [9:0]y_pos;
	wire [5:0]apple_x;
	wire [4:0]apple_y;
	wire [5:0]head_x;
	wire [5:0]head_y;
	
	wire add_cube;
	wire[1:0]game_status;
	wire hit_wall;
	wire hit_body;
	wire die_flash;
	wire restart;
	wire [6:0]cube_num;
	
		 
	 //wire  define
   wire    [19:0]  data    ;   //数码管要显示的值
   wire    [5:0]   point   ;   //小数点显示,高电平有效top_seg_595
   wire            seg_en  ;   //数码管使能信号，高电平有效
   wire            sign    ;   //符号位，高电平显示负号

	wire     [7:0]  num;

wire pixel_clk;//74.25MHZ

wire  [23:0]  vga_rgb;  
wire [7:0]	   R;
wire [7:0]	   G;
wire [7:0]	   B; 
wire		      HS;
wire	         VS;
wire           VGA_DE;
	
wire [23:0]    start_rgb;
wire [23:0]    over_rgb;
				
assign led_out={4{die_flash}};
assign point=6'b000000;
assign seg_en=1'b1;
assign sign=1'b0;

assign data={12'b0,num};
assign beep =die_flash;
	
assign hsync= HS;
assign vsync=VS;

assign rgb  =(game_status==2'b10)?{R[7:3],G[7:2],B[7:3]}:        //输出像素信息
             (game_status==2'b01)?{start_rgb[23:19],start_rgb[15:10],5'b0}:{over_rgb[23:19],over_rgb[15:10],5'b0};
//------------- clk_gen_inst -------------
clk_gen clk_gen_inst
(
    .areset     (~rst_n ),  //输入复位信号,高电平有效,1bit
    .inclk0     (clk    ),  //输入50MHz晶振时钟,1bit
    .c0         (pixel_clk ),  //输出TFT工作时钟,频率9Mhz,1bit

    .locked     (     )   //输出pll locked信号,1bit
);


    Game_Ctrl_Unit U1 (
        .clk(clk),
	    .rst(rst_n),
	    .key1_press(left_key_press),
	    .key2_press(right_key_press),
	    .key3_press(up_key_press),
	    .key4_press(down_key_press),
        .game_status(game_status),
		.hit_wall(hit_wall),
		.hit_body(hit_body),
		.die_flash(die_flash),
		.restart(restart)		
	);
	
	Snake_Eatting_Apple U2 (
        .clk(clk),
		.rst(rst_n&restart),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube)	
	);
	
	Snake U3 (
	    .clk(clk),
		.rst(rst_n&restart),
		.left_press(left_key_press),
		.right_press(right_key_press),
		.up_press(up_key_press),
		.down_press(down_key_press),
		.snake(snake),
		.x_pos(x_pos),
		.y_pos(y_pos),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube),
		.game_status(game_status),
		.cube_num(cube_num),
		.hit_body(hit_body),
		.hit_wall(hit_wall),
		.die_flash(die_flash)
	);
	
//--------------------------------	

	Snake_VGA USnake_VGA(
       .clk(pixel_clk),
       .rst_n(rst_n&restart),
       .snake(snake),
	   .apple_x(apple_x),
	   .apple_y(apple_y),
	   .x_pos(x_pos),
	   .y_pos(y_pos),
	   .vga_rgb(vga_rgb)
       ); 
	     
  vga_ctl U_vga_ctl(
        .pix_clk(pixel_clk),
        .reset_n(rst_n),
        .VGA_RGB(vga_rgb),
        .hcount(x_pos),
        .vcount(y_pos),
		  .VGA_CLK(),
        .VGA_R(R),
        .VGA_G(G),
        .VGA_B(B),
        .VGA_HS(HS),
        .VGA_VS(VS),
        .VGA_DE(VGA_DE),
        .BLK()
        );  
		  
//-----------------------------------
game_start Ugame_start(
           .tft_clk_9m(pixel_clk),   //输入时钟,频率9MHz
           .sys_rst_n(rst_n),   //系统复位,低电平有效

           .pix_x(x_pos),   //输出TFT有效显示区域像素点X轴坐标
           .pix_y(y_pos),   //输出TFT有效显示区域像素点Y轴坐标
           .rgb_data(start_rgb),   //TFT显示数据
           .hsync(HS)      ,   //TFT行同步信号
           .vsync(VS)         //TFT场同步信号
       );

		 
game_over Ugame_over(
           .tft_clk_9m(pixel_clk),   //输入时钟,频率9MHz
           .sys_rst_n(rst_n),   //系统复位,低电平有效

           .pix_x(x_pos),   //输出TFT有效显示区域像素点X轴坐标
           .pix_y(y_pos),   //输出TFT有效显示区域像素点Y轴坐标
           .rgb_data(over_rgb),   //TFT显示数据
           .hsync(HS)      ,   //TFT行同步信号
           .vsync(VS)         //TFT场同步信号
       );
		 
//----------------------------------

	Key U5 (
		.clk(clk),
		.rst(rst_n),
		.left(left),
		.right(right),
		.up(up),
		.down(down),
		.left_key_press(left_key_press),
		.right_key_press(right_key_press),
		.up_key_press(up_key_press),
		.down_key_press(down_key_press)		
	);
	
	
snake_length Usnake_length(
             .clk(clk),//50MHZ
	          .rst_n(rst_n&restart),
		 
		       .add_cube(add_cube),
		       .game_status(game_status),
		 
             .num(num)
       );
	
	
seg_595_dynamic    seg_595_dynamic_inst
(
    .sys_clk    (clk   ),   //系统时钟，频率50MHz
    .sys_rst_n  (rst_n ),   //复位信号，低有效
    .data       (data      ),   //数码管要显示的值
    .point      (point     ),   //小数点显示,高电平有效
    .seg_en     (seg_en    ),   //数码管使能信号，高电平有效
    .sign       (sign      ),   //符号位，高电平显示负号

    .stcp       (stcp      ),   //输出数据存储寄时钟
    .shcp       (shcp      ),   //移位寄存器的时钟输入
    .ds         (ds        ),   //串行数据输入
    .oe         (oe        )    //输出使能信号
);


endmodule
