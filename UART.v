module UART #(parameter DATA_WIDTH = 8)
(
input  wire                     RST,
input  wire                     TX_CLK,
input  wire                     RX_CLK,
input  wire                     RX_IN,
input  wire  [DATA_WIDTH-1:0]   TX_DATA,      //RD_DATA
input  wire                     TX_VALID,     //!F_EMPTY
input  wire  [5:0]              PRESCALE,
input  wire                     PARITY_EN,
input  wire                     PARITY_TYPE,
output wire                     TX_OUT, 
output wire                     TX_BUSY,
output wire  [DATA_WIDTH-1:0]   RX_DATA,       //input to data_sync
output wire                     RX_VALID,      //input to data_sync
output wire                     PARITY_ERROR,
output wire                     FRAM_ERROR    //stop error
);



TX_TOP #(.WIDTH(DATA_WIDTH)) u0_TX_TOp (
.CLK(TX_CLK),
.RST(RST),
.P_DATA(TX_DATA),
.DATA_VALID(TX_VALID),
.PAR_ENABLE(PARITY_EN),
.PAR_TYP(PARITY_TYPE),
.TX_OUT(TX_OUT),
.BUSY(TX_BUSY)
);

RX_TOP #(.data_width(DATA_WIDTH)) u0_RX_TOp (
.CLK(RX_CLK),
.RST(RST),
.RX_IN(RX_IN),
.prescale(PRESCALE),
.PAR_EN(PARITY_EN),
.PAR_TYP(PARITY_TYPE),
.P_DATA(RX_DATA),
.data_valid(RX_VALID),
.par_err(PARITY_ERROR),
.stp_err(FRAM_ERROR)
);

endmodule
