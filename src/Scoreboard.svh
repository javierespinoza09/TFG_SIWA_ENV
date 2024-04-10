class Scoreboard extends uvm_scoreboard;
	`uvm_component_utils(Scoreboard)

	function new(string name="Scoreboard", uvm_component parent=null);
		super.new(name,parent);
	endfunction : new

	uvm_analysis_imp #(mon_sb, Scoreboard) sb_analysis_port;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sb_analysis_port = new("sb_analysis_port", this);

	endfunction : build_phase

	virtual function write(mon_sb mon_sb_i);
		if(mon_sb_i.reset == 1)  `uvm_info("SB", $sformatf("Analisys Port Activity : RST=%0d",mon_sb_i.reset),UVM_LOW)
		else begin
			`uvm_info("SB", $sformatf("Analisys Port Activity : Fetch3"),UVM_HIGH)
			for(int i = 0; i < 31; i++) begin
				`uvm_info("SB",$sformatf("%0d General [%0d] RAL = %h",
							$time,i,mon_sb_i.reg_values[i]),UVM_HIGH)
			end
		end
	endfunction : write
endclass : Scoreboard