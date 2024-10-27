import uvm_pkg::*;
import FIFO_test_pkg::*;
`include "uvm_macros.svh"
module top();
    bit clk;
    initial begin
        forever begin
            #4 clk =~clk;
        end
    end
    fifo_if fifoif(clk);
    FIFO DUT(fifoif);
    FIFO_assertions sva(fifoif);
    bind FIFO FIFO_assertions FIFO_sva_inst(fifoif);
    
    initial begin
        uvm_config_db#(virtual fifo_if)::set(null,"uvm_test_top","FIFO_IF",fifoif);
        run_test("FIFO_test"); 
    end
endmodule