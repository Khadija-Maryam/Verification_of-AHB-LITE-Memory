//Samples the interface signals, captures into transaction packet and sends the packet to scoreboard.

`include "Transactor.sv"
class Monitor;
  
  //virtual interface handle
  virtual interface Interface intf;
    
  Transaction pkt;
  //event all_recieved;
  //create mailbox handle
	mailbox mon_2_scb;
  //constructor
    function new(virtual interface Interface intf, mailbox mbox);
      $display("\n-------monitor constructor---------\n");
      this.intf = intf;
      mon_2_scb = mbox;
      //pkt = new;
    endfunction
      
  //main method
      task main();
        //@(intf.mon.cb_mon);
        @(intf.MON.cb_MON);
        //wait(intf.mon.cb_mon.haddr)
        forever begin
          pkt = new;
          pkt.HADDR    =   intf.MON.cb_MON.HADDR;       
	  pkt.HSEL     =   intf.MON.cb_MON.HSEL;
	  pkt.HWRITE   =   intf.MON.cb_MON.HWRITE; 
	  pkt.HTRANS   =   intf.MON.cb_MON.HTRANS;   
          pkt.HSIZE    =   intf.MON.cb_MON.HSIZE; 
	  pkt.HBURST   =   intf.MON.cb_MON.HBURST; 
	  pkt.HPROT    =   intf.MON.cb_MON.HPROT;  
          @(intf.MON.cb_MON);
          pkt.HWDATA   =   intf.MON.cb_MON.HWDATA;
          pkt.HRDATA   =   intf.MON.cb_MON.HRDATA;
          pkt.HREADY  =   intf.MON.cb_MON.HREADY;
          pkt.HRESP    =   intf.MON.cb_MON.HRESP;
          //$display("\n-------Monitor Main Task-----------\n"); 
          mon_2_scb.put(pkt);
          //pkt.print("MONITOR");
          //-> all_recieved;
        end
        endtask
endclass

