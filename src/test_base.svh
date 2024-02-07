class test_base extends uvm_test;
	`uvm_component_utils(test_base)


	function new(string name = "test_base", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    Envitoment env_inst;
    gen_sequence_item sequence_inst;
    virtual wrapper_if v_if;

    virtual function void build_phase(uvm_phase phase);

	    super.build_phase(phase);
	    a0 = ambiente::type_id::create("a0", this);
	    if(!uvm_config_db#(virtual router_if)::get(this, "", "v_if", v_if)) begin
	        uvm_error("","uvm_config_db::get failed")
	    end
	    uvm_config_db#(virtual wrapper_if)::set(this, "env_inst.agent_inst.*", "router_if", v_if);

	endfunction


    virtual task run_phase(uvm_phase phase);

            sequence_inst.start(env_inst.agent_inst.sequencer_inst);

    endtask


endclass : test_base