module RX_counter #(parameter prescale_width = 6 ,
                           edge_cnt_width = 6,
                           bit_cnt_width = 4
) 
(
input wire                      enable,CLK,RST,
input wire [prescale_width-1:0] prescale,    
output reg [edge_cnt_width-1:0] edge_cnt,
output reg [bit_cnt_width-1:0] bit_cnt

);

always @(posedge CLK or negedge RST)
 begin
    if(!RST)
	begin
	 edge_cnt<='b0;
	 bit_cnt<='b0;
    end
   
    else
     begin   
      if(enable)
        begin
	    if(bit_cnt=='b1010 && edge_cnt==prescale-1) begin
		 bit_cnt<='b0;
	     edge_cnt<='b0; end
	  
	    else if(edge_cnt==prescale-1) begin
	      bit_cnt<=bit_cnt+'b1;
	      edge_cnt<='b0;  end
	  
	    else   begin
	    edge_cnt<=edge_cnt+'b1;
		bit_cnt<=bit_cnt; end
	   
	    end
	 
	  else begin
	  bit_cnt<='b0;
	  edge_cnt<='b0; end	

	end
 end
endmodule