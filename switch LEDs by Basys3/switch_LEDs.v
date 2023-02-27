module switch_LEDs(in, out, clk, rst);
input [3:0] in;
input clk, rst;
output reg [3:0] out;
  
  always @(posedge clk or posedge rst) begin
    if(rst) 
      out <= 4'h0; 
    else 
      out <= in;
  end

endmodule