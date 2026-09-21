// SPDX-License-Identifier: Apache-2.0
module chip_core(input logic clk,rst_n,input logic [7:0] input_in,
 output logic [7:0] output_out);
 (* async_reg="true" *) logic [1:0] reset_sync;
 (* async_reg="true" *) logic [7:0] gpio_meta,gpio_sync;
 always_ff @(posedge clk or negedge rst_n)
  if(!rst_n) reset_sync<=0; else reset_sync<={reset_sync[0],1'b1};
 always_ff @(posedge clk or negedge reset_sync[1])
  if(!reset_sync[1]) begin gpio_meta<=0;gpio_sync<=0;end
  else begin gpio_meta<=input_in;gpio_sync<=gpio_meta;end
 el2_soc u_soc(.clk,.rst_n(reset_sync[1]),.gpio_in(gpio_sync),.gpio_out(output_out),
 .trace_valid(),.trace_exception(),.trace_pc());
endmodule
