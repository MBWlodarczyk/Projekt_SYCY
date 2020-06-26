module dekoder64
#(
	parameter N = 64,
	parameter K = 128
)
(
	input  	   	  	 rst,
	input  			  	 clk,
	input  			  	 ena,
	input  			  	 start,
	input  	  [N-1:0] data,
	input  	  [K-1:0] key,
	output reg [N-1:0] res, 
	output reg 		    rdy
);
	// States
	localparam SIZE = 4;
	localparam [SIZE-1:0] idle   = 4'd0,
								 init   = 4'd1, //dividing key to 4seg and data to 2seg
								 divide 	 = 4'd2,
								 state_r2 = 4'd3,
								 state_l1 = 4'd4,
								 state_l2 = 4'd5,
								 state_r1 = 4'd6,
								 swap		 = 4'd7,
								 store 	 = 4'd8;
								 
								 
	reg [SIZE-1:0] state_reg, state_next;
	reg 				rdy_next;
	
	integer deltaValue = 2654435769;
	integer cycles = 32;
	integer iteration = 0;
	integer sum = 0 - 957401312;
	reg [31:0] sum_par = 32'hc6ef3720;
	
	reg  [N-1:0] data_reg;
	reg  [K-1:0] key_reg;
	reg  [31:0] delta;
	reg  [31:0] key0, key1, key2, key3;
	reg  [31:0] temp0, temp1, temp2, temp3;
	reg  [31:0] temp0_next, temp1_next, temp2_next, temp3_next;
	reg  [31:0] L_reg,L_next;
	reg  [31:0] R_reg,R_next;
	reg  [N-1:0] res_next;

	// State register
	always@(posedge clk or posedge rst) begin
		if (rst) begin
			state_reg <= idle;
			rdy		 <= 1'b0;
		end
		else if (ena) begin
			state_reg <= state_next;
			rdy		 <= rdy_next;
		end
	end

	// Registers
	always@(posedge clk or posedge rst) begin
		if (rst) begin //clear
			L_reg <= {(N){1'b0}};
			R_reg <= {(N){1'b0}};
			temp0 <= {(N){1'b0}};
			temp1 <= {(N){1'b0}};
			temp2 <= {(N){1'b0}};
			temp3 <= {(N){1'b0}};
			res	<= {(N){1'b0}};
			
		end
		else if (ena) begin //get from input
			L_reg	<= L_next;
			R_reg <= R_next;
			temp0 <= temp0_next;
			temp1 <= temp1_next;
			temp2 <= temp2_next;
			temp3 <= temp3_next;
			res 	<= res_next;
		end		
	end
	
	// Next state logic
	always@(*) 
		case(state_reg)
			idle 	 : if (start) state_next = init;
					   else		  state_next = idle;
			init 	 : state_next = divide;
			divide :	state_next = state_l2;
			state_r2 : state_next = state_l1;
			state_l1 : state_next = swap;
			state_l2 : state_next = state_r1;
			state_r1 : state_next = state_r2;
			swap : begin
					 if(iteration % cycles == 0)
					 begin
					 state_next = store;
					 end
					 else
					 state_next = state_l2;
					 end
			store: state_next = idle;
			default: state_next = idle;
		endcase	

	// Microoperation logic
	always@(*) begin
		L_next   = L_reg;
		R_next   = R_reg;
		temp0_next = temp0;
		temp1_next = temp1;
		temp2_next = temp2;
		temp3_next = temp3;
		res_next	= res;
		rdy_next	= 1'b0;
	
		case(state_reg)
			init		:	begin
								data_reg  = data;
								key_reg = key;
								delta 	= deltaValue;
								res_next = {(N){1'b0}};
							end
			divide	:	begin
								L_next 	= data_reg[63:32];
								R_next 	= data_reg[31:0];
								key3 		= key_reg[31:0];
								key2		= key_reg[63:32];
								key1 		= key_reg[95:64];
								key0 		= key_reg[127:96];
							end
			state_r2	:  
			begin
			temp0_next = ((R_reg << 4) + key0);
			temp1_next =  R_reg + sum_par;
		        temp2_next = ((R_reg >> 5) + key1);
		        end 
			state_l1 : 
			begin
			temp3_next = (temp0 ^ temp1 ^ temp2);
			L_next = L_reg - temp3_next;
			end
			state_l2 : 	
			begin
			temp0_next = ((L_reg << 4) + key2);
			temp1_next =  L_reg + sum_par;
			temp2_next = ((L_reg >> 5) + key3);
			end
			state_r1 :	
			begin
			temp3_next = temp0 ^ temp1 ^ temp2;
			R_next = R_reg - temp3_next;
			end
			swap		: 	begin
							iteration = iteration + 1;
							sum = sum - delta;
							sum_par = sum;
							
							//R_next = L_reg;
							//L_next = R_reg;
							end
			store	:	begin
								res_next[63:32] = L_reg;
								res_next[31:0] = R_reg;
								rdy_next = 1'b1;
								sum = 0 - 957401312;
								sum_par = 32'hc6ef3720;
							end
			default	: 	;					
		endcase
	end
endmodule
