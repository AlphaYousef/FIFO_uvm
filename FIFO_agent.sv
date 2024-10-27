package FIFO_agent_pkg;
    import uvm_pkg::*;
    import FIFO_driver_pkg::*;
    import FIFO_seq_item_pkg::*;
    import FIFO_monitor_pkg::*;
    import FIFO_config_obj_pkg::*;
    import sequencer_pkg::*;
    `include "uvm_macros.svh"
class FIFO_agent extends uvm_agent;

    `uvm_component_utils(FIFO_agent)
    FIFO_monitor monitor;
    FIFO_driver driver;
    sequencer sqr;
    FIFO_config_obj cfg;
    uvm_analysis_port #(FIFO_seq_item) agt_ap;

    function new(string name ="FIFO_agent",uvm_component parent = null);
        super.new(name,parent);
    endfunction 
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#( FIFO_config_obj)::get(this,"","CFG",cfg))
            `uvm_fatal("build phase","Test unable to get the virtual interface of the FIFO ");
        driver = FIFO_driver::type_id::create("driver",this);
        sqr = sequencer::type_id::create("sqr",this);
        monitor = FIFO_monitor::type_id::create("monitor",this);
        agt_ap = new("agt_ap",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.fifo_driver_vif = cfg.fifo_config_vif;
        monitor.fifo_vif = cfg.fifo_config_vif;
        
        driver.seq_item_port.connect(sqr.seq_item_export);
        monitor.mon_ap.connect(agt_ap);
    endfunction
endclass 
endpackage