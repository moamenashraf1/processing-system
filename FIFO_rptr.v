module FIFO_rptr #( parameter ptr_width = 4 )
(
input wire                  r_inc , r_clk , r_rst_n , 
input wire [ptr_width-1:0]  sync_w_ptr , 
output wire                  r_empty , 
output wire [ptr_width-2:0]  r_addr ,
output reg [ptr_width-1:0]  gray_r_ptr 
);	

reg [ptr_width-1:0] r_ptr;

always @(posedge r_clk or negedge r_rst_n)
 begin
    if(!r_rst_n)
	 r_ptr <= 'b0;
 
    else if(r_inc && !r_empty)
	 r_ptr <= r_ptr + 'b1;
	 
 end


always @(posedge r_clk or negedge r_rst_n)
 begin
    if(!r_rst_n)   
      gray_r_ptr <= 'b0;
 
    else
     begin
      case (r_ptr)
      'b0000: gray_r_ptr <= 'b0000 ;
      'b0001: gray_r_ptr <= 'b0001 ;
      'b0010: gray_r_ptr <= 'b0011 ;
      'b0011: gray_r_ptr <= 'b0010 ;
      'b0100: gray_r_ptr <= 'b0110 ;
      'b0101: gray_r_ptr <= 'b0111 ;
      'b0110: gray_r_ptr <= 'b0101 ;
      'b0111: gray_r_ptr <= 'b0100 ;
      'b1000: gray_r_ptr <= 'b1100 ;
      'b1001: gray_r_ptr <= 'b1101 ;
      'b1010: gray_r_ptr <= 'b1111 ;
      'b1011: gray_r_ptr <= 'b1110 ;
      'b1100: gray_r_ptr <= 'b1010 ;
      'b1101: gray_r_ptr <= 'b1011 ;
      'b1110: gray_r_ptr <= 'b1001 ;
      'b1111: gray_r_ptr <= 'b1000 ;
      endcase
    end	
 end
 
 
 assign r_addr = r_ptr[ptr_width-2:0];
 assign r_empty = (sync_w_ptr == gray_r_ptr) ;
 
 endmodule
 