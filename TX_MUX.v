module TX_MUX #(parameter WIDTH_MUX = 2)
(
input wire CLK,RST,START_BIT,STOP_BIT,SER_DATA,PAR_BIT,
input wire [WIDTH_MUX-1:0] MUX_SEL, 
output reg TX_OUT
);

reg TX_OUT_COMB;

always @(posedge CLK or negedge RST)
 begin
    if(~RST)
	 TX_OUT<='b0;
	else
     TX_OUT<=TX_OUT_COMB;	
 end

always @(*)
 begin
    case(MUX_SEL)
	2'b00 : begin TX_OUT_COMB = START_BIT; end  
    2'b01 : begin TX_OUT_COMB = SER_DATA; end
	2'b10 : begin TX_OUT_COMB = PAR_BIT; end
	2'b11 : begin TX_OUT_COMB = STOP_BIT; end
    endcase
 end

endmodule