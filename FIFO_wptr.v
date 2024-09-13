module FIFO_wptr #( parameter ptr_width = 4 )							  
(
input wire                  w_clk , w_rst_n , w_inc ,
input wire [ptr_width-1:0]  sync_r_ptr ,
output wire                 w_full ,
output reg [ptr_width-1:0]  gray_w_ptr ,
output wire [ptr_width-2:0]  w_addr 
);

reg [ptr_width-1:0] w_ptr;


always @(posedge w_clk or negedge w_rst_n)
 begin
    if(!w_rst_n)
	   w_ptr <= 'b0;
   
    else if(w_inc && !w_full)
	   w_ptr <= w_ptr + 'b1;
	 
 end


always @(posedge w_clk or negedge w_rst_n)
 begin
    if(!w_rst_n)
	 gray_w_ptr <= 'b0;
 
    else
	 begin
	    case(w_ptr)
		'b0000 : gray_w_ptr <= 'b0000;
	    'b0001 : gray_w_ptr <= 'b0001;
	    'b0010 : gray_w_ptr <= 'b0011;
	    'b0011 : gray_w_ptr <= 'b0010;
	    'b0100 : gray_w_ptr <= 'b0110;
		'b0101 : gray_w_ptr <= 'b0111;
		'b0110 : gray_w_ptr <= 'b0101;
		'b0111 : gray_w_ptr <= 'b0100;
		'b1000 : gray_w_ptr <= 'b1100;
		'b1001 : gray_w_ptr <= 'b1101;
		'b1010 : gray_w_ptr <= 'b1111;
		'b1011 : gray_w_ptr <= 'b1110;
		'b1100 : gray_w_ptr <= 'b1010;
		'b1101 : gray_w_ptr <= 'b1011;
		'b1110 : gray_w_ptr <= 'b1001;
		'b1111 : gray_w_ptr <= 'b1000;
		endcase
	 end
 
 end


assign w_addr = w_ptr[ptr_width-2:0] ;

assign w_full = (gray_w_ptr[ptr_width-1] != sync_r_ptr[ptr_width-1] && gray_w_ptr[ptr_width-2] != sync_r_ptr[ptr_width-2]  && gray_w_ptr[ptr_width-3:0] == sync_r_ptr[ptr_width-3:0] );


endmodule