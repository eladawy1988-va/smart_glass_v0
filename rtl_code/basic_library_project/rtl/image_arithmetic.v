/*
MODULE OVERVIEW:
Function of this module:
To calcute the arithmatci operatror 

*/

module image_arithmetic(
 input          clk,                     //clock
 input          rst_n,                   //external asynchronous active low reset
 input          RGB_enable,        //to enable or disable this module. Driven by controller
 input  [2:0] RGB_artithmatic_select,        //to select arithamtic operator 
 input [7:0] in_red_pixel,      // red pixel
 input [7:0] in_green_pixel,  // green pixel   
input [7:0] in_blue_pixel,    // blue pixel
input          RGB_valid_in,       // valid for red , green and blue pixel  

input  [7:0] VALUE,    // blue pixel

output  [7:0] out_red_pixel,      // red pixel
output  [7:0] out_green_pixel,  // green pixel   
output  [7:0] out_blue_pixel,    // blue pixel
output    reg      RGB_valid_out       // valid for red , green and blue pixel  
);

parameter ADD = 4'd0, SUB = 4'd1, MUL = 4'd2,DIV = 4'd3,AND = 4'd4,OR = 4'd5,NOT = 4'd6;

wire GS_valid;

reg  [8:0] red_pixel_tmp;     // red pixel
reg  [8:0] green_pixel_tmp;  // green pixel   
reg  [8:0] blue_pixel_tmp;    // blue pixel

always @(posedge clk or negedge rst_n)
begin
if(~rst_n)
begin
  RGB_valid_out <=0;
 end
 else
 begin 
 RGB_valid_out <= RGB_valid_in;
 end
end


always @(*)
begin
 case (RGB_artithmatic_select)
 ADD:
 begin
		red_pixel_tmp = in_red_pixel + VALUE;
		if (red_pixel_tmp>255)
		red_pixel_tmp = 255;
		green_pixel_tmp = in_green_pixel + VALUE;
		if (green_pixel_tmp>255)
		green_pixel_tmp = 255;
		blue_pixel_tmp = in_blue_pixel + VALUE;
		if (blue_pixel_tmp>255)
		blue_pixel_tmp = 255;
 end
 SUB:
 begin
		red_pixel_tmp = in_red_pixel - VALUE;
		if (red_pixel_tmp>255)
		red_pixel_tmp = 0;
		green_pixel_tmp = in_green_pixel - VALUE;
		if (green_pixel_tmp>255)
		green_pixel_tmp = 0;
		blue_pixel_tmp = in_blue_pixel - VALUE;
		if (blue_pixel_tmp>255)
		blue_pixel_tmp = 0;
 end
 MUL:
 begin
		red_pixel_tmp = in_red_pixel * VALUE;
		green_pixel_tmp = in_green_pixel * VALUE;
		blue_pixel_tmp = in_blue_pixel * VALUE;
 end
 DIV:
 begin
 		red_pixel_tmp = in_red_pixel >> VALUE;
		green_pixel_tmp = in_green_pixel >> VALUE;
		blue_pixel_tmp = in_blue_pixel >> VALUE;
 end
 AND:
 begin
 		red_pixel_tmp = in_red_pixel & VALUE;
		green_pixel_tmp = in_green_pixel & VALUE;
		blue_pixel_tmp = in_blue_pixel & VALUE;
 end
  OR:
 begin
  		red_pixel_tmp = in_red_pixel | VALUE;
		green_pixel_tmp = in_green_pixel | VALUE;
		blue_pixel_tmp = in_blue_pixel | VALUE;
 end
   NOT:
 begin
 		red_pixel_tmp = !(in_red_pixel) ;
		green_pixel_tmp = !(in_green_pixel);
		blue_pixel_tmp = !(in_blue_pixel);
 end


 endcase
end


assign out_red_pixel = red_pixel_tmp[7:0];
assign out_green_pixel = green_pixel_tmp[7:0];
assign out_blue_pixel = blue_pixel_tmp[7:0];

endmodule
