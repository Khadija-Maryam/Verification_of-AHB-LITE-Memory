//Gets the packet of transaction from the mailbox from generator and drives the transaction packet items into interface 
//(interface is connected to DUT, so the items driven into interface signal will get driven into DUT) 
//`define dif intf.drv.master
`include "interface.sv"
`include "Transactor.sv"
class Driver;
  //virtual interface handle
  virtual interface Interface intf;

  //create mailbox handle
   mailbox gen_2_drv;
   Transaction pkt;
    
    //event all_done;
  //constructor
    function new(virtual interface Interface intf, mailbox gen_2_drv);
      $display("\n-------driver constructor---------\n");
      this.intf = intf;
      this.gen_2_drv=gen_2_drv;
    endfunction
      
  //reset method
      task reset();     
        wait(!intf.DRV.HRESETn);   
		intf.DRV.HSEL    <= '0;
		intf.DRV.HADDR   <= '0;  
		intf.DRV.HTRANS  <= '0;   
		intf.DRV.HWRITE  <= '0;
		intf.DRV.HSIZE 	 <= '0; 
		intf.DRV.HBURST  <= '0; 
		intf.DRV.HPROT 	 <= '0; 
		intf.DRV.HWDATA  <= '0;  
        @(intf.DRV);
        @(intf.DRV);
        $display("--------driver reset------------");
        wait(intf.DRV.HRESETn);
      endtask
  //drive methods
      task drive();
        gen_2_drv.get(pkt);
		intf.DRV.HSEL  	<= pkt.HSEL;
		intf.DRV.HADDR 	<= pkt.HADDR;  
		intf.DRV.HTRANS	<= pkt.HTRANS;   
		intf.DRV.HWRITE <= pkt.HWRITE;
        	intf.DRV.HSIZE	<= pkt.HSIZE; 
		intf.DRV.HBURST <= pkt.HBURST; 
		intf.DRV.HPROT 	<= pkt.HPROT;  
        @(intf.DRV);
        	intf.DRV.HWDATA <= pkt.HWDATA;
        //-> all_done;
        // $display("--------driver drive task------------");
        //pkt.print("DRIVER");
      endtask
  //main methods
      task main;
        forever drive();
      endtask
endclass

