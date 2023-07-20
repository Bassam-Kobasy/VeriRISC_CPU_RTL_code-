module Gen_Reg 
#(
parameter WIDTH=8
)
  (
  input wire [WIDTH-1:0] data_in,
  input wire load,
  input wire clk,
  input wire rst,
  output reg [WIDTH-1:0] data_out
  );
  always @ (posedge clk)
  begin
    if (rst)
      data_out = 'd0;
    else if (load)
      data_out = data_in;
    else
      data_out = data_out; 
  
  end 
    
endmodule 

