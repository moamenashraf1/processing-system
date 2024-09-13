module TX_parity_calc #(parameter WIDTH = 8)
(
input wire                 DATA_VALID,PAR_TYP,CLK,RST,BUSY,PAR_ENABLE,
input wire  [WIDTH-1:0]    P_DATA,
output reg                 PAR_BIT 
);

reg [WIDTH-1:0]  PARITY_CALC_DATA;

always @(posedge CLK or negedge RST)
 begin
    if(~RST)
	 PARITY_CALC_DATA<=0;
	else if(DATA_VALID && ~BUSY)
     PARITY_CALC_DATA<=P_DATA;
	 
 end


always @(posedge CLK or negedge RST)
 begin
    if(~RST)
      begin
	 PAR_BIT<='b0;
	 end
	else
     begin
	    if(PAR_ENABLE)
          begin
		    if(PAR_TYP=='b0)       PAR_BIT <= ^PARITY_CALC_DATA;   //even
			else if(PAR_TYP=='b1)  PAR_BIT <= ~^PARITY_CALC_DATA;  //odd
		  end		
	 end	
 end 
	
endmodule