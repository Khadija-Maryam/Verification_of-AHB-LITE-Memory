`include "Test1.sv"
`include "wrapper.sv"
`include "interface.sv"
module top;

 bit HCLK;
 bit HRESETn;

 initial begin
  forever #10 HCLK = ~HCLK;

  #1 HRESETn = 0;
  #5 HRESETn = 1;
    //#3000;
    //$stop; // to stop simulation at 3000 ns
 end

 Interface intf(HCLK, HRESETn);
 wrapper wrap(intf.DUT);
 test t0(intf.TEST);

// to dump a file, needed for waveform and sometimes for gtkwave
initial begin
 	$dumpfile("dump.vcd");
 	$dumpvars;
end

endmodule
