module syn_tb;

	// Inputs
	reg clk;
	reg rst_n;
	reg w_en;
	reg r_en;
	reg [7:0] data_in;

	// Outputs
	wire [7:0] data_out;
	wire full;
	wire empty;
//integer delay;
	// Instantiate the Unit Under Test (UUT)
	synchronous_fifo uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.w_en(w_en), 
		.r_en(r_en), 
		.data_in(data_in), 
		.data_out(data_out), 
		.full(full), 
		.empty(empty)
	);
always #2 clk=~clk;
	initial begin
		// Initialize Inputs
		
		clk = 0;
		rst_n = 0;
		w_en = 0;
		r_en = 0;
		//data_in = 0;
 #3 rst_n=1;
 drive(20);
 drive(40);
 $finish;
		// Wait 100 ns for global reset to finish
		
        
		// Add stimulus here

	end
	
	task push();
	if(!full) begin
	w_en=1;
	data_in=$random;
     #1 $display("time:%d Push In: w_en=%b, r_en=%b, data_in=%h",$time,w_en,r_en,data_in);
	  end
	  else $display("FIFO Full!! Cannot push data_in=%d",data_in);
	  endtask
	  
	  task pop();
	  if(!empty) begin
	  r_en=1;
	  #1 $display("time:%d Pop Out: w_en=%b, r_en=%b, data_out=%h",$time,w_en,r_en,data_out);
	  end
	  else $display("time:%d FIFO Empty!! Cannot pop data out",$time);
	  endtask
	  
	  task drive(integer delay);
	  begin
	  w_en=0; r_en=0;
	  fork
	   begin
		 repeat(10) begin @(posedge clk) push(); end
		 w_en=0;
		 end
		 begin
		 #delay;
		 repeat(10) begin @(posedge clk) pop(); end
		 r_en=0;end
		 join
		 end
		 endtask
endmodule
