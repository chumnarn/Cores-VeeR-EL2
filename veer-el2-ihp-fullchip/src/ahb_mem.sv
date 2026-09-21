// SPDX-License-Identifier: Apache-2.0
// 64-bit AHB-Lite slave: address/control captured only when HREADY is high.
// ROM 0x00000000..FF, RAM 0x10000000..FF, GPIO 0x20000000..07.
// RAM intentionally has no reset; software must initialize before reading.
module ahb_mem #(parameter bit INSTRUCTION=0)(
 input logic clk,rst_n,input logic [31:0] haddr,
 input logic [1:0] htrans,input logic hwrite,input logic [2:0] hsize,
 input logic [63:0] hwdata,output logic [63:0] hrdata,
 output logic hready,hresp,input logic [7:0] gpio_in,output logic [7:0] gpio_out);
 `include "boot_rom.vh"
 logic valid_q,write_q,error_second;
 logic [31:0] addr_q;
 logic [2:0] size_q;
 logic [7:0] ram[0:255];
 logic rom_sel,ram_sel,gpio_sel,bad;
 always_comb begin
  rom_sel=(addr_q[31:8]==24'h000000);
  ram_sel=(!INSTRUCTION && addr_q[31:8]==24'h100000);
  gpio_sel=(!INSTRUCTION && addr_q[31:3]==29'h04000000);
  bad=valid_q && (!(rom_sel||ram_sel||gpio_sel) || (rom_sel&&write_q) ||
       size_q>3 || ((addr_q & ((32'd1<<size_q)-1))!=0));
  hresp=bad;
  hready=!bad || error_second;
  hrdata=0;
  if(rom_sel) hrdata={rom_word({addr_q[7:3],1'b1}),rom_word({addr_q[7:3],1'b0})};
  if(ram_sel) for(int i=0;i<8;i++) hrdata[8*i+:8]=ram[int'({addr_q[7:3],3'b000})+i];
  if(gpio_sel) hrdata={24'b0,gpio_in,24'b0,gpio_out};
 end
 always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
   valid_q<=0;write_q<=0;addr_q<=0;size_q<=0;error_second<=0;gpio_out<=0;
  end else begin
   error_second <= bad && !error_second;
   if(hready) begin
    valid_q<=htrans[1];write_q<=hwrite;addr_q<=haddr;size_q<=hsize;
   end
   if(valid_q && write_q && hready && !bad && gpio_sel && addr_q[2:0]==0)
    gpio_out<=hwdata[7:0];
  end
 end
 always_ff @(posedge clk) begin
  if(rst_n && valid_q && write_q && hready && !bad && ram_sel)
   for(int i=0;i<8;i++)
    if(i>=int'(addr_q[2:0]) && i<int'(addr_q[2:0])+(1<<size_q))
     ram[int'({addr_q[7:3],3'b000})+i]<=hwdata[8*i+:8];
 end
endmodule
