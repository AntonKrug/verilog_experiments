module blinky(input clk, input rst, output led);
    reg led;
	reg [24:0] prescaler = 0;

	localparam [24:0] prescaler_max   = 20000000; // 40MHz clk with 20M counter

	always @(posedge clk) begin
		if (rst) begin
			led <= 0;
			prescaler <= 0;
		end else begin
			prescaler <= prescaler + 1;
			if (prescaler == prescaler_max) begin
				prescaler <= 0;
				led <= ~led;
			end
		end
	end

endmodule