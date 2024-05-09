class inst_fetch_cov_collector extends uvm_subscriber #(inst_fetch_item);
	`uvm_component_utils(inst_fetch_cov_collector)
	inst_fetch_item inst;
	uvm_analysis_imp #(inst_fetch_item, inst_fetch_cov_collector) cov_analysis_port;
	covergroup inst_c;
		cp1: coverpoint inst.opcode {
		option.weight = 0;
		type_option.weight = 0;
						bins r_type = 		{7'b0110011};
						bins i_type = 		{7'b0010011};
						bins s_type = 		{7'b0100011};
						bins b_type = 		{7'b0010011};
						bins auipc_type = 	{7'b0010111};
						bins jal_type = 	{7'b1101111};
						bins jalr_type =	{7'b1100111};
						bins l_type = 		{7'b0000011};
						bins lui_type = 	{7'b0110111};
						}
		cp2: coverpoint inst.func3 {
		option.weight = 0;
		type_option.weight = 0;
						bins b_func3 = {3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111};
						bins l_func3 = {3'b000, 3'b001, 3'b010, 3'b100, 3'b101};
						bins s_func3 = {3'b000, 3'b001, 3'b010};
						bins i_func3 = {3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b110, 3'b111};
						bins i_sr_func3 = {3'b101};
						bins r_func3 = {3'b001, 3'b010, 3'b011, 3'b100, 3'b110, 3'b111};
						bins r_sr_add_func3 = {3'b000, 3'b101};
		}
		cp3: coverpoint inst.func7 {
		option.weight = 0;
		type_option.weight = 0;
						bins i_func7 = {7'b0100000,7'b0000000}; //Cross with func3 = 3'b101
						bins r_func7 = {7'b0100000,7'b0000000}; //Cross with func3 = 3'b000 and 3'b101
		}
		c1_x_c2: cross cp1,cp2,cp3 {
		option.weight = 1;
		type_option.weight = 1;
							bins s = binsof(cp1.s_type) && binsof(cp2.s_func3);
							bins r = binsof(cp1.r_type) && binsof(cp2.r_func3);
							bins i = binsof(cp1.i_type) && binsof(cp2.i_func3);
							bins r_3_7 = binsof(cp1.r_type) && binsof(cp2.r_sr_add_func3) && binsof(cp3.r_func7);
							bins i_3_7 = binsof(cp1.i_type) && binsof(cp2.i_sr_func3) && binsof(cp3.i_func7);
							bins b = binsof(cp1.b_type) && binsof(cp2.b_func3);
							bins l = binsof(cp1.l_type) && binsof(cp2.l_func3);

		}
	endgroup : inst_c



	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cov_analysis_port = new("cov_analysis_port", this);
		
	endfunction

	function new (string name = "inst_fetch_cov_collector", uvm_component parent = null);
		super.new(name, parent);
		inst_c = new();

	endfunction : new

	virtual function void write(inst_fetch_item inst_i);
		inst = inst_i;
		inst_c.sample();
		`uvm_info(get_full_name(),$sformatf("OLD Coverage %0d", inst_c.get_coverage()), UVM_LOW)
	endfunction : write
endclass: inst_fetch_cov_collector

