class test_base extends uvm_test;
	`uvm_component_utils(test_base)


	function new(string name = "test_base", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    Enviroment env_inst;
    gen_sequence_item sequence_inst;
    virtual wrapper_if v_if;

    virtual function void build_phase(uvm_phase phase);

	    super.build_phase(phase);
	    env_inst = Enviroment::type_id::create("env_inst", this);
	    if(!uvm_config_db#(virtual wrapper_if)::get(this, "", "v_if", v_if)) begin
	        //`uvm_error("","uvm_config_db::get failed")
	    end
	    uvm_config_db#(virtual wrapper_if)::set(this, "env_inst.agent_inst.*", "router_if", v_if);
	    sequence_inst = gen_sequence_item::type_id::create($sformatf("sec_message"),this);
		
	endfunction


    virtual task run_phase(uvm_phase phase);
    	//phase.raise_objection(this);
            sequence_inst.start(env_inst.agent_inst.sequencer_inst);
        //phase.drop_objection(this);
    endtask

    virtual function void extract_phase(uvm_phase phase);
    	`uvm_warning("TB",$sformatf("Simulation Delay Finished at %0d", $time(),UVM_LOW))
    	$finish;
    endfunction : extract_phase

endclass : test_base