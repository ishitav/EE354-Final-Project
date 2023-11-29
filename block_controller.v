module block_controller(
    input clk, // Clock for controlling the movement of the icon
    input bright,
    input rst,
    input up, input down, input left, input right,
    input [9:0] hCount, vCount,
    output reg [11:0] rgb,
    output reg [11:0] background
);

    // Parameters for the icon
    localparam ICON_WIDTH = 32;  // Width of the icon
    localparam ICON_HEIGHT = 32; // Height of the icon
    localparam INITIAL_XPOS = 450; // Initial X position of the icon's center
    localparam INITIAL_YPOS = 250; // Initial Y position of the icon's center

    // Offsets to align the center of the icon with xpos, ypos
    localparam ICON_OFFSET_X = INITIAL_XPOS - (ICON_WIDTH / 2);
    localparam ICON_OFFSET_Y = INITIAL_YPOS - (ICON_HEIGHT / 2);

    // Current position of the icon
    reg [9:0] xpos, ypos;

    // Flappy Icon ROM interface
    wire [4:0] icon_row;   // Assuming 5 bits for 32 rows (0 to 31)
    wire [4:0] icon_col;   // Assuming 5 bits for 32 columns (0 to 31)
    wire [11:0] icon_rgb;

    // Instantiate your flappy_12_bit_rom
    flappy_12_bit_rom flappy_icon_rom (
        .clk(clk), 
        .row(icon_row), 
        .col(icon_col), 
        .color_data(icon_rgb)
    );

    // Logic to map xpos, ypos to ROM row and column
    assign icon_row = ypos - ICON_OFFSET_Y;
    assign icon_col = xpos - ICON_OFFSET_X;

    // Determine if current pixel is part of the icon
    wire icon_fill;
    assign icon_fill = vCount >= (ypos - ICON_HEIGHT/2) && vCount < (ypos + ICON_HEIGHT/2) &&
                       hCount >= (xpos - ICON_WIDTH/2)  && hCount < (xpos + ICON_WIDTH/2);

    // RGB output logic
    always@ (*) begin
        if(~bright)
            rgb = 12'b0000_0000_0000;
        else if(icon_fill)
            rgb = icon_rgb; // Use data from flappy_12_bit_rom
        else
            rgb = background;
    end

    // Logic to move the icon based on button inputs
    always@(posedge clk, posedge rst) begin
        if(rst) begin
            xpos <= INITIAL_XPOS;
            ypos <= INITIAL_YPOS;
            background <= 12'b1111_1111_1111; // White background on reset
        end else begin
            if(right && xpos < (800 - ICON_WIDTH/2)) xpos <= xpos + 2;
            else if(left && xpos > ICON_WIDTH/2) xpos <= xpos - 2;
            if(up && ypos > ICON_HEIGHT/2) ypos <= ypos - 2;
            else if(down && ypos < (480 - ICON_HEIGHT/2)) ypos <= ypos + 2;
        end
    end

    // Logic for updating background color based on button presses
    always@(posedge clk) begin
        if(right)
            background <= 12'b1111_1111_0000; // Yellow
        else if(left)
            background <= 12'b0000_1111_1111; // Cyan
        else if(up)
            background <= 12'b0000_0000_1111; // Blue
        else if(down)
            background <= 12'b0000_1111_0000; // Green
    end

endmodule
