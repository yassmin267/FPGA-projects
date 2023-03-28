module Seven_segment_LED_Display_Controller(clock_100Mhz,reset, 
    Anode_Activate,LED_out, A,B,op_code,c_in,s_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,leds);
    input clock_100Mhz;
    input reset;
    
    output reg [3:0] Anode_Activate; // anode signals of the 7-segment LED display
    output reg [6:0] LED_out; // cathode patterns of the 7-segment LED display
    output [15:0] leds;

    input [2:0] A,B, op_code;
    input c_in,s_in,direction,red_op_A,red_op_B,bypass_A,bypass_B;
    
    wire [5:0] out;
    wire valid;

    ALSU_test s(A,B,op_code,c_in,s_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clock_100Mhz,reset,out,leds,valid);

    reg [26:0] one_second_counter;
    wire one_second_enable;
    reg [15:0] displayed_number; 
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; 
    wire [1:0] LED_activating_counter; 
            
    always @(posedge clock_100Mhz or posedge reset)
    begin 
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[1:0];  //time to toggle(10ns*2^18)

    always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 4'b1110; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            if(~valid)
                LED_BCD=4'b0100;
            else LED_BCD =out[3:0]; 
            // the first digit of the 16-bit number
              end
        2'b01: begin
            Anode_Activate = 4'b1101; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            if(~valid)
                LED_BCD=4'b0000;
            else LED_BCD =out[7:4]; 
            // the second digit of the 16-bit number
              end
        2'b10: begin
            Anode_Activate = 4'b1101; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            if(~valid)
                LED_BCD=4'b0100;
            else LED_BCD =4'bxxxx ; 
            // the third digit of the 16-bit number
                end
        2'b11: begin
            Anode_Activate = 4'b0111; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            if(~valid)
                LED_BCD=4'b1110;
            else LED_BCD =4'bxxxx ; 
            // the fourth digit of the 16-bit number    
               end
        endcase
    end

    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        
        4'b1010: LED_out = 7'b0001000; // "10--> A"     
        4'b1011: LED_out = 7'b1100000; // "11--> b" 
        4'b1100: LED_out = 7'b0110001; // "12--> C" 
        4'b1101: LED_out = 7'b1000010; // "13--> d" 
        4'b1110: LED_out = 7'b0110000; // "14--> E" 
        4'b1111: LED_out = 7'b0111000; // "15--> F" 
        default: LED_out = 7'b1111110; // "- activate common G only"
        endcase
    end
 endmodule


