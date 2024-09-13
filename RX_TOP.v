module RX_TOP #(parameter prescale_width = 6,
                               bit_cnt_width = 4, 
							   edge_cnt_width = 6,
							   data_width = 8 ,
							   state_width =   3 )

(
input wire CLK,RST,RX_IN,PAR_EN,PAR_TYP,
input wire [prescale_width-1:0] prescale,
output wire data_valid, par_err , stp_err ,
output wire [data_width-1:0] P_DATA
);

//**************internal wires****************//

wire sampled_bit;
wire deser_en;
wire stp_chk_en ;
wire strt_glitch;
wire strt_chk_en;
wire par_chk_en;
wire enable;
wire [bit_cnt_width-1:0]bit_cnt;
wire [edge_cnt_width-1:0] edge_cnt;
wire data_samp_en; 

//////////////////////////////////////////


RX_data_sampling #(.prescale_width(prescale_width) , .edge_cnt_width(edge_cnt_width)) u0_data_sampling (
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.data_samp_en(data_samp_en),
.prescale(prescale),
.edge_cnt(edge_cnt),
.sampled_bit(sampled_bit)
);

RX_FSM #(.edge_cnt_width(edge_cnt_width), .bit_cnt_width(bit_cnt_width) , .state_width(state_width)) u0_FSM (
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.PAR_EN(PAR_EN),
.PAR_ERR(par_err),
.strt_glitch(strt_glitch),
.STP_ERR(stp_err),
.edge_cnt(edge_cnt),
.bit_cnt(bit_cnt),
.data_valid(data_valid),
.deser_en(deser_en),
.stp_chk_en(stp_chk_en),
.strt_chk_en(strt_chk_en),
.par_chk_en(par_chk_en),
.enable(enable),
.data_samp_en(data_samp_en),
.prescale(prescale)

);

RX_counter #(.prescale_width(prescale_width), .bit_cnt_width(bit_cnt_width) , .edge_cnt_width(edge_cnt_width)) u0_counter(
.CLK(CLK),
.RST(RST),
.enable(enable),
.prescale(prescale),
.edge_cnt(edge_cnt),
.bit_cnt(bit_cnt)

);

RX_deserializer #(.data_width(data_width), .prescale_width(6) , .bit_cnt_width(bit_cnt_width)) u0_deserializer(
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.deser_en(deser_en),
.data_valid(data_valid),
.P_DATA(P_DATA),
.bit_cnt(bit_cnt),
.edge_count(edge_cnt),
.prescale(prescale)
);

RX_start_check #(.edge_cnt_width(edge_cnt_width) , .prescale_width(prescale_width)) u0_start_check(
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.strt_chk_en(strt_chk_en),
.strt_glitch(strt_glitch),
.edge_cnt(edge_cnt),
.prescale(prescale)

);

RX_parity_check #(.data_width(data_width) , .edge_cnt_width(edge_cnt_width) , .prescale_width(prescale_width)) u0_parity_check(
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.PAR_TYP(PAR_TYP),
.par_chk_en(par_chk_en),
.par_err(par_err),
.data(P_DATA),
.edge_cnt(edge_cnt),
.prescale(prescale)
);


RX_stop_check #(.edge_cnt_width(edge_cnt_width), .prescale_width(prescale_width)) u0_stop_check(
.CLK(CLK),
.RST(RST),
.sampled_bit(sampled_bit),
.stp_chk_en(stp_chk_en),
.stp_err(stp_err),
.edge_cnt(edge_cnt),
.prescale(prescale)
);

endmodule
