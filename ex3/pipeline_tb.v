module pipeline_tb;
parameter N=10;
reg [N-1:0]A,B,C,D;
reg clk=1'b0;
wire [N-1:0]F;

pipe_ex PIPE(F,A,B,C,D,clk);



always #5 clk=~clk;
initial 
 begin
  
 #10 A=5;B=6;C=2;D=1;
 #20 A=4;B=2;C=5;D=3;
 #30 $stop();
 
end

endmodule

module pipe_ex(F,A,B,C,D,clk);
parameter N=10;
input [N-1:0]A,B,C,D;
input clk;
output [N-1:0]F;
reg [N-1:0] L12_x1, L12_x2, L12_D, L23_x3, L23_D, L34_F;

assign F=L34_F;

always @(posedge clk)
begin
 L12_x1 <= #4 A+B;
 L12_x2 <= #4 C-D;
 L12_D <= D;

 L23_x3 <= L12_x1+L12_x2;
 L23_D <= L12_D;

 L34_F <= #6 L23_x3+L23_D;
end
endmodule

