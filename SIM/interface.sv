//Interface groups the design signals, specifies the direction (Modport) and Synchronize the signals(Clocking Block)

//`include "design.sv"
interface Interface(input bit HCLK, HRESETn);

logic HWRITE; 		// Transfer direction
logic HREADY; 		// Transfer done
logic HREADYOUT; 	// slave ready status
logic HSEL;		// Slave select
logic HRESP;	        // Response from Slave
logic[31:0] HADDR;      // Address bus size 
logic[31:0] HWDATA;     // Write data bus
logic[31:0] HRDATA;     // Read data bus
logic[2:0]  HSIZE;	// Transfer size
logic[2:0]  HBURST;	// Burst type
logic[3:0]  HPROT;  	// Protection control
logic[1:0]  HTRANS; 	// Transfer type

//DUT Clocking block - For sampling by DUT
clocking cb_DUT@(posedge HCLK);
    default input #1 output #1;
    input    HSEL, HADDR, HWDATA, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HREADY;
    output   HRDATA, HREADYOUT, HRESP;
  endclocking
//Monitor Clocking block - For sampling by monitor components
clocking cb_MON @(posedge HCLK);
    default input #1 output #1;
    input HSEL, HRDATA, HREADYOUT, HRESP, HADDR, HTRANS, HREADY, HWDATA, HWRITE, HSIZE, HBURST;
  endclocking

  //Add modports here
modport DRV(output  	HRESETn, HCLK, HSEL, HADDR, HWDATA, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HREADY,
	    input 	HREADYOUT,HRESP, HRDATA);
modport DUT(input HRESETn, clocking cb_DUT);

modport MON(input HRESETn, clocking cb_MON);
modport TEST(input HCLK, HRESETn, HRDATA, HREADYOUT, HRESP,
             output HSEL, HADDR, HWDATA, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HREADY);
endinterface
