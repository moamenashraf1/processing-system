module RST_SYNC #(parameter num_stages = 2)
(
input wire rst,clk,
output wire sync_rst
);

reg [num_stages-1:0] sync_reg;
integer i;

always @(posedge clk or negedge rst)
 begin
    if(!rst)
	 sync_reg <= 'b0;
 
    else
	 begin
	    sync_reg[0] <= 'b1;
        for(i=1; i<num_stages; i=i+1)
          sync_reg[i] <= sync_reg[i-1];
	 end
 end
 
 
 assign sync_rst = sync_reg[num_stages-1];
 
 endmodule