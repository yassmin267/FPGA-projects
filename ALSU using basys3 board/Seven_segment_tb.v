`timescale 1ns / 1ps

module Seven_segment_LED_Display_Controller_tb();
	reg clock_100Mhz;
    reg [2:0] A,B, op_code;
	reg c_in,s_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,reset;

	wire [15:0] leds;
	wire [3:0] Anode_Activate; // anode signals of the 7-segment LED display
    wire [6:0] LED_out; // cathode patterns of the 7-segment LED display

	Seven_segment_LED_Display_Controller test( clock_100Mhz,reset, 
    Anode_Activate,LED_out, A,B,op_code,c_in,s_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,leds);


	initial begin
		clock_100Mhz=0;
		forever
		#1 clock_100Mhz=~clock_100Mhz;
	end

	initial begin
		reset=1;
		c_in=1;
		s_in=1;
		direction=0;
		A=111;
		B=110;

		#10 ;

        //out=A ,leds=0
        reset=0;
        bypass_A=1;
        bypass_B=1;
        #10
        //out=A ,leds=0
        bypass_A=1;
        bypass_B=0;
        #10
        //out=B ,leds=0
        bypass_A=0;
        bypass_B=1;
        #10
        //start to chech op code //out=B ,leds=0
        bypass_A=0;
        bypass_B=0;
        #10
        //and
        //out=&A
		op_code=000;
		red_op_A=1;
		red_op_B=1;
		#10
		//out=&A
		red_op_A=1;
		red_op_B=0;
		#10
		//out=&B
		red_op_A=0;
		red_op_B=1;
		#10
		//out=A&B
		red_op_A=0;
		red_op_B=0;
		#10

		//xor
		////out=^A
		op_code=001;
		red_op_A=1;
		red_op_B=1;
		#10
		//out=^A
		red_op_A=1;
		red_op_B=0;
		#10
		//out=^B
		red_op_A=0;
		red_op_B=1;
		#10
		//out=B^A
		red_op_A=0;
		red_op_B=0;
		#10

		//Multiplication
		A=111;
		B=110;
		//OUT=0 ,leds<={16{1'b1}}
		op_code=011;
		red_op_A=1;
		red_op_B=0;
		#10
		//OUT=0 ,leds<={16{1'b1}}
		red_op_A=0;
		red_op_B=1;
		#10
		//OUT=A*B
		red_op_A=0;
		red_op_B=0;
		#10

		//addition
		op_code=010;
		//OUT=0 ,leds<={16{1'b1}}
		red_op_A=1;
		red_op_B=0;
		#10
		//OUT=0 ,leds<={16{1'b1}}
		red_op_A=0;
		red_op_B=1;
		#10
		A=000;
		B=010;
		//OUT=A+B
		red_op_A=0;
		red_op_B=0;
		#10

		//shift LIFT with sin=1
		op_code=100;
		red_op_A=0;
		red_op_B=0;
		direction=1;
		#10

		//addition
		op_code=010;
		A=000;
		B=010;
		//OUT=A+B
		red_op_A=0;
		red_op_B=0;
		#10

		//rotate
		op_code=101;
		red_op_A=0;
		red_op_B=0;
		#10

		//invalid cases
		op_code=110;
		red_op_A=0;
		red_op_B=0;
		#10

		op_code=111;
		red_op_A=0;
		red_op_B=0;
		#10
		$stop;
	end

	initial begin
    $monitor("A=%b,B=%b,op_code=%b,c_in=%b,s_in=%b,direction=%b,red_op_A=%b,red_op_B=%b,bypass_A=%b,bypass_B=%b,clk=%b,rst=%b,leds=%b,LED_out=%b,Anode_Activate=%b",A,B,op_code,c_in,s_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clock_100Mhz,reset,leds,LED_out,Anode_Activate); 
    end     

endmodule 

