`timescale 1us/1fs

module SYS_TOP_TB();

/***************parameters***************/
parameter DATA_WIDTH = 8;
parameter REF_CLK_PERIOD = 0.02 ; // 50M hz
parameter UART_CLK_PERIOD= 0.2712; // 3.6864M hz
parameter UART_TX_PERIOD = 32*0.2712;

/******************DUT signals*****************/
reg  RST_TB, REF_CLK_TB, UART_CLK_TB, UART_RX_IN_TB;
wire UART_TX_OUT_TB, PARITY_ERROR_TB, FRAM_ERROR_TB;


/***************instantiation*********************/
SYS_TOP DUT (
.RST(RST_TB),
.REF_CLK(REF_CLK_TB),
.UART_CLK(UART_CLK_TB),
.UART_RX_IN(UART_RX_IN_TB),
.UART_TX_OUT(UART_TX_OUT_TB),
.PARITY_ERROR(PARITY_ERROR_TB),
.FRAM_ERROR(FRAM_ERROR_TB)
);


initial 
 begin
    initialization();
    rst();
	
	#5;
	
	WR_REG('b10101010,'b00001100,'b11110000);
	#(UART_TX_PERIOD);
	
	RD_REG('b10111011,'b00001100);
	#(UART_TX_PERIOD);
	
    ALU_OP_OP('b11001100,'b00000101,'b00000110,'b00000010);
 	#(UART_TX_PERIOD);
	
	ALU_OP('b11011101,'b00000000);
	#(UART_TX_PERIOD);
	
	#100;
	$stop;
 
 end
 

/******************clk generation*********************/
always #(REF_CLK_PERIOD/2) REF_CLK_TB = !REF_CLK_TB;
always #(UART_CLK_PERIOD/2) UART_CLK_TB = !UART_CLK_TB;

////////////////////////////////////////////////////
/********************tasks*************************/
////////////////////////////////////////////////////

/**************initialization*********************/
task initialization;
 begin
    REF_CLK_TB = 'b0;
    UART_CLK_TB= 'b0;
	RST_TB = 'b1;
	UART_RX_IN_TB = 'b1;
 end
endtask
/*******************reset*****************************/
task rst;
 begin
    #(UART_CLK_PERIOD);
	RST_TB = 'b0;
	#(UART_CLK_PERIOD);
	RST_TB = 'b1;
	#(UART_CLK_PERIOD);
 
 end
endtask



//////////////////////////////////////////////////////////
/************************WR_DATA_REG********************/
//////////////////////////////////////////////////////////
task WR_REG;
input [DATA_WIDTH-1:0] command;
input [DATA_WIDTH-1:0] address;
input [DATA_WIDTH-1:0] in_data;

integer i; 
 begin
    @(negedge UART_CLK_TB)
     UART_RX_IN_TB = 'b0;      //start bit
	#(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=command[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);

    #(2*UART_TX_PERIOD);

//*********************************

 @(negedge UART_CLK_TB)
	 UART_RX_IN_TB = 'b0;      //start bit
	 #(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=address[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);

  //*********************************
    #(2*UART_TX_PERIOD);
  
     @(negedge UART_CLK_TB)
	 UART_RX_IN_TB = 'b0;      //start bit
	 #(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=in_data[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);
    
 end
endtask


//////////////////////////////////////////////////////////
/************************RD_DATA_REG********************/
//////////////////////////////////////////////////////////
task RD_REG;
input [DATA_WIDTH-1:0] command;
input [DATA_WIDTH-1:0] address;

integer i; 
 begin
    @(negedge UART_CLK_TB)
     UART_RX_IN_TB = 'b0;      //start bit
	#(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=command[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);

    #(2*UART_TX_PERIOD);

//**************************************

 @(negedge UART_CLK_TB)
	 UART_RX_IN_TB = 'b0;      //start bit
	 #(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=address[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);


 end
endtask
//////////////////////////////////////////////////////////////
/************************ALU_OP_OP********************///
//////////////////////////////////////////////////////////////
task ALU_OP_OP;
input [DATA_WIDTH-1:0] command;
input [DATA_WIDTH-1:0] A;
input [DATA_WIDTH-1:0] B;
input [DATA_WIDTH-1:0] func;

integer i; 
 begin
    @(negedge UART_CLK_TB)
     UART_RX_IN_TB = 'b0;      //start bit
	#(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=command[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);

    #(2*UART_TX_PERIOD);

//************************************

 @(negedge UART_CLK_TB)
	 UART_RX_IN_TB = 'b0;      //start bit
	 #(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=A[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);

  //******************************
    #(2*UART_TX_PERIOD);
  
     @(negedge UART_CLK_TB)
	 UART_RX_IN_TB = 'b0;      //start bit
	 #(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=B[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);
    
	//******************************
	 #(2*UART_TX_PERIOD);
  
     @(negedge UART_CLK_TB)
	 UART_RX_IN_TB = 'b0;      //start bit
	 #(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=func[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b1;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);
 end
endtask


//////////////////////////////////////////////////////////
/************************ALU_OP********************/
//////////////////////////////////////////////////////////
task ALU_OP;
input [DATA_WIDTH-1:0] command;
input [DATA_WIDTH-1:0] func;


integer i; 
 begin
    @(negedge UART_CLK_TB)
     UART_RX_IN_TB = 'b0;      //start bit
	#(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=command[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);

    #(2*UART_TX_PERIOD);
	
	@(negedge UART_CLK_TB)
     UART_RX_IN_TB = 'b0;      //start bit
	#(UART_TX_PERIOD); 
 
    for(i=0;i<8;i=i+1)
     begin
	  @(negedge UART_CLK_TB)
	    UART_RX_IN_TB=func[i];
        #(UART_TX_PERIOD);	    
	 end
	 @(negedge UART_CLK_TB)
	UART_RX_IN_TB = 'b0;   //parity bit
    #(UART_TX_PERIOD);
	
	 @(negedge UART_CLK_TB)
    UART_RX_IN_TB = 'b1;   //stop bit	
    #(UART_TX_PERIOD);

    #(2*UART_TX_PERIOD);
 end
endtask
endmodule
