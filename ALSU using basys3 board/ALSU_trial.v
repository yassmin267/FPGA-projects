module ALSU_test(A,B,op_code,c_in,s_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clock_100Mhz,rst,out,leds,valid);
	input wire [2:0] A,B, op_code;
	input wire c_in,s_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clock_100Mhz,rst;
	output reg[5:0] out;
	output reg[15:0] leds;
	output reg valid;

	parameter input_priority ="A";
	parameter full_adder="on";

	wire [15:0] led_blink;

	//reg tmp;

	always @(posedge clock_100Mhz or posedge rst) begin
		if(rst) begin
			out<= 0;
			leds<=0;
			valid<=1;
		end 
		else begin
			if((bypass_A==1)&&(bypass_B==1)) begin
				if(input_priority=="A") begin
					out<=A;
					valid<=1;
				end
				else if(input_priority=="B") begin
					out<=B;
					valid<=1;
				end		
			end
			else if(bypass_A) begin
				out<=A;
				valid<=1;
			end
				
			else if(bypass_B) begin
				out<=B;
				valid<=1;
			end
				
			else begin
				case (op_code)
					//AND
					3'b000: 
					if((red_op_A)==1&&(red_op_B==1)) begin
						if(input_priority=="A") begin
							out<=(&A);
							valid<=1;
						end
							
						else if(input_priority=="B") begin
							out<=(&B);
							valid<=1;
						end
							
					end
					else if(red_op_A) begin
						out<=(&A);
						valid<=1;
					end
						
					else if(red_op_B) begin
						out<=(&B);
						valid<=1;
					end
						
					else begin
						out<=A&B;
						valid<=1;
					end 

					//XOR
					3'b001:
					if((red_op_A)==1&&(red_op_B==1)) begin
						if(input_priority=="A") begin
							out<=(^A);
							valid<=1;
						end
							
						else if(input_priority=="B") begin
							out<=(^B);
							valid<=1;
						end
					end
					else if(red_op_A) begin
						out<=(^A);
						valid<=1;
					end
						
					else if(red_op_B) begin
						out<=(^B);
						valid<=1;
					end
						
					else begin
						out<=A^B;
						valid<=1;
					end 

					//addition
					3'b010:
					if((red_op_A==1)||(red_op_B==1)) begin
						out<=0;
						valid<=0;
						leds<=led_blink;
					end
					else if(full_adder=="on") begin
						out<=(A^B)^c_in;
						valid<=1;
					end
					else begin
						out<=A+B;
						valid<=1;
					end 

					//Multiplication
					3'b011:
					if((red_op_A==1)||(red_op_B==1)) begin
						out<=0;
						valid<=0;
						leds<=led_blink;
					end
					else begin
						out<=A*B;
						valid<=1;
					end 

					//shift (direction=1 shift left)
					3'b100:
					if((red_op_A==1)||(red_op_B==1)) begin
						out<=0;
						valid<=0;
						leds<=led_blink;
					end
					else if(direction) begin //shift left
						out<={out[4:0],s_in};
						valid<=1;
					end 
					else begin  //shift right
						out<={s_in,out[5:1]};
						valid<=1;
					end 

					//rotate
					3'b101:
					if((red_op_A==1)||(red_op_B==1)) begin
						out<=0;
						valid<=0;
						leds<=led_blink;
					end
					else if(direction) begin  //rotate left 
						out<={out[4:0],out[5]};
					    valid<=1;
					end
					else begin  //rotate right
						out<={out[0],out[5:1]};
						valid<=1;
					end 

					//invalid cases
					3'b110: begin
						out<=0;
						valid<=0;
						leds<=led_blink;
					end

					3'b111: begin
						out<=0;
						valid<=0;
						leds<=led_blink;
					end

					default: begin 
						out<=0;
						leds<=0;
						valid<=1;
						end 
				endcase
			end
		end
	end
blinking blink(clock_100Mhz,led_blink);
endmodule 
