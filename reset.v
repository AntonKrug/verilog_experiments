module resetGenerator(input clk, input pll_locked, output rst);

	reg [7:0] resetstate = 0;
	reg rst = 1;

	always @(posedge clk) begin
		resetstate <= pll_locked ? (resetstate + 1) : 0;
        if (resetstate == 255) rst <= 0;
	end
	
endmodule