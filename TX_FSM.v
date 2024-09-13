module TX_FSM #(parameter WIDTH_STATE = 3,
                        WIDTH_MUX = 2)
(
input wire                DATA_VALID,SER_DONE,CLK,RST,PAR_ENABLE,
output reg                BUSY,SER_ENABLE,
output reg  [WIDTH_MUX-1:0]   MUX_SEL
);

parameter   [WIDTH_STATE-1:0]      IDLE='b000,
                                   START_BIT='b001,
		                           DATA='b011,
		                           PARITY='B010,
		                           STOP_BIT='b110;

reg  [WIDTH_STATE-1:0] current_state , next_state;
reg                   BUSY_COMB;

always @(posedge CLK or negedge RST)
 begin
    if(~RST)
       begin
	  current_state <= IDLE; 
	     end
    else
	  current_state <= next_state;
 end

always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    BUSY <= 1'b0 ;
   end
  else
   begin
    BUSY <= BUSY_COMB ;
   end
 end
  

always @(*)
 begin
    case(current_state)
	
	 IDLE        : begin
	                if(DATA_VALID)
			         next_state=START_BIT;
			        else
			         next_state=IDLE;
                    end
    
	 START_BIT   : begin 
	                next_state=DATA;
	               end
    	
	 DATA        : begin
	                if(SER_DONE)
	  			     begin
	 			      if(PAR_ENABLE)
	 	  	      	    next_state=PARITY;
                      else
                        next_state=STOP_BIT;
                     end			 
	                else
	                    next_state=DATA;
	            end
	 PARITY      : begin
                    next_state=STOP_BIT;
                  end	

     STOP_BIT   : begin
	                next_state=IDLE;
	              end
	 default    : begin
	                next_state=IDLE;
				  end
				  
    endcase
 end


always @(*)
 begin
    BUSY_COMB='b0;
	MUX_SEL='b00;
	SER_ENABLE='b0;
	
    case(current_state)
	IDLE      : begin
                 BUSY_COMB='b0;
                 SER_ENABLE='b0;
                 MUX_SEL='b11;			   
	            end
	START_BIT : begin
                 BUSY_COMB='b1;
                 SER_ENABLE='b0;
                 MUX_SEL='b00;  
               end 	
	DATA      : begin
                 BUSY_COMB='b1;
				 SER_ENABLE='b1;
                 MUX_SEL='b01;
                 if(SER_DONE)  SER_ENABLE='b0;
				 else          SER_ENABLE='b1;
				   end
	PARITY    : begin			 
	             BUSY_COMB='b1;
                 MUX_SEL='b10;
				end
	STOP_BIT  : begin
                 BUSY_COMB='b1;
                 MUX_SEL='b11; 
                end
    default   : begin
                 BUSY_COMB='b0;
                 SER_ENABLE='b0;
                 MUX_SEL='b00;	
                end
    endcase
 end


endmodule