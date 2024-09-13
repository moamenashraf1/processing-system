module RX_parity_check #(parameter data_width = 8,
                            edge_cnt_width = 6,
							prescale_width = 6)
(
input wire sampled_bit,PAR_TYP,par_chk_en,CLK,RST,
input wire [prescale_width-1:0] prescale,
input wire [edge_cnt_width-1:0] edge_cnt,
input wire [data_width-1:0]data,
output reg par_err	

);
  
reg calc_par_bit ;
reg par_err_c;

parameter EVEN = 'b0,
          ODD  = 'b1;


always @(posedge CLK or negedge RST)
 begin
    if(!RST)
      begin
	   par_err<='b0;
     end
    
	 
	else if(par_chk_en) 
	 begin 
	  par_err<=par_err_c;
	 
	 end
	 
 end


always @(*)
 begin

	    case(PAR_TYP)
         EVEN : calc_par_bit=^data;
		 ODD  : calc_par_bit=~^data;
	    endcase
	

	
 end 
 
 
 always @(*)
  begin
    if(par_chk_en && edge_cnt==((prescale/2)+2))  begin
  	   if(sampled_bit==calc_par_bit)
	     par_err_c='b0;
	   else
         par_err_c='b1;
	
    end  
 else
  par_err_c='b0;
  end
  
 
 
 
 
 
endmodule
