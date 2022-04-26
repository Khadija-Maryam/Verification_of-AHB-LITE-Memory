//Gets the packet from monitor, generates the expected result and compares with the actual result received from the Monitor
`include "Transactor.sv"
class Scoreboard;
   Transaction scb[$];
  //create mailbox handle
	mailbox mon_2_scb;
  	Transaction pkt;
  	int trans_count = 0;
    int error_count = 0;
  //array to use as local memory
  logic [7:0] mem [int];
  
  //constructor
  function new(mailbox mbox);
    $display("\n-------scoreboard constructor---------\n");
    mon_2_scb = mbox;
    for(int i=0; i < 1024; i++) mem[i]= i;
    //for(int i=0; i < 1024; i++) $display("\nmem[%0d][2]= %0h", i, mem[i][3:2]);
  endfunction

function void save_ecpected(input Transaction tr);
int push_back (tr);
endfunction

function void compare_actual(input Transaction tr );
int q[$];
q = scb.find_index(x) with (x.src == tr.src);
case (q.size())
0: $display("No match found");
1: scb.delete(q[0]);
default: 
$display("Error, multiple matches found");
endcase
endfunction : compare_actual

  //-----------------------main method-----------------------------------------------//
  task main();
    forever begin
    mon_2_scb.get(pkt);
    $display("\n----Scoreboard Main--------------\n");
    //pkt.print("SCOREBOARD");
    
//--------------------------Write Word---------------------------------------//
   if(pkt.HWRITE && pkt.HSIZE==3'b010) begin
      mem[pkt.HADDR]     = pkt.HWDATA[7:0];
      mem[pkt.HADDR + 1] = pkt.HWDATA[15:8];
      mem[pkt.HADDR + 2] = pkt.HWDATA[23:16];
      mem[pkt.HADDR + 3] = pkt.HWDATA[31:24];
      //$display("\n----memory content after writing-------\n");
      //$display("\n mem[%0d]= %0h  mem[%0d]= %0h  mem[%0d]= %0h  mem[%0d]= %0h", pkt.haddr, mem[pkt.haddr], (pkt.haddr + 1), mem[pkt.haddr + 1], (pkt.haddr + 2) , mem[pkt.haddr+2], (pkt.haddr+3), mem[pkt.haddr+3]);
    end
//--------------------------Read Word---------------------------------------//    
    else if(!pkt.HWRITE && pkt.HSIZE==3'b010) begin
      if ((mem[pkt.HADDR]     = pkt.HWDATA[7:0]) && 
          (mem[pkt.HADDR + 1] = pkt.HWDATA[15:8]) &&
          (mem[pkt.HADDR + 2] = pkt.HWDATA[23:16]) &&
          (mem[pkt.HADDR + 3] = pkt.HWDATA[31:24])) begin
        //$display("\n-------Data Matched----------\n");
        //$display("\n-------Expected: mem[%0d]= %0h, Actual mem[%0d]:%0h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[7:0]);
      end
      else begin
        $display("\n-------Data Mis-Matched----------------\n");
       // $display("\n-------Expected: mem[%0d]= %0h, Actual mem[%0d]:%0d----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[7:0]); 
        error_count++; end
    end
//--------------------------Write Half Word---------------------------------------//      
    else if(pkt.HWRITE && pkt.HSIZE==3'b001) begin
      mem[pkt.HADDR]     = pkt.HWDATA[7:0];
      mem[pkt.HADDR + 1] = pkt.HWDATA[15:8];
      //$display("\n----memory content after writing-------\n");
      //$display("\n mem[%0d]= %0h  mem[%0d]= %0h", pkt.haddr, mem[pkt.haddr], (pkt.haddr + 1), mem[pkt.haddr + 1]);
    end
//--------------------------Read Half Word---------------------------------------//    
    else if(!pkt.HWRITE && pkt.HSIZE==3'b001) begin
      if ( mem[pkt.HADDR]     == pkt.HRDATA[7:0] && 
           mem[pkt.HADDR + 1] == pkt.HRDATA[15:8]) begin
        //$display("\n-------Data Matched----------\n");
        //$display("\n-------Expected: mem[%0d]= %0h, Actual mem[%0d]:%0h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[7:0]); 
      end
      else begin
        $display("\n-------Data Mis-Matched----------------\n");
        //$display("\n-------Expected: mem[%0d]= %0h, Actual mem[%0d]:%0d----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[7:0]); 
        error_count++; end
    end
//--------------------------Write Byte---------------------------------------//       
    else if(pkt.HWRITE && pkt.HSIZE==3'b000) begin
      //$display("\n------------Address durring this trans is: haddr = %d-------------------\n", pkt.haddr);
      if( pkt.HADDR % 4 == 0 )  mem[pkt.HADDR] = pkt.HWDATA[7:0]; 
      else if ( pkt.HADDR % 4 == 1 ) mem[pkt.HADDR] = pkt.HWDATA[15:8]; 
      else if ( pkt.HADDR % 4 == 2 )  mem[pkt.HADDR] = pkt.HWDATA[23:16]; 
      else if ( pkt.HADDR % 4 == 3)   mem[pkt.HADDR] = pkt.HWDATA[31:24]; 
      else mem[pkt.HADDR] = pkt.HWDATA;
      //$display("\n----memory content after writing-------\n");
      //$display("\n mem[%0d]= %0h", pkt.haddr, mem[pkt.haddr]);
    end
//--------------------------Read Byte---------------------------------------//           
    else if(!pkt.HWRITE && pkt.HSIZE==3'b000) begin
      if( pkt.HADDR%4 == 0) begin
      	if ( mem[pkt.HADDR] == pkt.HRDATA[7:0]) begin
        //	$display("\n-------Data Matched----------\n");
        //  $display("\n-------Expected: mem[%0d]= %h, Actual mem[%0d]:%h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[7:0]); 
      		end
      	else begin
        	$display("\n-------Data Mis-Matched----------------\n");
          //$display("\n-------Expected: mem[%0d]= %h, Actual mem[%0d]:%h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[7:0]); 
        	error_count++; 
      		end
    	end
      else begin
        if(pkt.HADDR%4 == 1)
          if ( mem[pkt.HADDR] == pkt.HRDATA[15:8]) begin
        //	$display("\n-------Data Matched----------\n");
          //  $display("\n-------Expected: mem[%0d]= %h, Actual mem[%0d]:%h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[15:8]); 
      		end
      	  else begin
        	$display("\n-------Data Mis-Matched----------------\n");
            //$display("\n-------Expected: mem[%0d]= %h, Actual mem[%0d]:%h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[15:8]); 
        	error_count++; 
      		end
        else if (pkt.HADDR%4 == 2)
          if ( mem[pkt.HADDR] == pkt.HRDATA[23:16]) begin
        	//$display("\n-------Data Matched----------\n");
            //$display("\n-------Expected: mem[%0d]= %h, Actual mem[%0d]:%h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[23:16]); 
      		end
      	  else begin
        	$display("\n-------Data Mis-Matched----------------\n");
            //$display("\n-------Expected: mem[%0d]= %h, Actual mem[%0d]:%h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[23:16]); 
        	error_count++; 
      		end
        else begin
          if ( mem[pkt.HADDR] == pkt.HRDATA[31:24]) begin
        	//$display("\n-------Data Matched----------\n");
        	//$display("\n-------Expected: mem[%0d]= %h, Actual mem[%0d]:%h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[31:24]); 
      		end
      	  else begin
        	$display("\n-------Data Mis-Matched----------------\n");
           // $display("\n-------Expected: mem[%0d]= %h, Actual mem[%0d]:%0h----------------\n", pkt.haddr, mem[pkt.haddr], pkt.haddr, pkt.hrdata[31:24]); 
        	error_count++; 
      		end
        end
        end
    end
    else $display("\n-----------------Invalid Transaction-----------------------\n");
    trans_count++;
      $display("\n-------------------Transaction Counter:%0d------------------\n", trans_count);
      if(trans_count == 708) begin
    	if(error_count != 0) 
      		$display("\n-------------Test Failed!-----error_count:%0d--------------------\n", error_count);
      	else 
        	$display("\n------------------All Tests Passed!--------------------------------------------\n"); 
      $display("\n---------------------Total Transaction_count:%0d--------------------\n", trans_count);
    end
    end
  endtask
endclass

