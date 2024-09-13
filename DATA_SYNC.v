module DATA_SYNC #(parameter num_stages = 2,
                             bus_width = 8 )
(
input wire                  clk ,rst ,bus_enable ,
input wire [bus_width-1:0]  unsync_bus ,
output reg [bus_width-1:0]  sync_bus,
output reg                  enable_pulse
);


reg [num_stages-1:0] sync_reg;
integer i;
reg sync_pulse;
wire mux_sel;
wire [bus_width-1:0]  sync_bus_c;


//******************* multi flip flop ************************//
always @(posedge clk or negedge rst )
 begin
    if(!rst)
     sync_reg <= 'b0;	 
    
    else
	 begin
	    sync_reg[0] <= bus_enable;
		for(i=1; i<num_stages; i=i+1)
	     sync_reg[i] <= sync_reg[i-1];
	 
	 end
 end
 
//*******************pulse gen ***************************/
always @(posedge clk or negedge rst)
 begin
    if(!rst)
	 sync_pulse <= 'b0;
    else
     sync_pulse <= sync_reg[num_stages-1];
 end

assign mux_sel = (!sync_pulse && sync_reg[num_stages-1]);

//*****************enable pulse **************************//
always @(posedge clk or negedge rst)
 begin
    if(!rst)
	 enable_pulse <= 'b0;
    else
     enable_pulse <= mux_sel;
 end

//**********************  mux  ***********************//
assign sync_bus_c = mux_sel ? unsync_bus : sync_bus ;

//***********************sync_bus*****************//
always @(posedge clk or negedge rst)
 begin
    if(!rst)
	 sync_bus <= 'b0;
    else
     sync_bus <= sync_bus_c;
 end


endmodule