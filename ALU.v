module ALU #(parameter width = 8 ,
                       out_width = width*2)
(

input  wire [width-1:0]      A,B,
input  wire [3:0]            ALU_FUN, 
input  wire                  CLK, RST , ENABLE ,
output reg  [out_width-1:0]  ALU_OUT,
output reg                   OUT_VALID
);

reg [out_width-1:0] ALU_OUT_comb;
reg [out_width-1:0] OUT_VALID_comb;

always @(posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
     ALU_OUT <= 'b0;
     OUT_VALID <= 'b0;
   end
  else
   begin
	 ALU_OUT <= ALU_OUT_comb;
	 OUT_VALID <= OUT_VALID_comb;
   end
 end
 
always @(*)
 begin
    ALU_OUT_comb = 'b0;
    OUT_VALID_comb = 'b0;
  if(ENABLE)
   begin
    OUT_VALID_comb = 'b1; 
    case(ALU_FUN)
       4'b0000 : begin ALU_OUT_comb = A + B ; end
	   4'b0001 : begin ALU_OUT_comb = A - B ; end
       4'b0010 : begin ALU_OUT_comb = A * B ; end
	   4'b0011 : begin ALU_OUT_comb = A / B ; end
	   4'b0100 : begin ALU_OUT_comb = A & B ; end
	   4'b0101 : begin ALU_OUT_comb = A | B ; end
	   4'b0110 : begin ALU_OUT_comb = ~(A & B); end
	   4'b0111 : begin ALU_OUT_comb = ~(A | B); end
	   4'b1000 : begin ALU_OUT_comb = A ^ B ; end
	   4'b1001 : begin ALU_OUT_comb = ~(A ^ B); end
	   4'b1010 : begin if(A==B) ALU_OUT_comb=1; else ALU_OUT_comb=0;  end 
	   4'b1011 : begin if(A>B)  ALU_OUT_comb=2; else ALU_OUT_comb=0;  end
	   4'b1100 : begin if(A<B)  ALU_OUT_comb=3; else ALU_OUT_comb=0;  end
	   4'b1101 : begin ALU_OUT_comb = A>>1 ;  end
	   4'b1110 : begin ALU_OUT_comb = A<<1 ;  end
	   default : begin ALU_OUT_comb = 'b0 ;     end
	endcase 
   end
   
  else
   begin
    ALU_OUT_comb = 'b0;
	OUT_VALID_comb = 'b0;
   end
 end
 endmodule