module RX_start_check #(parameter edge_cnt_width = 6,
                                  prescale_width = 6)
(
input wire sampled_bit,strt_chk_en,CLK,RST,
input wire [prescale_width-1:0] prescale,
input wire [edge_cnt_width-1:0] edge_cnt,
output reg strt_glitch
);

always @(posedge CLK or negedge RST)
 begin
    if(!RST)
	 strt_glitch<='b0;
    
	else if(strt_chk_en && edge_cnt==((prescale/2)+2)) begin
	 if(sampled_bit==1)
	  strt_glitch<='b1;
	 else
	  strt_glitch<='b0;
	 end
	 
	 else
	 strt_glitch<='b0;
 end

endmodule