module file_reader 
#(
//Ile wczytamy z pliku, 7 bo " %PDF-1."  to 7 par hexow
	parameter N = 7
)

(
input clk,
	output [N-1:0] read
);

	reg [N-1:0] mem[N-1:0];
	reg [N-1:0] x;
		integer i=0;


initial 
begin 
  //Nazwa pliczku z którego czytamy, trzeba go załadować do projektu tak jak zwykły plik veriloga
  
	$readmemh("test.txt", mem);
	
	
	$display("%b", mem);
	
end

always@(posedge clk) begin
x<=mem[i];
i=i+1;
end

assign read = x; 

endmodule
