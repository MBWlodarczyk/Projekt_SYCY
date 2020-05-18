module cracker


(
	input rst, 
	input clk,
	input start,
	output rdy,
	output reg [127:0] result
);


wire [63:0] data;
wire done;
wire [127:0] cracked_key;


file_reader reader(
		.clk (clk),
		.read (data),
		.done (done)
);

kombajn k1(
	.rst (rst),
	.clk (clk),
	.start (done),
	.data (data),
	.rdy (rdy),
	.keyout(cracked_key)
);

always@(*) begin
if (rdy) result = cracked_key;
end

endmodule