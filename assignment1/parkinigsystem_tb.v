module car_parking_system_tb;
    reg clk;
    reg reset;
    reg front_sensor;
    reg [3:0] password;
    reg back_sensor;
    wire gate_open;
    
    car_parking_system dut(
        .clk(clk),
        .reset(reset),
        .front_sensor(front_sensor),
        .password(password),
        .back_sensor(back_sensor),
        .gate_open(gate_open)
        );
        
    initial begin
        clk = 0;
        reset = 1;
        front_sensor = 0;
        password = 4'b0000;
        back_sensor = 0;
        #10 reset = 0;
        #20 password = 4'b1101; 
        #30 front_sensor = 1; 
        #40 front_sensor = 0;
        #50 $display("Waiting for password...");
        #60 password = 4'b0000;
        #70 password = 4'b1111; 
        #80 $display("Waiting for car to exit...");
        #90 back_sensor = 1;
        #100 back_sensor = 0;
        #110 $display("Testbench finished.");
        #120 $finish;
    end
    
    always #5 clk = ~clk;
    
endmodule

module car_parking_system(
    input clk, 
    input reset,
    input front_sensor, 
    input [3:0] password, 
    input back_sensor, 
    output reg gate_open 
    );
    
    reg [3:0] entered_password; 
    reg password_entered;  
    
    // reset logic
    always @(posedge reset) begin
        entered_password <= 4'b0000;
        password_entered <= 0;
        gate_open <= 0;
    end
    
    
    always @(posedge clk) begin
        if (front_sensor && !password_entered) begin
            $display("Please enter password:"); 
            entered_password <= {entered_password[2:0], password};
            password_entered <= (entered_password == password); 
        end
    end
    
    
    always @(posedge clk) begin
        if (back_sensor && password_entered) begin 
            if (entered_password == password) begin 
                $display("Gate opening..."); 
                gate_open <= 1;  
            end else begin
                $display("Incorrect password. Try again."); 
            end
            entered_password <= 4'b0000; 
            password_entered <= 0; 
        end
end
endmodule
