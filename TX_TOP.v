module TX_TOP #(parameter WIDTH = 8,
                               WIDTH_STATE = 3,
							   WIDTH_MUX = 2)
(
input wire [WIDTH-1:0] P_DATA,
input wire             DATA_VALID,PAR_TYP,PAR_ENABLE,CLK,RST,
output wire             TX_OUT,BUSY
);

//internal wires
wire               SER_DONE;
wire               SER_ENABLE;
wire               SER_DATA;
wire [WIDTH_MUX-1:0]   MUX_SEL;
wire               PAR_BIT;
////////////////

TX_serializer #(.WIDTH(WIDTH)) u0_TX_serializer ( 
.CLK(CLK),
.RST(RST),
.P_DATA(P_DATA),
.DATA_VALID(DATA_VALID),
.SER_DONE(SER_DONE),
.SER_ENABLE(SER_ENABLE),
.SER_DATA(SER_DATA),
.BUSY(BUSY)
);

TX_FSM #(.WIDTH_STATE(WIDTH_STATE),.WIDTH_MUX(WIDTH_MUX)) u0_TX_fsm (
.CLK(CLK),
.RST(RST),
.SER_DONE(SER_DONE),
.DATA_VALID(DATA_VALID),
.SER_ENABLE(SER_ENABLE),
.MUX_SEL(MUX_SEL),
.BUSY(BUSY),
.PAR_ENABLE(PAR_ENABLE)
);

TX_parity_calc  #(.WIDTH(WIDTH)) u0_TX_parity_calc (
.CLK(CLK),
.RST(RST),
.DATA_VALID(DATA_VALID),
.P_DATA(P_DATA),
.PAR_TYP(PAR_TYP),
.PAR_BIT(PAR_BIT),
.PAR_ENABLE(PAR_ENABLE),
.BUSY(BUSY)
);

TX_MUX  #(.WIDTH_MUX(WIDTH_MUX)) u0_TX_mux (
.CLK(CLK),
.RST(RST),
.MUX_SEL(MUX_SEL),
.START_BIT(1'b0),
.STOP_BIT(1'b1),
.SER_DATA(SER_DATA),
.PAR_BIT(PAR_BIT),
.TX_OUT(TX_OUT)
);
endmodule