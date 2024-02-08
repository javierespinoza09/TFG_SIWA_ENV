

class Agent extends  uvm_agent;
	`uvm_component_utils(Agent);
	string name = "Agent";

	Driver driver_inst;
	uvm_sequencer #(drv_item) sequencer_inst;



	function new(string name, uvm_component parent = null);
	    super.new(name,parent);
	 endfunction

	function void build_phase(uvm_phase phase);
  		driver_inst = Driver ::type_id::create($sformatf("driver_inst"),this);
  		sequencer_inst = uvm_sequencer #(drv_item)::type_id::create($sformatf("sequencer_inst"), this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
    	driver_inst.seq_item_port.connect(sequencer_inst.seq_item_export);
	endfunction



endclass // Agent

