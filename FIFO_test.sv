package FIFO_test_pkg;
    import FIFO_env_pkg::*;
    import uvm_pkg::*;
    import FIFO_config_obj_pkg::*;
    // import FIFO_agent_pkg::*;
    // import sequencer_pkg::*;
    // import FIFO_driver_pkg::*;
    import FIFO_seq_pkg::*;
    
    `include "uvm_macros.svh"
    class FIFO_test extends uvm_test;
    `uvm_component_utils(FIFO_test)
    FIFO_env env;
    FIFO_config_obj FIFO_config_obj_test;
    // virtual fifo_if FIFO_test_vif;
    write_sequence write_seq;
    FIFO_reset_seq reset_seq;
    read_sequence read_seq;
    read_write_sequence read_write_seq;

    function new(string name ="FIFO_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = FIFO_env::type_id::create("env",this);
        FIFO_config_obj_test = FIFO_config_obj::type_id::create("cfg");
        write_seq = write_sequence::type_id::create("write_seq");
        reset_seq = FIFO_reset_seq::type_id::create("reset_seq");
        read_seq = read_sequence::type_id::create("read_seq");
        read_write_seq = read_write_sequence::type_id::create("read_write_seq");
        if(!uvm_config_db#(virtual fifo_if)::get(this,"","FIFO_IF",FIFO_config_obj_test.fifo_config_vif))
            `uvm_fatal("build phase","Test unable to get the virtual interface of the FIFO ");
        uvm_config_db#(FIFO_config_obj)::set(this,"*","CFG",FIFO_config_obj_test);
    endfunction
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        `uvm_info("run_phase","Reset Asserted",UVM_LOW);
        reset_seq.start(env.agt.sqr);
        `uvm_info("run_phase","Reset Deasserted",UVM_LOW);

        `uvm_info("run_phase","Stimulus Generation Started",UVM_LOW);
        write_seq.start(env.agt.sqr);
        `uvm_info("run_phase","Write seq finished",UVM_LOW);
        read_seq.start(env.agt.sqr);
        `uvm_info("run_phase","Read seq finished",UVM_LOW);
        read_write_seq.start(env.agt.sqr);
        `uvm_info("run_phase","Write Read seq finished",UVM_LOW);
        `uvm_info("run_phase","Stimulus Generation Ended",UVM_LOW);

        phase.drop_objection(this);
    endtask : run_phase
endclass
endpackage