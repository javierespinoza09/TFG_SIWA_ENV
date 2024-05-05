class inst_fetch_cov_collector extends uvm_subscriber #(inst_fetch_item);
	`uvm_component_utils(inst_fetch_cov_collector)
	inst_fetch_item inst;
	covergroup inst_c;
		coverpoint inst.opcode {
						bins r_type = {7'b0110011};
						bins i_type = {7'b0010011};
						bins s_type = {7'b0010011};
						bins b_type = {7'b0010011};
						bins u_type = {7'b0010011};
						bins j_type = {7'b0010011};
						bins l_type = {7'b0000011};
						bins lui_type = {7'b0110111};
						}
		coverpoint inst.func3 {
						bins b_func3 = {3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111};
						bins l_func3 = {3'b000, 3'b001, 3'b010, 3'b100, 3'b101};
						bins s_func3 = {3'b000, 3'b001, 3'b010};
						bins i_func3 = {[0:7]};
						bins r_func3 = {[0:7]};
		}
		coverpoint inst.func7 {
						bins i_finc7 = {7'b0100000}; //Cross with func3 = 3'b101
						bins r_finc7 = {7'b0100000}; //Cross with func3 = 3'b000 and 3'b101
		}
	endgroup : inst_c

endclass: inst_fetch_cov_collector

