module CLK_DIV #(parameter div_ratio_width = 8)
(
input wire i_ref_clk , i_rst_n , i_clk_en,
input wire [div_ratio_width-1:0] i_div_ratio,
output wire o_div_clk 
);

wire ODD , CLK_DIV_EN ;
reg  flag ;
reg div_clk ;
reg [4:0] counter;


always @(posedge i_ref_clk or negedge i_rst_n)
 begin
    if(!i_rst_n) 
	 begin
	    div_clk <= 'b0;
        counter <= 'b0;
		flag <= 'b1;
     end
	 
    else if(CLK_DIV_EN)
	 begin
        if((counter == ((i_div_ratio >> 1)-1)) && !ODD ) 
	     begin
		    div_clk <= ~div_clk;
			counter <= 'b0;
		 end
		else if (((counter == ((i_div_ratio >> 1)-1)) && flag && ODD)  || ((counter == (i_div_ratio >> 1)) && !flag && ODD ))
		 begin
		    div_clk <= !div_clk;
			counter <= 'b0;
			flag <= !flag;
		 end
		else
		 begin	
		   div_clk <= div_clk;
	       counter <= counter + 'b1;	   
		 end
 	
	 end	 
	 
 end


assign o_div_clk = CLK_DIV_EN ? div_clk : i_ref_clk;

assign ODD  = (i_div_ratio[0] != 0 );
assign CLK_DIV_EN = i_clk_en && (i_div_ratio != 'b0) && (i_div_ratio != 'b1);


endmodule