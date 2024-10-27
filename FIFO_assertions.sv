module FIFO_assertions(fifo_if.DUT fifoif);

    property full_assertion;
        @(posedge fifoif.clk) (DUT.count == fifoif.FIFO_DEPTH) |-> fifoif.full;
    endproperty
    assert property(full_assertion) else $error("Assertion failed: full signal mismatch");
	cover property(full_assertion);
	
    // Assertion for empty signal
    property empty_assertion;
        @(posedge fifoif.clk) (DUT.count == 0) |-> fifoif.empty;
    endproperty
    assert property(empty_assertion) else $error("Assertion failed: empty signal mismatch");
	cover property(empty_assertion);

    // Assertion for almostfull signal
    property almostfull_assertion;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n) (DUT.count == fifoif.FIFO_DEPTH - 1) |-> fifoif.almostfull;
    endproperty
    assert property(almostfull_assertion) else $error("Assertion failed: almostfull signal mismatch");
	cover property(almostfull_assertion);

    // Assertion for almostempty signal
    property almostempty_assertion;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n) (DUT.count == 1) |-> fifoif.almostempty;
    endproperty
    assert property(almostempty_assertion) else $error("Assertion failed: almostempty signal mismatch");
	cover property(almostempty_assertion);

    // Assertion for overflow signal
    property overflow_assertion;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.full && fifoif.wr_en) |-> ##1 fifoif.overflow;
    endproperty
    assert property(overflow_assertion) else $error("Assertion failed: overflow signal mismatch");
	cover property(overflow_assertion);

    // Assertion for underflow signal
    property underflow_assertion;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n) 
        (fifoif.empty && fifoif.rd_en) |-> ##1 fifoif.underflow;
    endproperty
    assert property(underflow_assertion) else $error("Assertion failed: underflow signal mismatch");
	cover property(underflow_assertion);

    // Assertion for correct count increment
    property count_increment_assertion;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.wr_en && !fifoif.rd_en && !fifoif.full && fifoif.rst_n) |-> ##[1:2] 
        (DUT.count == $past(DUT.count) + 1);
    endproperty
    assert property(count_increment_assertion) else $error("Assertion failed: count increment mismatch");
	cover property(count_increment_assertion);

    // Assertion for correct count decrement
    property count_decrement_assertion;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n) (!fifoif.wr_en && fifoif.rd_en && !fifoif.empty) |-> ##1 
        (DUT.count == $past(DUT.count) - 1);
    endproperty
    assert property(count_decrement_assertion) else $error("Assertion failed: count decrement mismatch");
	cover property(count_decrement_assertion);
endmodule