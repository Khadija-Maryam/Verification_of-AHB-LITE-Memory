//Fields required to generate the stimulus are declared in the transaction class

class Transaction;
  //declare transaction items
	logic			HRESETn; 
  	logic			HSEL = 1'b1; 
  rand  logic [31:0]		HADDR; 
  rand	logic [1:0]		HTRANS; 
  rand	logic			HWRITE; 
  rand  logic [2:0]		HSIZE; 
  rand	logic [2:0]		HBURST; 
  rand  logic [3:0]		HPROT; 
  rand	logic [31:0]		HWDATA; 
        logic [31:0]	    	HRDATA; 
        logic			HREADY; 
        logic [2:0]	        HRESP;

//Add Constraints
  constraint c {	HADDR >  32'h00000000;
			HADDR    <  32'h00000400;
	}
  constraint write_word{
    		HBURST == 3'b000;    
                HTRANS == 2'b10;	
    		HADDR % 4 == 0 && HADDR < 32'd1024;
    		HSIZE  == 3'b010;
    		HWRITE == 1'b1; //Direction=write
               			}
  
  constraint read_word{
    		HBURST == 3'b000;    
                HTRANS == 2'b10;	
    		HADDR % 4 == 0 && HADDR < 32'd1024;
    		HSIZE  == 3'b010;
    		HWRITE == 1'b0;}
  
  constraint write_byte{
    					HBURST == 3'b000;    
                        		HTRANS == 2'b10;	
    					HADDR == 32'd10;
    					HSIZE  == 3'b000;
    					HWRITE == 1'b1;
    					
               			}
  
  constraint read_byte{
    					HBURST == 3'b000;    
                        		HTRANS == 2'b10;	
    					HADDR  == 32'd10;
    					HSIZE  == 3'b000;
    					HWRITE == 1'b0;
               			}
  
  constraint read_write_word{
    					HBURST == 3'b000;    
                        		HTRANS == 2'b10;	
    					HADDR % 4 == 0 && HADDR < 32'd1024;
    					HSIZE  == 3'b010;
               			}
  constraint burst_write_word{
    					HBURST == 3'b010;    
                        		HTRANS == 2'b11;	
    					HADDR  == 32'h34;
    					HSIZE  == 3'b010;
    					HWRITE == 1'b1;
               			}
  constraint burst_read_word{
    					HBURST == 3'b010;    
                        		HTRANS == 2'b11;	
    					HADDR  == 32'h34;
    					HSIZE  == 3'b010;
    					HWRITE == 1'b0;
               			}
    constraint inc_burst_write_word{
    					HBURST == 3'b001;    
                        		HTRANS == 2'b11;	
    					HADDR  == 32'h54;
    					HSIZE  == 3'b010;
    					HWRITE == 1'b1;
               			}
  constraint inc_burst_read_word{
    					HBURST == 3'b010;    
                        		HTRANS == 2'b11;	
    					HADDR  == 32'h54;
    					HSIZE  == 3'b001;
    					HWRITE == 1'b0;
               			}
   
  task run();
 forever begin

 end
endtask  
 
endclass





//Transaction tr;
//initial begin
//tr = new();
//`SV_RAND_CHECK(tr.randomize());
//if(!p.randomize())
//$finish;
//end