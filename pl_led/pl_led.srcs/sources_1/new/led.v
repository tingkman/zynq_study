`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/09 10:14:00
// Design Name: 
// Module Name: led
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


module led(
    input sys_clk, 
    output reg [3:0] led 
    );
    
reg[31:0] timer_cnt;

always@(posedge sys_clk) //ÊäÈëÊ±ÖÓ°mÉÏÉıÑØ¼ì²â
begin
    if(timer_cnt >= 32'd49_999_999) 
    begin
        led <= ~led; 
        timer_cnt <= 32'd0; 
    end
    else
    begin
        led <= led; 
        timer_cnt <= timer_cnt + 32'd1; 
    end
end
endmodule
