`timescale 1ns/1ps
module tb_gl;
 reg clk=0,rst_n=0; wire [7:0] gpio;wire [7:0] inp=8'h3c;
 supply1 VDD,IOVDD;supply0 VSS,IOVSS;
 always #10 clk=~clk;
 chip_top dut(.clk_PAD(clk),.rst_n_PAD(rst_n),.input_PAD(inp),.output_PAD(gpio),.VDD,.VSS,.IOVDD,.IOVSS);
 initial begin repeat(20) @(negedge clk);rst_n=1;end
 initial begin
 wait(rst_n);wait(gpio===8'ha5);
 $display("PASS: powered-netlist zero-delay GLS GPIO=A5");$finish;
 end
 always @(negedge clk) if(rst_n && gpio===8'hee) $fatal(1,"Firmware FAIL at GLS");
 initial begin #400000;$fatal(1,"GLS timeout");end
endmodule
