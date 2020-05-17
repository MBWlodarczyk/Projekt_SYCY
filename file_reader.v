module file_reader 
#(
//Ile wczytamy z pliku, 8 bo %pdf%pdf to 8 par hexow
	parameter N = 8
)

(
input clk,
	output [7:0] read
);

	reg [7:0] mem[N-1:0];
	reg [7:0] x;
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
