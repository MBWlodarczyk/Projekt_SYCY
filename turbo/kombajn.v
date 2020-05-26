module kombajn
#(
	parameter index,
	parameter total
)
(
	input  	   	  	 rst,
	input  			  	 clk,
	input  			  	 start,
	input  	  [63:0] data,
	output reg 		    rdy,
	output reg 		    [127:0]keyout
);

wire [127:0] key;
wire next;
wire done;
wire [63:0] result;
reg ena;
reg next_reg;
dekoder64
    b1
    (
		.rst (rst),
		.clk (clk),
		.start (start),
		.ena (ena),
		.data (data),
		.res (result),
		.rdy (next),
		.key (key)
    );
	 
keygen
		
		#(
			index,
			total
		)
		b2
		(
		.rst (rst),
		.clk (clk),
		.ena (next_reg),
		.done (done),
		.key (key),
		.next (1'b1)
		);
		

			

always@(*) begin
		if (rst) begin //clear
		rdy = 0;
		keyout = 0;
		end
if (result== 64'h2570646625706466) begin 
rdy = 1'b1;
keyout=key;
ena = 0;
next_reg=0;
end else if(key[127:120] == 8'd127) begin
ena = 0;
next_reg=0;
end else begin
ena = 1;
next_reg=next;
end

end

		
	 endmodule
	 
