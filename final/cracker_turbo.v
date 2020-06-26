module cracker_turbo
#(
	parameter total = 29
)

(
	input rst, 
	input clk,
	input start,
	output rdy,
	output reg [127:0] result
);


wire [63:0] data;
wire done;
wire [127:0] cracked_key[total:0];
wire [total:0] completion;


file_reader reader(
		.clk (clk),
		.read (data),
		.done (done)
);

//generacja modułów liter
genvar index;
generate
		for (index = 0; index < total;index = index+1) 
			begin: gen_code_label
				kombajn #(	index,total )kombajn_inst 
				
				(
					.rst (rst),
					.clk (clk),
					.start (done),
					.data (data),
					.rdy (completion[index]),
					.keyout(cracked_key[index])
				);
		

end

endgenerate

// Moduł spacji
kombajn #(1000,1)k0
	
(
	
	.rst (rst),
	.clk (clk),
	.start (done),
	.data (data),
	.rdy (completion[total]),
	.keyout(cracked_key[total])
);
integer i;
always@(*) begin
if (completion != 0) begin
	for (i=0; i < total; i = i+1)
	if (completion[i] == 1) result = cracked_key[i];
end
end

endmodule
