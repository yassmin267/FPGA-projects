module blinking(clk,led);
	input wire clk;
	reg [27:0] counter;
	reg clk_out;

	output reg [15:0]led;

	initial begin
		counter=0;
		clk_out=0;
		led=0;
	end

	always @(posedge clk) begin 
		if(counter==0) begin
		//counter <= 149999999;//actual value used to be shown on board blinking
        counter <= 10; //to be shown in simulation
        clk_out<= ~clk_out;
		end
		else begin
			counter<=counter-1;
		end
	end

	always @(posedge clk_out) begin 
		led<=~led;
	end
endmodule