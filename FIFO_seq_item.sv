package FIFO_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_seq_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_seq_item)

        parameter int FIFO_WIDTH = 16;
        parameter int FIFO_DEPTH = 8;

        rand logic [FIFO_WIDTH-1:0] data_in;
        rand bit  rst_n, wr_en, rd_en;
        logic  [FIFO_WIDTH-1:0] data_out;
        // logic  [FIFO_WIDTH-1:0] data_out_ref;
        logic  wr_ack, overflow;
        logic  full, empty, almostfull, almostempty, underflow;

        int RD_EN_ON_DIST = 30;
        int WR_EN_ON_DIST = 70;

        // The constructor without additional arguments, initializing via set/override
        function new(string name = "FIFO_seq_item");
            super.new(name);
        endfunction

        // String conversion to print stimulus data
        function string convert2string();
            return $sformatf("%s reset = 0b%0b, data in =  0d%0d, wr_en = 0b%0b, rd_en = 0b%0b, data out = 0d%0d",
                            super.convert2string(), rst_n, data_in, wr_en, rd_en, data_out);
        endfunction

        // String conversion for printing input stimulus only
        function string convert2string_stimulus();
            return $sformatf("%s reset = 0b%0b, data in =  0d%0d, wr_en = 0b%0b, rd_en = 0b%0b",
                            super.convert2string(), rst_n, data_in, wr_en, rd_en);
        endfunction

        // Constraints for randomized values
        constraint rst_c {
            rst_n dist { 0:= 1, 1:=99 };
        }

        constraint wr_en_c {
            wr_en dist { 1 := WR_EN_ON_DIST, 0 := (100 - WR_EN_ON_DIST) };
        }

        constraint rd_en_c {
            rd_en dist { 1 := RD_EN_ON_DIST, 0 := (100 - RD_EN_ON_DIST) };
        }
        constraint data_in_c {
            data_in inside { [0 : 65535] }; 
        }


    endclass
endpackage