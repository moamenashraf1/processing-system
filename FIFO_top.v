module FIFO_top #(parameter data_width = 8,
                                  ptr_width = 4,
								  num_stages = 2 ,
                                  data_depth = 8)
								  
(
input  wire                   w_clk , w_rst , w_inc , r_clk , r_rst , r_inc, 
input  wire [data_width-1:0]  w_data,
output wire [data_width-1:0]  r_data,
output wire                   w_full , r_empty 
);						

//************internal wires **********************//
wire [ptr_width-2:0] w_addr , r_addr ; 
wire [ptr_width-1:0] rptr , wptr , wq2_rptr , rq2_wptr ;	  



FIFO_MEM_CNTRL #(.ptr_width(ptr_width) , .data_width(data_width) , .data_depth(data_depth)) u0_FIFO_MEM_CNTRL (
.w_clk(w_clk),
.w_rst_n(w_rst),
.w_inc(w_inc),
.w_data(w_data),
.r_data(r_data),
.w_full(w_full),
.w_addr(w_addr),
.r_addr(r_addr)
);


FIFO_wptr #(.ptr_width(ptr_width)) u0_FIFO_wptr (
.w_clk(w_clk),
.w_rst_n(w_rst),
.w_inc(w_inc),
.gray_w_ptr(wptr),
.w_full(w_full),
.w_addr(w_addr),
.sync_r_ptr(wq2_rptr)
);

FIFO_rptr #(.ptr_width(ptr_width)) u0_FIFO_rptr (
.r_clk(r_clk),
.r_rst_n(r_rst),
.r_empty(r_empty),
.r_inc(r_inc),
.r_addr(r_addr),
.gray_r_ptr(rptr),
.sync_w_ptr(rq2_wptr)
);


FIFO_DF_SYNC #(.num_stages(num_stages) , .ptr_width(ptr_width)) u0_DF_SYNC (
.clk(w_clk),
.rst(w_rst),
.async_gray_ptr(rptr),
.sync_gray_ptr(wq2_rptr)
);

FIFO_DF_SYNC #(.num_stages(num_stages) , .ptr_width(ptr_width)) u1_DF_SYNC (
.clk(r_clk),
.rst(r_rst),
.async_gray_ptr(wptr),
.sync_gray_ptr(rq2_wptr)
);
endmodule