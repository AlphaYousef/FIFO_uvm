interface fifo_if(clk);
    input clk;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    logic [FIFO_WIDTH-1:0] data_in;
    bit  rst_n, wr_en, rd_en;
    logic  [FIFO_WIDTH-1:0] data_out;
    logic  wr_ack, overflow;
    logic  full, empty, almostfull, almostempty, underflow;
    
    modport DUT (
        input clk, rst_n, wr_en, rd_en,data_in,
        output wr_ack, overflow,full, empty, almostfull, almostempty, underflow,data_out);
    modport TEST (
        input clk,rst_n,wr_ack, overflow,full, empty, data_out,almostfull, almostempty, underflow,
        output wr_en, rd_en,data_in);
    modport MONITOR (
        input clk, rst_n, wr_en,data_in, rd_en,wr_ack, overflow,full, empty, almostfull, data_out,almostempty, underflow);

endinterface