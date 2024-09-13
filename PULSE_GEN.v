module PULSE_GEN 
(
input    wire                      clk,
input    wire                      rst,
input    wire                      IN,
output   wire                      OUT
);

reg              reg1 , reg2  ;

always @(posedge clk or negedge rst)
 begin
  if(!rst)      
   begin
    reg1 <= 1'b0 ;
    reg2 <= 1'b0 ;	
   end
  else
   begin
    reg1 <= IN;   
    reg2 <= reg1;
   end  
 end
 
//----------------- pulse generator --------------------

assign OUT = reg1 && !reg2 ;


endmodule