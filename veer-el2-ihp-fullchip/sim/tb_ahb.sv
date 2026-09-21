`timescale 1ns/1ps
module tb_ahb;
 logic clk=0,rst_n=0;logic [31:0] haddr=0;logic [1:0] htrans=0;
 logic hwrite=0;logic [2:0] hsize=0;logic [63:0] hwdata=0,hrdata;
 logic hready,hresp;logic [7:0] gpio_out;
 always #5 clk=~clk;
 ahb_mem dut(.clk,.rst_n,.haddr,.htrans,.hwrite,.hsize,.hwdata,.hrdata,.hready,.hresp,.gpio_in(8'h3c),.gpio_out);
 task automatic xfer(input logic wr,input logic [31:0] addr,input logic [2:0] sz,
  input logic [63:0] data,input logic expect_error,output logic [63:0] result);
  @(negedge clk); haddr=addr;hsize=sz;hwrite=wr;htrans=2'b10;
  @(negedge clk); htrans=0;hwdata=data;
  if(expect_error) begin
   if(hready || !hresp) $fatal(1,"Missing first ERROR cycle");
   @(negedge clk);
   if(!hready || !hresp) $fatal(1,"Missing second ERROR cycle");
  end else if(!hready || hresp) $fatal(1,"Unexpected response addr=%h",addr);
  result=hrdata;
  @(negedge clk);
 endtask
 logic [63:0] r;
 initial begin
 repeat(3) @(negedge clk);rst_n=1;
 xfer(1,32'h10000000,3,64'h8877665544332211,0,r);
 xfer(0,32'h10000000,3,0,0,r);
 if(r!==64'h8877665544332211) $fatal(1,"64-bit RAM mismatch %h",r);
 xfer(1,32'h10000005,0,64'h0000aa0000000000,0,r);
 xfer(0,32'h10000000,3,0,0,r);
 if(r!==64'h8877aa5544332211) $fatal(1,"Byte lane corruption %h",r);
 xfer(1,32'h10000006,1,64'hbeef000000000000,0,r);
 xfer(0,32'h10000000,3,0,0,r);
 if(r!==64'hbeefaa5544332211) $fatal(1,"Halfword lane corruption %h",r);
 // Address/data overlap: two back-to-back writes, data belongs to previous address.
 @(negedge clk);haddr=32'h10000008;hsize=3;hwrite=1;htrans=2'b10;
 @(negedge clk);haddr=32'h10000010;htrans=2'b11;hwdata=64'h1122334455667788;
 @(negedge clk);htrans=0;hwdata=64'haabbccddeeff0099;
 @(negedge clk);
 xfer(0,32'h10000008,3,0,0,r);if(r!==64'h1122334455667788) $fatal(1,"Data phase #1");
 xfer(0,32'h10000010,3,0,0,r);if(r!==64'haabbccddeeff0099) $fatal(1,"Data phase #2");
 xfer(1,32'h20000000,2,64'ha5,0,r);
 if(gpio_out!==8'ha5) $fatal(1,"GPIO write failed");
 xfer(0,32'h20000004,2,0,0,r);
 if(r[39:32]!==8'h3c) $fatal(1,"GPIO input read failed");
 xfer(0,32'h30000000,2,0,1,r);
 xfer(1,32'h00000000,2,0,1,r);
 xfer(0,32'h10000003,2,0,1,r);
 xfer(0,32'h00000000,3,0,0,r);
 if(r[31:0]!==32'h100000b7) $fatal(1,"ROM/recovery failed");
 $display("PASS: AHB 64-bit, byte/halfword, pipelining, GPIO, 2-cycle ERROR and recovery");$finish;
 end
endmodule
