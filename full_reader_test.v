module full_reader
#(
	parameter block_size = 64
)

(
	input rst,
	input clk,
	input req,
	input ena,
	input start,
	output reg [block_size-1:0] read,
	output reg done,
	output reg complete
);

	localparam SIZE = 3;
	localparam [SIZE-1:0]	 idle = 3'd0,
									 init = 3'd1,
								 reqwait = 3'd2,
								     get = 3'd3,
									ready = 3'd4;
	reg [SIZE-1:0] state_reg, state_next;
	reg 				done_next;
	

	integer stream;
	integer offset = 0;
	integer size;
	// State register
	always@(posedge clk or posedge rst) begin
		if (rst) begin
			state_reg <= idle;
			done		 <= 1'b0;
		end
		else if (ena) begin
			state_reg <= state_next;
			done		 <= done_next;
		end
	end
	
	// Registers
	always@(posedge clk or posedge rst) begin
		if (rst) begin //clear
		read = {(block_size){1'b0}};
		done = 1'b0;
		offset = 0;
		size = 0;
		complete = 0;
		end
		else if (ena) begin
			state_reg <= state_next;
			done		 <= done_next;
		end
	end
	
	//State logic
	always@(*)
		case (state_reg)
					idle : if (start) state_next = init;
							 else 		state_next = idle;
					init : state_next = reqwait;
				reqwait : if (req)   state_next = get;
							 else 		state_next = reqwait;
					get : state_next = ready;
				   ready : if (size == block_size) state_next = reqwait;
							  else 						  state_next = idle;
				default : state_next = idle;
		endcase	
	
	//Micrologic
	always@(*) begin
		done_next = done;
			
			case (state_reg)
					init	  : begin
	/* synthesis translate_off */    stream = $fopen("binarytest.txt","rb");
								/* synthesis translate_on */
									done_next = 0;
								 end
					reqwait : read = 0;
					get 	  : size = $fread(stream, read);
					ready   : begin
								 done_next = 1'b1;
								 if (size != block_size) complete = 1'b1;
								 else 						complete = 1'b0;
								 end
					default : ;
			endcase
		end
endmodule