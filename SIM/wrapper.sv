`include "interface.sv"
module wrapper (DUT_interface.DUT DUT_inf);
ahb3lite_sram1rw #(
  		.MEM_SIZE	(0),
		.MEM_DEPTH	(256),
		.HADDR_SIZE	(8),
		.HDATA_SIZE	(32),
		.TECHNOLOGY	("GENERIC"),
		.REGISTERED_OUTPUT("NO"),
		.INIT_FILE	("")
		) ahb_master(	.HRESETn (DUT_inf.HRESETn),
				.HCLK	(DUT_inf.HCLK),
				.HSEL	(DUT_inf.HSEL),
				.HADDR	(DUT_inf.HADDR),
				.HWDATA	(DUT_inf.HWDATA),
				.HRDATA	(DUT_inf.HRDATA),
				.HWRITE	(DUT_inf.HWRITE),
				.HSIZE	(DUT_inf.HSIZE),
				.HBURST	(DUT_inf.HBURST),
				.HPROT	(DUT_inf.HPROT),
				.HTRANS	(DUT_inf.HTRANS),
				.HREADYOUT(DUT_inf.HREADYOUT),
				.HREADY	(DUT_inf.HREADY),
				.HRESP	(DUT_inf.HRESP)	);


endmodule
	