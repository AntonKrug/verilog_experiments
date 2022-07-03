module font(input [3:0]character, input [1:0]x, input [2:0]y, output pixel);
	reg [3:0] fontRom [0:15][0:7];
	initial $readmemb("small_font.dat", fontRom);
	
	wire [3:0] fontLine;

	assign fontLine = fontRom[character][y];
	assign pixel = fontLine[x[1:0]];
endmodule