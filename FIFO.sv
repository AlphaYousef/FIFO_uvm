module FIFO(fifo_if.DUT fifoif);

localparam max_fifo_addr = $clog2 (fifoif.FIFO_DEPTH); 
reg [fifoif.FIFO_WIDTH-1:0] mem [fifoif.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;  
reg [max_fifo_addr:0] count; 

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		wr_ptr <= 0;
		fifoif.overflow <= 0;  
		fifoif.wr_ack <=0 ;  
	end
	else if (fifoif.wr_en && count < fifoif.FIFO_DEPTH) begin 
		mem[wr_ptr] <= fifoif.data_in;
		fifoif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		fifoif.overflow <= 0; // bug found
	end
	else begin 
		fifoif.wr_ack <= 0; 
		if (fifoif.full && fifoif.wr_en )  
			fifoif.overflow <= 1;
		else
			fifoif.overflow <= 0;
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		rd_ptr <= 0;
		fifoif.underflow <=0;
	end
	else if (fifoif.rd_en && count != 0) begin
		fifoif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		fifoif.underflow <=0 ; // bug found
	end
	else begin
		if(fifoif.empty && fifoif.rd_en)  
			fifoif.underflow <=1 ;
		else
			fifoif.underflow <=0 ;	
	end

end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		count <= 0;
	end
	else begin  
		if	( (({fifoif.wr_en, fifoif.rd_en} == 2'b10) && !fifoif.full) || (fifoif.empty && ({fifoif.wr_en, fifoif.rd_en} == 2'b11) )) 
			count <= count + 1;
		else if ( (({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty) || (fifoif.full && ({fifoif.wr_en, fifoif.rd_en} == 2'b11) ) )
			count <= count - 1;
	end
end

assign fifoif.full = (count == fifoif.FIFO_DEPTH)? 1 : 0;  
assign fifoif.empty = (count == 0)? 1 : 0;
assign fifoif.almostfull = (count == fifoif.FIFO_DEPTH-1)? 1 : 0;  
assign fifoif.almostempty = (count == 1)? 1 : 0;


endmodule