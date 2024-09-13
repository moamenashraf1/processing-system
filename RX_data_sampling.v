module RX_data_sampling #(parameter  prescale_width = 6,
                                  edge_cnt_width = 6 )
(
input wire                      CLK,RST,RX_IN,data_samp_en,
input wire [prescale_width-1:0] prescale,
input wire [edge_cnt_width-1:0] edge_cnt,
output reg                      sampled_bit
);

reg first_sample;
reg sec_sample;
reg third_sample;
 

always @(posedge CLK or negedge RST)
 begin
    if(!RST)
	 sampled_bit<='b0;
	
	else if(data_samp_en)
	begin
     if(((prescale/2)-1) == edge_cnt)  first_sample<=RX_IN;
     else if((prescale/2) == edge_cnt )  sec_sample<=RX_IN;
     else if(((prescale/2)+1) == edge_cnt)  begin third_sample<=RX_IN; sampled_bit<= (first_sample & sec_sample)|(sec_sample & third_sample)|(first_sample & third_sample); end
     else sampled_bit<=sampled_bit;
	end
	else
	 sampled_bit<='b0;
	
 end
 


  /*
  
  reg sampling;
reg [1:0] counts;
  
always @(*)
 begin
    if(((prescale/2)-1) == edge_cnt)
     begin
	    sampling=RX_IN;
		if(sampling==0) counts='b01;
		else            counts='b00;
     end	 
	 
	else if((prescale/2) == edge_cnt)
     begin
	    sampling=RX_IN;
		if(sampling==0) counts=counts + 'b1;
     end

	else if(((prescale/2)+1) == edge_cnt)
     begin
	    sampling=RX_IN;
		if(sampling==0) counts=counts + 'b1;
     end	 
	 
 end
 */

 endmodule
 
