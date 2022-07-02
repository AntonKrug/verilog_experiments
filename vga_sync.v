module vga_sync(clk, rst, hsync, vsync, displayOn, x, y);
    input clk;
    input rst;
    output reg hsync, vsync;
    output displayOn;
    output reg [10:0] x;
    output reg [9:0] y;

    // https://www.epanorama.net/faq/vga2rgb/calc.html
    // using VESA 800x600 60Hz with 40MHz pixel clock
    // other resources:
    // https://tomverbeure.github.io/video_timings_calculator
    // https://projectf.io/posts/video-timings-vga-720p-1080p

    localparam H_BACK    = 88;
    localparam H_DISPLAY = 800;
    localparam H_FRONT   = 40;
    localparam H_SYNC    = 128;

    localparam V_SYNC    = 4;
    localparam V_BACK    = 23;
    localparam V_DISPLAY = 600;
    localparam V_FRONT   = 1;

    localparam H_SYNC_START = H_DISPLAY + H_FRONT;
    localparam H_SYNC_END   = H_DISPLAY + H_FRONT + H_SYNC -1;
    localparam H_MAX        = H_DISPLAY + H_FRONT + H_SYNC + H_BACK -1;  // 1055

    localparam V_SYNC_START = V_DISPLAY + V_FRONT;
    localparam V_SYNC_END   = V_DISPLAY + V_FRONT + V_SYNC -1;
    localparam V_MAX        = V_DISPLAY + V_FRONT + V_SYNC + V_BACK -1; // 627


    // HSYNC
    wire xmaxxed = (x == H_MAX) || rst;

    always @(posedge clk) begin
        hsync <= (x >= H_SYNC_START) && (x <= H_SYNC_END);
        if (xmaxxed)
            x <= 0;
        else
            x <= x + 1;
    end


    // VSYNC
    wire ymaxxed = (y == V_MAX) || rst;

    always @(posedge clk) begin
        vsync <= (y >= V_SYNC_START) && (y <= V_SYNC_END);
        if (xmaxxed) begin
            if (ymaxxed)
                y <= 0;
            else
                y <= y + 1;
        end
    end

    // Visible section of display
    assign displayOn = (x<H_DISPLAY) && (y<V_DISPLAY);

endmodule