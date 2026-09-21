// SPDX-License-Identifier: Apache-2.0
// IHP template pad API; explicit instance names avoid escaped array-name ambiguity.
`default_nettype none
module chip_top(
`ifdef USE_POWER_PINS
 inout wire VDD,VSS,IOVDD,IOVSS,
`endif
 inout wire clk_PAD,rst_n_PAD,inout wire [7:0] input_PAD,output_PAD);
 wire clk,rst_n;wire [7:0] input_in,output_out;
 (* keep *) sg13g2_IOPadVdd vdd_pad(
`ifdef USE_POWER_PINS
 .vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadVss vss_pad(
`ifdef USE_POWER_PINS
 .vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIOVdd iovdd_pad(
`ifdef USE_POWER_PINS
 .vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIOVss iovss_pad(
`ifdef USE_POWER_PINS
 .vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn clk_pad(.pad(clk_PAD),.p2c(clk)
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn rst_n_pad(.pad(rst_n_PAD),.p2c(rst_n)
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn in0_pad(.pad(input_PAD[0]),.p2c(input_in[0])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn in1_pad(.pad(input_PAD[1]),.p2c(input_in[1])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn in2_pad(.pad(input_PAD[2]),.p2c(input_in[2])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn in3_pad(.pad(input_PAD[3]),.p2c(input_in[3])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn in4_pad(.pad(input_PAD[4]),.p2c(input_in[4])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn in5_pad(.pad(input_PAD[5]),.p2c(input_in[5])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn in6_pad(.pad(input_PAD[6]),.p2c(input_in[6])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadIn in7_pad(.pad(input_PAD[7]),.p2c(input_in[7])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadOut30mA out0_pad(.pad(output_PAD[0]),.c2p(output_out[0])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadOut30mA out1_pad(.pad(output_PAD[1]),.c2p(output_out[1])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadOut30mA out2_pad(.pad(output_PAD[2]),.c2p(output_out[2])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadOut30mA out3_pad(.pad(output_PAD[3]),.c2p(output_out[3])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadOut30mA out4_pad(.pad(output_PAD[4]),.c2p(output_out[4])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadOut30mA out5_pad(.pad(output_PAD[5]),.c2p(output_out[5])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadOut30mA out6_pad(.pad(output_PAD[6]),.c2p(output_out[6])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 (* keep *) sg13g2_IOPadOut30mA out7_pad(.pad(output_PAD[7]),.c2p(output_out[7])
`ifdef USE_POWER_PINS
 ,.vdd(VDD),.vss(VSS),.iovdd(IOVDD),.iovss(IOVSS)
`endif
);
 chip_core i_chip_core(.clk,.rst_n,.input_in,.output_out);
endmodule
`default_nettype wire
