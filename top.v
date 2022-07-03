`include "pll.v"
`include "reset.v"
`include "vga_sync.v"
`include "blinky.v"
`include "font.v"

module top (input clk_100mhz, output reg [2:0]led, output [7:0]p4);

	// Clock Generator
	wire clk, pll_locked;
	pll myPll(.clock_in(clk_100mhz),  .clock_out(clk), .locked(pll_locked));

	// Reset Generator
	wire rst;
	resetGenerator myRst(.clk(clk), .pll_locked(pll_locked), .rst(rst));

	// LED 1Hz blink
	// blinky myBlinky(.clk(clk), .rst(rst), .led(led[0]));

	// VGA
	// https://www.servicesparepart.com/wp-content/uploads/2017/09/vga-db-15-pinout-schematic-diagram.jpg
	wire hsync,vsync,displayOn;
	wire [9:0]x;
	wire [8:0]y;
	vga_sync myVgaSync(.clk(clk), .rst(rst), .hsync(hsync), .vsync(vsync), .displayOn(displayOn), .screenX(x), .screenY(y));

	// Read small font ROM
	wire [6:0] textX = x[8:2];  // 400 pix / 4pix font = 100 colums (7-bit value)
	wire [5:0] textY = y[8:3];  // 300 pix / 8pix font = 37.5 rows = 37 rows (6-bit value)
	wire [3:0] character = textX[3:0] + textY[3:0]; // select what character to display
	wire pixel; // display black or white
	wire displayText = textX>5 && textX<35 && textY>10 && textY<20; // when to render font and when not render anything
	font myFont(.character(character), .x(x[1:0]), .y(y[2:0]), .pixel(pixel));

	// Map VGA signals to PMOD adapter with VGA connector
	assign p4[0] = hsync;
	assign p4[1] = vsync;
	assign p4[2] = pixel & displayText;
	assign p4[4] = pixel & displayText;
	assign p4[6] = pixel & displayText;

endmodule
