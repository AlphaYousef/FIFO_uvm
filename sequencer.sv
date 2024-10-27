package sequencer_pkg ;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class sequencer extends uvm_sequencer #(FIFO_seq_item);
`uvm_component_utils(sequencer) 
    function new(string name = "my_sequencer" , uvm_component parent = null);
        super.new(name,parent) ;
    endfunction 
endclass 
    
endpackage