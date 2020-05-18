//Inna wersja wczytania pliku 
module file_reader 
#(
//Ile wczytamy z pliku, 8 bo %pdf%pdf to 8 par hexow
	parameter N = 8
)

(
input clk,
	output [63:0] read,
	output reg done
);

	reg [7:0] mem[N-1:0];
	reg [63:0] x;
		integer i=0;


initial 
begin 
  //Nazwa pliczku z którego czytamy, trzeba go załadować do projektu tak jak zwykły plik veriloga
  
	$readmemh("cipher.txt", mem);
	
	
	$display("%p", mem);
	
end

always@(posedge clk) begin
if (i < N)
x<={x[55:0],mem[i]};
i=i+1;
if (i == 8)
done <= 1'b1;

end
assign read = x;


endmodule
