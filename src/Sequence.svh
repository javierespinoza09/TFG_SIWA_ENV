`include "Sequence_Item.svh"
class gen_sequence_item extends uvm_sequence #(drv_item);
    `uvm_object_utils(gen_sequence_item);

    function new (string name = "gen_sequence_item");
        super.new(name);
    endfunction

    function void build_phase(uvm_phase phase);

    endfunction : build_phase

    virtual task body();
        drv_item drv_item_i = = drv_item::type_id::create("drv_item_i");
        start_item(drv_item_i);
        drv_item_i.delay = 4000000;
        drv_item_i.sim_time = 700000000;
        
    endtask : body