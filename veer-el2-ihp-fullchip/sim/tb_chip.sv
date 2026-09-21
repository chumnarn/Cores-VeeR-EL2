`timescale 1ns/1ps
module tb_chip;
 reg clk=0,rst_n=0;wire [7:0] gpio;wire [7:0] inp=8'h3c;
 supply1 VDD,IOVDD; supply0 VSS,IOVSS;
 always #10 clk=~clk;
 chip_top dut(.clk_PAD(clk),.rst_n_PAD(rst_n),.input_PAD(inp),.output_PAD(gpio)
`ifdef USE_POWER_PINS
 ,.VDD,.VSS,.IOVDD,.IOVSS
`endif
 );
 bit passed=0;
 initial begin
 repeat(8) @(negedge clk);rst_n=1;
 repeat(20000) begin
 @(negedge clk);
 if(gpio==8'hee) $fatal(1,"Firmware failure at pads");
 if(gpio==8'ha5) begin passed=1;break;end
 end
 if(!passed) $fatal(1,"Pad boot timeout: %h",gpio);
 $display("PASS: chip_top with IHP functional IO models and power ports, GPIO=A5");
 $finish;
 end
endmodule
