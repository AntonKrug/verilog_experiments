`include "pll.v"
`include "reset.v"
`include "vga_sync.v"
`include "blinky.v"

module top (input clk_100mhz, output reg [2:0]led, output [7:0]p4);

	// Clock Generator
	wire clk, pll_locked;
	pll myPll(.clock_in(clk_100mhz),  .clock_out(clk), .locked(pll_locked));

	// Reset Generator
	wire rst;
	resetGenerator myRst(.clk(clk), .pll_locked(pll_locked), .rst(rst));

	// LED 1Hz blink
	blinky myBlinky(.clk(clk), .rst(rst), .led(led[0]));

	// VGA
	// https://www.servicesparepart.com/wp-content/uploads/2017/09/vga-db-15-pinout-schematic-diagram.jpg
	wire hsync,vsync,displayOn;
	wire [10:0]x;
	wire [9:0]y;
	vga_sync myVgaSync(.clk(clk), .rst(rst), .hsync(hsync), .vsync(vsync), .displayOn(displayOn), .x(x), .y(y));

	// Map VGA signals to PMOD adapter with VGA connector
	assign p4[0] = hsync;
	assign p4[1] = vsync;
	assign p4[2] = displayOn && y[5];                             // Blue
	assign p4[4] = displayOn && ( ((x&7) == 0) || ((y&7)==0) );   // Green
	assign p4[6] = displayOn && x[5];                             // Red


endmodule
