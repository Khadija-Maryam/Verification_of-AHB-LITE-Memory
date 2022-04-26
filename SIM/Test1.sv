//A program block that creates the environment and initiate the stimulus
`include "Environment.sv"
program test(Interface intf);
  
  //declare environment handle
  Environment env;
  
  initial begin
    //create environment
     $display("\n\n-----Test initial block------------\n\n");
     env = new(intf);
    //initiate the stimulus by calling run of env
    env.run();
  end

endprogram

