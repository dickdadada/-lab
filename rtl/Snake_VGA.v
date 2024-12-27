`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/06 09:17:22
// Design Name: 
// Module Name: Snake_VGA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Snake_VGA(
       input clk,
       input rst_n,
       input [1:0]snake,
	   input [5:0]apple_x,
	   input [4:0]apple_y,
	   input [11:0] x_pos,
	   input [11:0] y_pos,
	   output reg [23:0] vga_rgb
       );
       
    localparam NONE = 2'b00;
	localparam HEAD = 2'b01;
	localparam BODY = 2'b10;
	localparam WALL = 2'b11;
	
	localparam HEAD_COLOR = 24'h0000ff;
	localparam BODY_COLOR = 24'hffff00;
	
	reg [3:0]lox;
	reg [3:0]loy;
	
	always@(posedge clk or negedge rst_n) begin
		if(rst_n==1'b0) begin
		  vga_rgb<=24'b0;
		end
		else begin	
			if(x_pos >= 0 && x_pos < 640 && y_pos >= 0 && y_pos < 480) begin
			    lox = x_pos[3:0];
				loy = y_pos[3:0];						
				if(x_pos[9:4] == apple_x && y_pos[9:4] == apple_y)
					case({loy,lox})
						8'b0000_0000:vga_rgb = 24'b0;
						default:vga_rgb = 24'hff0000;
					endcase						
				else if(snake == NONE)
					vga_rgb = 24'h0;
				else if(snake == WALL)
					vga_rgb = 24'hff0000;
				else if(snake == HEAD|snake == BODY) begin   //根据当前扫描到的点是哪一部分输出相应颜色
					case({lox,loy})
						8'b0000_0000:vga_rgb = 24'h0;
						default:vga_rgb = (snake == HEAD) ?  HEAD_COLOR : BODY_COLOR;
					endcase
				end
			end
		    else
			    vga_rgb = 24'h0;
		end
    end
    
endmodule
