/*
MODULE OVERVIEW:
Function of this module:
To calculate the grayscale values of each colour pixel(R,G,B respectively) stored in first memory module.
It communicates with the controller and the memory modules.

Working:
The module makes use of a FSM with 3 states:-
1)IDLE: Whenever the module is not in use, it is in this state. It waits for further commands from the controller.

2)FILL: Here every three pixel bytes at the input data bus is loaded into the internal registers for grayscale calculation.
        First byte is stored in 'red', second in 'green' and third in 'blue'.
        After the third byte is recieved, a status signal is sent to the first memory module to pause its operation.

3)CALCULATE: To find the grayscale value of the three bytes recieved.
             After placing the computed value in the output bus, a status signal is sent to the second memory module to store this value.
*/


module RGB_operator(
 input          clk,                     //clock
 input          rst_n,                   //external asynchronous active low reset
 input    [2:0]  RGB_artithmatic_select,
 input          RGB_opr_en,               //to enable or disable this module. Driven by controlle
 input          RWM_valid,               //an active high signal indicating the presence of desired data at the output data bus
 input [7:0]    Din,                     //input data bus. Connected to RWM_1 module
 output [7:0]   Dout,                    //output data bus. Connected to RWM_2 module
 output     GS_valid_out,                //an active high signal that tells the RWM_2 module that desired data bytes is present in the output data bus
 output         pause,                   //an active high signal that tells the RWM_1 module to pause whatever operation it is doing.
 output reg     GS_done                  //after the completion of an operation done is set to 1. It is a status signal to drive the controller
);

parameter N = 450, M = 450;


reg [7:0] red, green, blue, result;
wire [7:0] red_out, green_out, blue_out;

integer c, d, k=0;

parameter IDLE = 2'b00, FILL = 2'b01, CALCULATE = 2'b10;
reg [1:0] CS, NS;

wire GS_valid;

always @(posedge clk or negedge rst_n)
begin
if(~rst_n)
begin
  CS <= IDLE;
 // GS_valid_out <=0;
 end
 else
 begin
 
// GS_valid_out <=RWM_valid;
 
  CS <= NS;
  k = (RWM_valid) ?  k + 1 : 0;
  d = (k == 2) ? d + 1 : d;
 end
end


always @(*)
begin
 case (CS)
 IDLE:
 begin
  d = 0;
  c = 0;
  red = 8'h00;
  green = 8'h00;
  blue = 8'h00;
  GS_done = 1'b0;
  if(RGB_opr_en)
  begin
   NS = FILL;
  end
  else NS = IDLE;
 end
 FILL:
 begin
  GS_done = 1'b0;
  c = (c != 3) ? c + 1 : 1;
  red = (k == 0) ? Din : red;
  green = (k == 1) ? Din : green;
  blue = (k == 2) ? Din : blue;
  NS = (k == 2) ? CALCULATE : FILL;
  
  if (GS_valid_out)
begin
if (k == 1)
result = red_out;
else if (k == 2)
result = green_out;
else
result = blue_out;
end
  
  
 end
 CALCULATE:
 begin
 
// result = (red>>2) + (red>>5) + (green>>1) + (green>>4) + (blue>>4) + (blue>>5);

/*
if (GS_valid_out)
begin
if (k == 1)
result = red_out;
else if (k == 2)
result = green_out;
else
result = blue_out;
end
*/

  NS = (d == N*M) ? IDLE : FILL;
  GS_done = (d == N*M) ? 1'b1 : 1'b0;
  
  
 end
 default: NS = IDLE;
 endcase
end

assign pause = ((CS == FILL) && (c == 3) && (d != N*M)) ? 1'b1 : 1'b0;
assign Dout = (GS_valid_out) ? result : 8'hzz;
//assign Dout = (CS == CALCULATE) ? result : 8'hzz;
assign GS_valid = ((CS == FILL) && (k == 2)) ? 1'b1 : 1'b0;



image_arithmetic image_arithmetic_calc(
.clk                   (clk),
.rst_n               (rst_n),
.RGB_enable (RGB_opr_en),
. RGB_artithmatic_select  (RGB_artithmatic_select),
.in_red_pixel                       (red),
.in_green_pixel                   (green),
.in_blue_pixel                      (blue),
.RGB_valid_in                     (RWM_valid),
.VALUE                                (8'h80),
.out_red_pixel                     (red_out),
.out_green_pixel                 (green_out),
.out_blue_pixel                   (blue_out),
.RGB_valid_out                   (GS_valid_out)
);

endmodule
