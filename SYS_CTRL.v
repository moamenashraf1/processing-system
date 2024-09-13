module SYS_CTRL #(parameter DATA_WIDTH = 8,
                            ALU_OUT_WIDTH = DATA_WIDTH*2 ,
							state_width = 4 ,
							address_width = 4)
(
input wire                  CLK, RST,
 
input wire [DATA_WIDTH-1:0]    SYNC_RX_DATA,
input wire                     enable,

input wire                     FIFO_FULL,
output reg [DATA_WIDTH-1:0]    WR_DATA,
output reg                     WR_INC,

input wire                     RD_DATA_VALID,
input wire [DATA_WIDTH-1:0]    RD_DATA,
output reg                     WR_EN,
output reg                     RD_EN,
output reg [address_width-1:0] ADDR,
output reg [DATA_WIDTH-1:0]    WR_D,

output reg                     GATE_EN,

input wire [ALU_OUT_WIDTH-1:0] ALU_OUT,                              
input wire                     ALU_VALID,
output reg [3:0]               ALU_FUNC,
output reg                     ALU_EN

);

parameter [state_width-1:0] IDLE         = 'b0000,
                            RF_WR_ADDR   = 'b0001,
                            RF_RD_ADDR   = 'b0011,
							ALU_OP_A     = 'b0010,
							ALU_FN       = 'b0110,
							RF_WR_DATA   = 'b0100,
							ALU_OP_B     = 'b0101,
							ALU_FN1      = 'b0111,
							RF_FIFO      = 'b1111,
							ALU_FIFO     = 'b1110,
							ALU_FIFO_2   = 'b1100;
						
							
				  
				  
reg [state_width-1:0] current_state , next_state;
reg [address_width-1:0] addr;
reg [DATA_WIDTH-1:0] ALU_temp;
reg                  flag_addr;
reg                  flag_alu;

always @(posedge CLK or negedge RST)
 begin
    if(!RST)
	 current_state<=IDLE;
    
	else
	current_state<=next_state;
 
 end


always @(*)
 begin
  ALU_EN = 'b0;
  ALU_FUNC = 'b1111;
 
  WR_INC = 'b0;
  WR_DATA = 'b0;
 
  WR_EN = 'b0;
  RD_EN = 'b0;
  ADDR = 'b0;
  WR_DATA = 'b0;
  WR_D = 'b0;
  GATE_EN = 'b0;
  flag_addr='b0;
  flag_alu='b0;
    case(current_state)
     IDLE  : begin
	           if(enable)
                begin
				 case(SYNC_RX_DATA)
				    'b1010_1010 : next_state = RF_WR_ADDR;
					'b1011_1011 : next_state = RF_RD_ADDR;
					'b1100_1100 : next_state = ALU_OP_A ;
 				    'b1101_1101 : next_state = ALU_FN;
					default : next_state = IDLE ;
				 endcase
				end
			   else
			    begin
				 next_state = IDLE;
				end
			 end
 
     RF_WR_ADDR : 
             begin
			    if(enable)
				 begin
				    flag_addr ='b1;
				    next_state = RF_WR_DATA;
				 end
			    else
				 begin
				    next_state = RF_WR_ADDR;
				 end
			 end
 
     RF_WR_DATA :
	         begin
			    if(enable)
				 begin
					WR_EN = 'b1;				    
					WR_D = SYNC_RX_DATA;
					ADDR = addr;
					next_state = IDLE;
				 end
			    else
				 begin
				    next_state = RF_WR_DATA;
				 end
			 end
 
     RF_RD_ADDR :
	         begin
			    if(enable)
				 begin
				    ADDR = SYNC_RX_DATA;
				    RD_EN = 'b1;
					next_state = RF_FIFO;
				 end 
			    else
				 begin
				    next_state = RF_RD_ADDR;
				 end
			 end
  
     RF_FIFO :
	         begin
				if(RD_DATA_VALID && !FIFO_FULL)
                  begin					
				    WR_INC = 'b1;
					WR_DATA = RD_DATA;
					next_state = IDLE;
				  end
		     	else
                 begin
	      		    WR_INC = 'b0;
				    WR_DATA = 'b0;	
                    next_state = RF_FIFO;					
			     end		 
			 end
 
     ALU_OP_A : 
	         begin
			    if(enable)
				 begin
				    ADDR =  'h0;
			        WR_EN = 'b1;
				    WR_D = SYNC_RX_DATA;
				    next_state = ALU_OP_B;
				 end
			    else
				 begin
				    next_state = ALU_OP_A;
				 end
			 end
 
     ALU_OP_B : 
	         begin
			    if(enable)
				 begin
				    ADDR =  'h1;
					WR_EN = 'b1;
					WR_D = SYNC_RX_DATA;
					next_state = ALU_FN1;
				 end
				else
				 begin
				    next_state = ALU_OP_B;
				 end
			 end
 
     ALU_FN1 :
	         begin
	 	       GATE_EN ='b1;			 
			    if(enable)
				 begin
				    ALU_FUNC = SYNC_RX_DATA;
					ALU_EN = 'b1;
					next_state = ALU_FIFO;
				 end
			    else
				 begin
				    next_state = ALU_FN1;
				 end
			 end
 
     ALU_FIFO : 
	         begin
				GATE_EN = 'b1;			 
				if(ALU_VALID && !FIFO_FULL)
				 begin
				    WR_INC = 'b1;
					flag_alu ='b1;
					WR_DATA = ALU_OUT[7:0];
					next_state = ALU_FIFO_2;
				 end
				else
				 begin
				    WR_INC = 'b0;
					WR_DATA = 'b0;
					next_state = ALU_FIFO;
				 end			 
			 end
 
     ALU_FIFO_2 :
	         begin
			  GATE_EN = 'b1;			  
			  if(!FIFO_FULL)
			   begin
				WR_INC = 'b1;
				WR_DATA = ALU_temp;
				next_state = IDLE;
			   end
			  else
			   begin
			   next_state = ALU_FIFO_2;
			   end
			 end
 
     ALU_FN :
	         begin
			    GATE_EN = 'b1;
			    if(enable)
				 begin				    
					ALU_FUNC = SYNC_RX_DATA;
				    ALU_EN = 'b1;
					next_state = ALU_FIFO;
				 end
			     else
				  begin
				    next_state = ALU_FN;
				  end
			 end
    
	
     default :
	         begin
			    next_state = IDLE;
				GATE_EN='b0;
			 end
 
    endcase
 end


always @(posedge CLK or negedge RST)
 begin
    if(!RST)
	 begin
	    addr <= 'b0;
	 end
	else if(flag_addr)
     begin
        addr <= SYNC_RX_DATA;
	 end	 
 end
 
 
always @(posedge CLK or negedge RST)
 begin
    if(!RST)
	 begin
	    ALU_temp <= 'b0;
	 end
	else if(flag_alu)
     begin
        ALU_temp <= ALU_OUT[15:8];
	 end	 
 

 end
endmodule
 
