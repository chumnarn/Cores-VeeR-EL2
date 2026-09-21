`timescale 1ns/1ps
module tb_soc;
 logic clk=0,rst_n=0; logic [7:0] gpio;logic tv,te;logic [31:0] pc;
 always #10 clk=~clk;
 el2_soc dut(.clk,.rst_n,.gpio_in(8'h3c),.gpio_out(gpio),.trace_valid(tv),.trace_exception(te),.trace_pc(pc));
 integer retired=0; bit passed=0;
 always @(posedge clk) if(rst_n && tv) begin
 retired<=retired+1;
 if(te) $fatal(1,"Unexpected exception at %h",pc);
 end
 initial begin
 repeat(8) @(negedge clk);rst_n=1;
 repeat(20000) begin
 @(negedge clk);
 if(gpio==8'hee) $fatal(1,"Firmware RAM/lane test failed");
 if(gpio==8'ha5) begin
 if(retired<10) $fatal(1,"Not enough retired instructions");
 $display("PASS: EL2 boot, RAM word/byte/halfword, GPIO A5; retired=%0d pc=%h",retired,pc);
 passed=1; break;
 end
 end
 if(!passed) $fatal(1,"Boot timeout pc=%h gpio=%h",pc,gpio);
 $finish;
 end
endmodule
