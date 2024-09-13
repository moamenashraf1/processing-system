module FIFO_MEM_CNTRL #(parameter data_width = 8 ,
                                  ptr_width = 4 ,
								  data_depth = 8)
(
input wire [data_width-1:0]     w_data,
input wire                      w_clk , w_rst_n , w_inc , w_full ,
input wire [ptr_width-2:0]      w_addr , r_addr ,
output wire [data_width-1:0]     r_data
);

reg [data_width-1:0] fifo_mem [data_depth-1:0] ;
reg [data_depth-1:0] i ;


always @(posedge w_clk or negedge w_rst_n)
 begin
    if(!w_rst_n)
	 begin
      for(i=0; i<data_depth; i=i+1)	 
        fifo_mem[i] <= 'b0;
     
	 end
    
	else if(w_inc && !w_full)
	 fifo_mem[w_addr] <= w_data ;
	 
 end
 

assign r_data = fifo_mem[r_addr] ;


endmodule