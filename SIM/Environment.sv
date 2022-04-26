`include "Transactor.sv"
`include "monitor.sv"
`include "Scoreboard.sv"
`include "Generator.sv"
`include "Driver.sv"
`include "Interface.sv"
class environment;
  
  //handles of all components
  Generator  gen;
  Driver     drv;
  Monitor    mon;
  Scoreboard scb;
  
  //mailbox handles
  mailbox gen_2_drv;
  mailbox mon_2_scb;
  
  //declare an event
  //event all_recieved;
  //event
  
  //virtual interface handle
  virtual interface Interface intf;
  //constructor
    function new(virtual interface Interface intf);
      $display("\n\n-------Environment Constructor---------\n\n");
      this.intf = intf;
      gen_2_drv=new;
      mon_2_scb=new;
      gen=new(gen_2_drv);
      drv=new(intf, gen_2_drv);
      mon=new(intf, mon_2_scb);
      scb=new(mon_2_scb);
    endfunction
      
  //pre_test methods
    task pre_test();
      drv.reset();
      $display("\n-----pre_test task----");
    endtask
  //test methods
    task test();
      fork 
      	gen.main();
      	drv.main();
        mon.main();
        scb.main();
      join_any
    endtask
  //post_test methods
    task post_test();
      //$display("\n-----Post_test----");
      wait(gen.trans_count == 708);
      wait(scb.trans_count == 708);
      
    endtask
  //run methods
    task run();
      pre_test();
      test();
      post_test();

    endtask	
endclass


