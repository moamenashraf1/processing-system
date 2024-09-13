module SYS_TOP #(parameter DATA_WIDTH = 8,
                           address_width = 4)
(
input  wire REF_CLK,
input  wire UART_CLK,
input  wire RST,
input  wire UART_RX_IN,
output wire UART_TX_OUT,
output wire PARITY_ERROR , FRAM_ERROR 
);


wire SYNC_UART_RST , SYNC_REF_RST ;
 
wire [DATA_WIDTH-1:0] UART_RX_OUT ;
wire                  UART_RX_OUT_VALID; 
wire                  UART_TX_BUSY;
wire                  TX_CLK, RX_CLK ;
wire [DATA_WIDTH-1:0] UART_CONFIG;

wire [DATA_WIDTH-1:0] DATA_RX_SYNC;
wire                  DATA_RX_SYNC_VALID;

wire                  FIFO_FULL;
wire [DATA_WIDTH-1:0] WR_DATA;          //sys_ctrl -> fifo
wire                  WR_INC;
wire                  RD_INC;
wire                  F_EMPTY;
wire [DATA_WIDTH-1:0] RD_DATA;

wire                     WR_EN, RD_EN, RD_D_VALID; 
wire [address_width-1:0] ADDR;
wire [DATA_WIDTH-1:0]    WR_D , RD_D , OP_A , OP_B; 
wire [3:0]               FUNC;
wire                     EN, ALU_OUT_VALID;
wire [DATA_WIDTH*2-1:0]  ALU_OUT;
wire                     ALU_CLK ;
wire                     GATE_EN;
wire  [7:0]              DIV_RATIO;  
               

wire[DATA_WIDTH-1:0]     DIV_RATIO_RX;

UART #(.DATA_WIDTH(DATA_WIDTH)) u0_UART (
.TX_CLK(TX_CLK),
.RX_CLK(RX_CLK),
.RST(SYNC_UART_RST),
.RX_IN(UART_RX_IN),
.TX_DATA(RD_DATA),
.TX_VALID(!F_EMPTY),
.TX_BUSY(UART_TX_BUSY),
.PRESCALE(UART_CONFIG[7:2]),
.PARITY_EN(UART_CONFIG[0]),
.PARITY_TYPE(UART_CONFIG[1]),
.TX_OUT(UART_TX_OUT),
.RX_DATA(UART_RX_OUT),
.RX_VALID(UART_RX_OUT_VALID),
.PARITY_ERROR(PARITY_ERROR),
.FRAM_ERROR(FRAM_ERROR)
);


FIFO_top #(.data_width(DATA_WIDTH), .ptr_width(4) , .num_stages(2), .data_depth(8) ) u0_FIFO_top (
.w_clk(REF_CLK),
.w_rst(SYNC_UART_RST),
.w_inc(WR_INC),
.r_clk(RX_CLK),
.r_rst(SYNC_UART_RST),
.r_inc(RD_INC),
.w_data(WR_DATA),
.r_data(RD_DATA),
.w_full(FIFO_FULL),
.r_empty(F_EMPTY)
);


DATA_SYNC #(.num_stages(2), .bus_width(8)) u0_DATA_SYNC (
.clk(REF_CLK),
.rst(SYNC_REF_RST),
.bus_enable(UART_RX_OUT_VALID),
.unsync_bus(UART_RX_OUT),
.sync_bus(DATA_RX_SYNC),
.enable_pulse(DATA_RX_SYNC_VALID)
);

ALU #(.width(DATA_WIDTH), .out_width(16)) u0_ALU (
.A(OP_A),
.B(OP_B),
.CLK(ALU_CLK),
.RST(SYNC_REF_RST),
.ALU_FUN(FUNC),
.ENABLE(EN),
.ALU_OUT(ALU_OUT),
.OUT_VALID(ALU_OUT_VALID)
);


Reg_File #(.address_width(4), .width(DATA_WIDTH), .depth(16)) u0_Reg_File (
.CLK(REF_CLK),
.RST(SYNC_REF_RST),
. WrData(WR_D),
.Address(ADDR),
.WrEn(WR_EN),
.RdEn(RD_EN),
.RdData(RD_D),
.RdData_Valid(RD_D_VALID),
.REG0(OP_A),
.REG1(OP_B),
.REG2(UART_CONFIG),
.REG3(DIV_RATIO)
);


SYS_CTRL #(.DATA_WIDTH(DATA_WIDTH), .ALU_OUT_WIDTH(16), .state_width(4), .address_width(4)) u0_SYS_CTRL (
.CLK(REF_CLK),
.RST(SYNC_REF_RST),
.SYNC_RX_DATA(DATA_RX_SYNC),
.enable(DATA_RX_SYNC_VALID),
.FIFO_FULL(FIFO_FULL),
.WR_DATA(WR_DATA),
.WR_INC(WR_INC),
.RD_DATA_VALID(RD_D_VALID),
.RD_DATA(RD_D),
.WR_EN(WR_EN),
.RD_EN(RD_EN),
.ADDR(ADDR),
.WR_D(WR_D),
.GATE_EN(GATE_EN),
.ALU_OUT(ALU_OUT),
.ALU_VALID(ALU_OUT_VALID),
.ALU_FUNC(FUNC),
.ALU_EN(EN)
);


PULSE_GEN u0_PULSE_GEN (
.clk(TX_CLK),
.rst(SYNC_UART_RST),
.IN(UART_TX_BUSY),
.OUT(RD_INC)
);



RST_SYNC #(.num_stages(2)) u0_RST_SYNC (
.clk(REF_CLK),
.rst(RST),
.sync_rst(SYNC_REF_RST)
);

RST_SYNC #(.num_stages(2)) u1_RST_SYNC (
.clk(UART_CLK),
.rst(RST),
.sync_rst(SYNC_UART_RST)
);


CLK_DIV #(.div_ratio_width(8)) u0_CLK_DIV (
.i_ref_clk(UART_CLK),
.i_rst_n(SYNC_UART_RST),
.i_clk_en(1'b1),
.i_div_ratio(DIV_RATIO),
.o_div_clk(TX_CLK)
);

CLKDIV_MUX #(.WIDTH(8)) u0_CLKDIV_MUX(
.IN(UART_CONFIG[7:2]),
.OUT(DIV_RATIO_RX)
);


CLK_DIV #(.div_ratio_width(8)) u1_CLK_DIV (
.i_ref_clk(UART_CLK),
.i_rst_n(SYNC_REF_RST),
.i_clk_en(1'b1),
.i_div_ratio(DIV_RATIO_RX),
.o_div_clk(RX_CLK)
);


CLK_GATE u0_CLK_GATE (
.CLK(REF_CLK),
.CLK_EN(GATE_EN),
.GATED_CLK(ALU_CLK)
);


endmodule
