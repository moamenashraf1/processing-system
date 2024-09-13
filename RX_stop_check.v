module RX_stop_check #(parameter edge_cnt_width = 6,
                                 prescale_width = 6)
(
input wire sampled_bit,stp_chk_en,CLK,RST,
input wire [prescale_width-1:0] prescale,
input wire [edge_cnt_width-1:0] edge_cnt,
output reg stp_err

);

always @(posedge CLK or negedge RST)
 begin
    if(!RST)
	  stp_err<='b0;
	 
	else if(stp_chk_en && edge_cnt==((prescale/2)+2))
	 begin
        if(sampled_bit==1)
	      stp_err<='b0;
      else
	      stp_err<='b1;
 
      end
	else 
	 stp_err<='b0;
	 
 
 end


endmodule