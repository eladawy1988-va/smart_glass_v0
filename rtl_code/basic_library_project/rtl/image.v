module image(
input               clk,
input               camera_en,
output reg          data_valid,
output reg [7:0]    data_out);


parameter N = 450, M = 450;

reg [7:0] mem[3*N*M:0];
integer ptr;

initial
begin
 //$readmemh("left.txt", mem);
    $readmemh("../image/left.txt",mem,0,3*N*M-1); // read file from INFILE
 ptr <= 0;
end

always @(posedge clk)
begin
 if (camera_en)
 begin
  data_valid <= 1'b1;
  data_out <= mem[ptr];
  ptr <= ptr + 1;
 end
 else
 begin
  data_valid <= 0;
  ptr <= 0;
  data_out <= 8'hzz;
 end
 if (ptr == ((N*M*3) - 1))
 begin
  ptr <= 0;
 end
end
endmodule
