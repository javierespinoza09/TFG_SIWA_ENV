

class Enviroment extends uvm_env;
	`uvm_component_utils(Enviroment);
   
  	Agent agent_inst;
    Scoreboard scoreboard_inst;
  	gen_sequence_item sequence_inst;
  	virtual wrapper_if v_if;
  	

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_inst = Agent::type_id::create("agent_inst",this);
        scoreboard_inst = Scoreboard::type_id::create("scoreboard_inst",this);
        scoreboard_inst.set_report_verbosity_level(UVM_MEDIUM);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent_inst.monitor_inst.mon_analysis_port.connect(scoreboard_inst.sb_analysis_port);
    endfunction : connect_phase

endclass : Enviroment