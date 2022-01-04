module display(
input           clk,
input           data_valid,
input [7:0]     data_out);

integer file_id;
initial
begin
 file_id = $fopen("../image/out_image.txt", "w");
 $fclose(file_id);
end
always @(posedge clk)
begin
 if (data_valid)
 begin
  file_id = $fopen("../image/out_image.txt", "a");
  $fwrite(file_id, "%h\n", data_out);
  $fclose(file_id);
 end
end
endmodule
