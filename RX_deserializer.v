module RX_deserializer #(parameter data_width = 8,
                                bit_cnt_width = 4,
								prescale_width = 6) 
(
input wire                      sampled_bit,deser_en,CLK,RST,data_valid,
input wire [bit_cnt_width-1:0]  bit_cnt,
input wire   [5:0]              edge_count,
input wire [prescale_width-1:0]  prescale, 
output reg  [data_width-1:0]    P_DATA
);



always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    P_DATA <= 'b0 ;
   end
  else if(deser_en && edge_count == (prescale - 6'b1))
   begin
    P_DATA <= {sampled_bit,P_DATA[7:1]}	;
   end	
 end
 

/*
always @ (*) begin
	if (deser_en) 
 	  begin
		case (bit_cnt)
		4'b0001 : begin deser_data[0] = sampled_bit ;  end
		4'b0010 : begin deser_data[1] = sampled_bit ;  end
		4'b0011 : begin deser_data[2] = sampled_bit ;  end
		4'b0100 : begin deser_data[3] = sampled_bit ;  end
		4'b0101 : begin deser_data[4] = sampled_bit ;  end
		4'b0110 : begin deser_data[5] = sampled_bit ;  end
		4'b0111 : begin deser_data[6] = sampled_bit ;  end
		4'b1000 : begin deser_data[7] = sampled_bit ; data=deser_data;  end
		endcase
	  end
	else
	 begin
	    data = 'b0;
	 
	 end
end
*/











/*
always @(*)
 begin
    if(deser_en)
     begin
      deser_data[7]=sampled_bit;
	  if(bit_cnt != 'b1000)
       deser_data = deser_data << 1;
     else if(bit_cnt=='b1000)
	   data=deser_data;
	 
	 end 
	 
	 
 end

*/
endmodule