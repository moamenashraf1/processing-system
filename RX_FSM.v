module RX_FSM #(parameter edge_cnt_width = 6 ,
                       bit_cnt_width = 4 ,
                       state_width =   3 ,
					   prescale_width = 6)
(
input wire                       RX_IN,PAR_EN,PAR_ERR,strt_glitch,STP_ERR,CLK,RST,
input wire [edge_cnt_width-1:0]  edge_cnt,
input wire [bit_cnt_width-1:0]   bit_cnt,
input wire [prescale_width-1:0]  prescale,
output reg                       data_valid,deser_en,stp_chk_en,strt_chk_en,par_chk_en,enable,data_samp_en

);

parameter [state_width-1:0]  IDLE='b000,
                             START='b001,
							 DATA='b011,
							 PARITY='b010,
							 STOP='b110,
							 CHECK='b100;
							 
reg [state_width-1:0] current_state , next_state;
reg                   data_valid_comb;



always @(posedge CLK or negedge RST)
 begin
    if(!RST)
	 current_state<=IDLE;
    
	else
	current_state<=next_state;
 
 end


always @(posedge CLK or negedge RST)
 begin
    if(!RST)
	 data_valid<=0;
	 
	else 
	 data_valid<=data_valid_comb;
 
 end


always @(*)
 begin

		         
			 data_samp_en='b0;
	         enable='b0;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b0;
	         par_chk_en='b0;
    case(current_state)
	
	IDLE : begin
	        if(!RX_IN)
			 begin
			  next_state=START;			 
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b1;
	         par_chk_en='b0;

			  end
		    else begin
			 next_state=IDLE;	         
			 data_samp_en='b0;
	         enable='b0;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b0;
	         par_chk_en='b0;			
              end
	       end
 
    START: begin 
	
	        if(!strt_glitch)
			 begin
	          if(bit_cnt=='b1) begin
	          data_samp_en='b1;
	          enable='b1;
	          deser_en='b1;
	          data_valid_comb='b0;
	          stp_chk_en='b0;
	          strt_chk_en='b0;
	          par_chk_en='b0;			  
	           next_state=DATA; end
			  else begin
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b1;
	         par_chk_en='b0;			  
			  next_state=START; end
	         end
			else begin
	         data_samp_en='b0;
	         enable='b0;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b0;
	         par_chk_en='b0;			
			 next_state=IDLE; end
		   end
 
    DATA : begin
	        if(bit_cnt=='b1001) 
	        begin
			 if(PAR_EN) begin
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b0;
	         par_chk_en='b1;			 
			  next_state=PARITY; end
			 else begin
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b1;
	         strt_chk_en='b0;
	         par_chk_en='b0;
			  next_state=STOP; end
			end
			
			else begin
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b1;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b0;
	         par_chk_en='b0;			
			 next_state=DATA;  end
	       end
 
    PARITY:begin
	        if(bit_cnt=='b1010) begin
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b1;
	         data_valid_comb='b0;
	         stp_chk_en='b1;
	         strt_chk_en='b0;
	         par_chk_en='b0;
			 next_state=STOP; end
			else begin
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b0;
	         par_chk_en='b1;			
			 next_state=PARITY; end
	       end
  
    STOP: begin
	       if(edge_cnt== ((prescale/2)+2))
		   begin
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b0;
	         stp_chk_en='b1;
	         strt_chk_en='b0;
	         par_chk_en='b0;	
	        if(PAR_ERR==0 && STP_ERR==0) 
	         data_valid_comb='b1;
            else begin
			 data_valid_comb='b0; end
		   next_state=CHECK;
		   end
		   else begin
		   	 data_samp_en='b1;
	         enable='b1;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b1;
	         strt_chk_en='b0;
	         par_chk_en='b0;
		   next_state=STOP; end
	      end
	
	CHECK: begin
	       if(bit_cnt == 'b0)
		    begin
	         if(!RX_IN) begin
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b1;
	         par_chk_en='b0;             
			 next_state=START; end

             else begin
	         data_samp_en='b0;
	         enable='b0;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b0;
	         par_chk_en='b0;             
			 next_state=IDLE; end
            end			 
           else
		     begin
	         data_samp_en='b1;
	         enable='b1;
	         deser_en='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b0;
	         par_chk_en='b0;
             if(PAR_ERR==0 && STP_ERR==0) 
	         data_valid_comb='b1;
            else begin
			 data_valid_comb='b0; end			 
		     next_state=CHECK;		   
			 end
		end
			
    default: begin
	         data_samp_en='b0;
	         enable='b0;
	         deser_en='b0;
	         data_valid_comb='b0;
	         stp_chk_en='b0;
	         strt_chk_en='b0;
	         par_chk_en='b0;			
			 next_state=IDLE;	         
	         end
	endcase		 
 end

/*
always @(*)
 begin
	data_samp_en='b0;
	enable='b0;
	deser_en='b0;
	data_valid_comb='b0;
	stp_chk_en='b0;
	strt_chk_en='b0;
	par_chk_en='b0;
	
	case(current_state)
	IDLE  : begin
 	        data_samp_en='b0; 
			enable='b0;
			deser_en='b0;
			data_valid_comb='b0;
			stp_chk_en='b0;
			strt_chk_en='b0;
			par_chk_en='b0;          	
	        end
	
	START : begin
	        data_samp_en='b1;
            enable='b1;
            strt_chk_en='b1;
			 
	        end
	
	DATA  : begin
            data_samp_en='b1;
	        enable='b1;
	        deser_en='b1;       
	        end
	PARITY: begin
	        data_samp_en='b1;
	        enable='b1;
	        par_chk_en='b1;	  
             			
	        end
	
	STOP : begin
	        data_samp_en='b1;
	        enable='b1;
	        stp_chk_en='b1;	 	  
       	   end
		   
	CHECK: begin
	        enable='b1;	
	        if(PAR_ERR==0 && STP_ERR==0)
	         data_valid_comb='b1;
	
           end	
		   
	default:begin
	        data_samp_en='b0;
			enable='b0;
			deser_en='b0;
			data_valid_comb='b0;
			stp_chk_en='b0;
			strt_chk_en='b0;
			par_chk_en='b0;	
	        end
	
    endcase
 end
*/
endmodule
