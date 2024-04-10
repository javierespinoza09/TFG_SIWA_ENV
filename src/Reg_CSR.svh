class Reg_CSR extends  uvm_reg;
	`uvm_object_utils(Reg_CSR)

	uvm_reg_field status;

	function new (string name = "Reg_CSR");
		super.new(name, 8, UVM_NO_COVERAGE);
	endfunction

	function void build;
		status = uvm_reg_field::type_id::create("status");
		status.configure(.parent(this),.size(8),.lsb_pos(0),
						.access("RW"),.volatile(0),.reset(1),
						.has_reset(1),.is_rand(1),
						.individually_accessible(1));
	endfunction : build
		
endclass : Reg_CSR

class csr_reg_block extends  uvm_reg_block;
	`uvm_object_utils(csr_reg_block)

	rand Reg_CSR control_sm;

	function new (string name = "csr_reg_block");
		super.new(name,build_coverage(UVM_NO_COVERAGE));
	endfunction : new

	function void build;
		control_sm = Reg_CSR::type_id::create("control_sm");
		control_sm.configure(this, null, "");
		control_sm.build();

		control_sm.add_hdl_path_slice("cur_state",
										0, control_sm.get_n_bits());
		//default_map.add_reg(this.control_sm, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		add_hdl_path("tb_top.dut_wr.uut.TOP.central_control");
		lock_model();

	endfunction : build
endclass : csr_reg_block