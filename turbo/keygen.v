module keygen
#(
	parameter index,
	parameter total
)

(
input rst, //rst
input clk, //clock
input ena, //ena 
input next, //if 1 then generate next key
output done, //if 1 all key have been looked up
output [0:127] key //key output
);
reg[7:0]cnt1_reg;
reg[7:0]cnt1_next;
reg[7:0]cnt2_reg;
reg[7:0]cnt2_next;
reg[7:0]cnt3_reg;
reg[7:0]cnt3_next;
reg[7:0]cnt4_reg;
reg[7:0]cnt4_next;
reg[7:0]cnt5_reg;
reg[7:0]cnt5_next;
reg[7:0]cnt6_reg;
reg[7:0]cnt6_next;

// State register
always@(posedge clk or posedge rst) begin 
if(rst) begin

if (index > total)
cnt1_reg<=32;
else 
cnt1_reg<=(65+index);

cnt2_reg<=65;
cnt3_reg<=65;
cnt4_reg<=65;
cnt5_reg<=65;
cnt6_reg<=65;
 end
else if(ena) begin
cnt1_reg<=cnt1_next;
cnt2_reg<=cnt2_next;
cnt3_reg<=cnt3_next;
cnt4_reg<=cnt4_next;
cnt5_reg<=cnt5_next;
cnt6_reg<=cnt6_next;
end
end

always@(*) begin
if(rst) begin
cnt1_next=(65+index);
cnt2_next=65;
cnt3_next=65;
cnt4_next=65;
cnt5_next=65;
cnt6_next=65;
end



if(cnt1_reg == 65+index) cnt1_next=94+index;
else if(cnt1_reg==94+index) begin
	cnt1_next=65+index;
	cnt2_next=cnt2_reg+1;
	end
else begin
cnt1_next=cnt1_reg;
cnt2_next=cnt2_reg+1; // dla 32
end


if(cnt2_reg==122) cnt2_next=32;
else if(cnt2_reg==32) begin
	cnt2_next=65;
	cnt3_next=cnt3_reg+1;
	end
if(cnt3_reg==122) cnt3_next=32;
else if(cnt3_reg==32) begin
	cnt3_next=65;
	cnt4_next=cnt4_reg+1;
	end
if(cnt4_reg==122) cnt4_next=32;
else if(cnt4_reg==32) begin
	cnt4_next=65;
	cnt5_next=cnt5_reg+1;
	end
if(cnt5_reg==122) cnt5_next=32;
if(cnt5_reg==32) begin
	cnt5_next=65;
	cnt6_next=cnt6_reg+1;
	end
end

						
						

// Output logic
assign key[0:79] = 'h68756c6b206973207468; //know part of key
assign key[80:87] = cnt1_reg;
assign key[88:95] = cnt2_reg;
assign key[96:103] = cnt3_reg;
assign key[104:111] = cnt4_reg;
assign key[112:119] = cnt5_reg;
assign key[120:127] = cnt6_reg;

assign done = (cnt6_reg==127) ? 1'b1 : 1'b0;

endmodule
