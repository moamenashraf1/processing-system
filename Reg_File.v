module Reg_File #(parameter address_width = 4,
                            width = 8,                  
                            depth = 16) 
(
input  wire  [width-1:0]          WrData,
input  wire  [address_width-1:0]  Address,
input  wire                       WrEn,RdEn,CLK,RST,
output reg   [width-1:0]          RdData,
output reg                        RdData_Valid,

output   wire   [width-1:0]       REG0,
output   wire   [width-1:0]       REG1,
output   wire   [width-1:0]       REG2,
output   wire   [width-1:0]       REG3
);


reg [width-1:0] Registers [depth-1:0];
integer i;

always @(posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    RdData <= 'b0;
	RdData_Valid <= 'b0;
    for(i=0; i<depth ; i=i+1)    
     begin
	    if(i==2)
		 Registers[i] <= 'b100000_01;
		else if (i==3)
		 Registers[i] <= 'b0010_0000 ;
		else
	      Registers[i] <= 'b0;
	 end
   end 
   
  else if(WrEn && !RdEn)
   begin
    Registers[Address] <= WrData;
    RdData <= 'b0;	
   end
   
  else if(RdEn && !WrEn)
   begin
    RdData <= Registers[Address];
	RdData_Valid <= 'b1;
   end
   
  else
    RdData_Valid <= 'b0;  
 end
 
assign REG0 = Registers[0] ;
assign REG1 = Registers[1] ;
assign REG2 = Registers[2] ;
assign REG3 = Registers[3] ;

endmodule