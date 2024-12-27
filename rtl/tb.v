

`timescale 1ns/1ps


module tb();

   reg clk;
	reg rst_n;

	reg left;
	reg right;
	reg up;
	reg down;
	
	   wire               beep;          //输出蜂鸣器控制信号
	  wire    [3:0]   led_out;        //输出控制led灯
	
	  wire            stcp;   //输出数据存储寄时钟
     wire            shcp;   //移位寄存器的时钟输入
     wire            ds  ;   //串行数据输入
     wire            oe  ;   //输出使能信号

	  wire   hsync;
	  wire   vsync;
	  wire    [15:0]  rgb;            //输出像素信息
	  
	  initial begin
	    left=1;
		  right=1;
		  up=1;
		  down=1;
		  clk=0;
		  rst_n=0;
		  
		  #1000;
		  rst_n=1;
	  end
	  
	  always #(10) clk =~clk;

top_greedy_snake
Utop_greedy_snake(
         .clk(clk),
	      .rst_n(rst_n),
	
	      .left(left),
         .right(right),
         .up(up),
	      .down(down),
	
          .beep(beep),           //输出蜂鸣器控制信号
          .led_out(led_out),        //输出控制led灯

           .stcp(stcp)        ,   //输出数据存储寄时钟
           .shcp(shcp)        ,   //移位寄存器的时钟输入
           .ds(ds)          ,   //串行数据输入
           .oe(oe)          ,   //输出使能信号

	        .hsync(hsync),
	        .vsync(vsync),
	        .rgb(rgb)            //输出像素信息

	
);


endmodule

