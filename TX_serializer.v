module TX_serializer # ( parameter WIDTH = 8)
(
input   wire  [WIDTH-1:0]     P_DATA,
input   wire                  CLK,RST,SER_ENABLE,DATA_VALID,BUSY,
output  wire                  SER_DONE,
output  wire                  SER_DATA    
);

reg  [WIDTH-1:0]   serializer_data;  
reg  [WIDTH-6:0]   counter;

always @(posedge CLK or negedge RST)
 begin
    if(~RST)
	  serializer_data <= 'b0;
    
	else if(DATA_VALID && !BUSY)
	  serializer_data <= P_DATA;
	  
    else if (SER_ENABLE)
	  serializer_data <= serializer_data >> 1;

 end

always @(posedge CLK or negedge RST)
 begin
    if(~RST)
	  counter='b0;
	  
    else
	begin
	if (SER_ENABLE)
      counter = counter + 'b1;
	else 
    counter = 'b0;	
    end 
 end


assign SER_DONE = (counter=='b111); 
assign SER_DATA = serializer_data[0];
 
 endmodule