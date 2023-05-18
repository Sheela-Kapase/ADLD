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
                gate_open = 1'b1;  
            end else begin
                $display("Incorrect password. Try again."); 
                gate_open = 1'b0;
            end
            entered_password <= 4'b0000; 
            password_entered <= 0; 
        end
end
endmodule
