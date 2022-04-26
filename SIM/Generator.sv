`define SV_RAND_CHECK(r)\
 do begin\
  if(!(r)) begin \
   $display("%s:%0d: Randamization failed \"%s\"", \
            `_FILE_,`_LINE_,`"r`");\
   $finish; \
  end \
 end while (0)
//Generates randomized transaction packets and put them in the mailbox to send the packets to driver 
`include "Transactor.sv"
class Generator;
  
  //declare transaction class
  Transaction pkt;
  
  //create mailbox handle
  mailbox gen_2_drv;
  int   trans_count;
  bit [3:0]   addr=0;
  //constructor
  function new(mailbox mbox);
    $display("\n-------generator constructor---------\n");
    gen_2_drv=mbox;
  endfunction
  //main methods
  
  task main;
    $display("\n-----------generator main------------\n");

//--------------------------Random word aligned write transactions------------------------------------------//
    for(int i=0; i <=99; i++) begin
    pkt = new;
    pkt.constraint_mode(0);
    pkt.write_word.constraint_mode(1);
    SV_RAND_CHECK(pkt.randomize());
    gen_2_drv.put(pkt);
    trans_count++;
    end
//------------------------------Random Word Aligned Read Transactions--------------------------------------//    
    for(int i=0; i <=99; i++) begin
    pkt = new;
    pkt.constraint_mode(0);
    pkt.read_word.constraint_mode(1);
    SV_RAND_CHECK(pkt.randomize());
    gen_2_drv.put(pkt);
    trans_count++;
    end
    
    //------------------------------Random Word Aligned Read/write Transactions--------------------------------------//    
    for(int i=0; i <=99; i++) begin
    pkt = new;
    pkt.constraint_mode(0);
    pkt.read_write_word.constraint_mode(1);
    SV_RAND_CHECK(pkt.randomize());
    gen_2_drv.put(pkt);
    trans_count++;
    end 
    
    //--------------------------Random byte write transactions------------------------------------------//
    for(int i=0; i <=99; i++) begin
    pkt = new;
    pkt.constraint_mode(0);
    pkt.write_byte.constraint_mode(1);
    SV_RAND_CHECK(pkt.randomize());
    pkt.HADDR = pkt.HADDR + i;
    gen_2_drv.put(pkt);
    trans_count++;
    end
    
    //--------------------------Random byte read transactions------------------------------------------//
    for(int i=0; i <=99; i++) begin
    pkt = new;
    pkt.constraint_mode(0);
    pkt.read_byte.constraint_mode(1);
    SV_RAND_CHECK(pkt.randomize());
    pkt.HADDR = pkt.HADDR + i;
    gen_2_drv.put(pkt);
    trans_count++; 
    end
    
   //------------------------------4-beat wrapping burst write Transactions--------------------------------------//    
      
    for(int i=0; i <=3; i++) begin
    pkt = new;
    pkt.constraint_mode(0);
    pkt.burst_write_word.constraint_mode(1);
    SV_RAND_CHECK(pkt.randomize());
    if(i == 0) addr = pkt.HADDR[3:0]; // will store the starting address
    pkt.HADDR = {pkt.HADDR[31:4],addr};
    addr = (4'b1111 & (addr[3:0] + 4));
    gen_2_drv.put(pkt);
    trans_count++;
    end
    
       //------------------------------4-beat wrapping burst read Transactions--------------------------------------//    
      
    for(int i=0; i <=3; i++) begin
    //$display("\n---------4-beat wrapping burst read transaction-----------\n");
    pkt = new;
    pkt.constraint_mode(0);
    pkt.burst_read_word.constraint_mode(1);
    SV_RAND_CHECK(pkt.randomize());
    if(i == 0) addr = pkt.HADDR[3:0]; // will store the starting address
    pkt.HADDR = {pkt.HADDR[31:4],addr};
    addr = (4'b1111 & (addr[3:0] + 4));
    gen_2_drv.put(pkt);
    trans_count++;
    end
    
       //------------------------------incrementing burst write Transactions--------------------------------------//    
      
    for(int i=0; i <=99; i++) begin
    pkt = new;
    pkt.constraint_mode(0);
    pkt.inc_burst_write_word.constraint_mode(1);
    SV_RAND_CHECK(pkt.randomize());
    pkt.HADDR = pkt.HADDR + (i*4);
    gen_2_drv.put(pkt);
    trans_count++;
    end
    
       //------------------------------incrementing burst read Transactions--------------------------------------//    
      
    for(int i=0; i <=99; i++) begin
    pkt = new;
    pkt.constraint_mode(0);
    pkt.inc_burst_read_word.constraint_mode(1);
    SV_RAND_CHECK(pkt.randomize());
    pkt.HADDR = pkt.HADDR + (i*4);
    gen_2_drv.put(pkt);
    trans_count++;
    end 
  endtask
  
endclass

