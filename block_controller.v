`timescale 1ns / 1ps

module block_controller(
    input clk, 
    input bright,
    input rst,
    input up, input down, input left, input right,
    input [9:0] hCount, vCount,
    output reg [11:0] rgb,
    output reg [11:0] background,
    output reg [9:0] xpos1, ypos1
);

    wire block_fill;


    wire [4:0] rom_row;   
    wire [4:0] rom_col;   
    wire [11:0] rom_rgb;


    flappy_rom flappy_icon_rom (
        .clk(clk), 
        .row(rom_row), 
        .col(rom_col), 
        .color_data(rom_rgb)
    );


    assign rom_row =vCount - ypos1 + 30; ; // Adjust for the icon's vertical position
    assign rom_col =hCount - xpos1 + 30; // Adjust for the icon's horizontal position


    assign block_fill = vCount >= (ypos1 - 30) && vCount < (ypos1 + 30) &&
                        hCount >= (xpos1 - 30) && hCount < (xpos1 + 30);


    always @ (*) begin
        if (~bright)
            rgb = 12'b0000_0000_0000;
        else if (block_fill)
            rgb = rom_rgb; 
        else
            rgb = background;
    end


    always @(posedge clk) begin
        if (rst) begin
            xpos1 <= 170; // Initial X position
            ypos1 <= 250; // Initial Y position
            background <= 12'b0000_1111_0000; // White background on reset
        end else begin
            // Adjust positions based on button inputs
            if (up && ypos1 > 15) 
                ypos1 <= ypos1 - 4;
            if (down && ypos1 < 480 - 15)
                 ypos1 <= ypos1 + 4;
        end
    end

    // The background color reflects the most recent button press
    //always @(posedge clk) begin
    //    if (rst) 
    //        background <= 12'b0000_0000_0000; // White background on reset
        // Additional logic for changing background on button presses can be added here if needed
   // end
    

endmodule

module block_controller2(
    input clk,
    input [3:0] level,
    input collision, // collision flag input
    input bright,
    input rst,
    input up, input down, input left, input right,
    input [9:0] hCount, vCount,
    output reg [11:0] rgb,
    output reg [11:0] background,
    output reg[9:0] xpos2, ypos2
);
    wire block_fill;

    parameter RED = 12'b1111_1101_0000;

    always @(*) begin
        if (block_fill)
            if ( collision) 
                rgb = 12'b1111_1111_1111; 
            else
                rgb = RED;
        else
            rgb = background;
    end

    assign block_fill = vCount >= (ypos2 - 10) && vCount <= (ypos2 + 10) && hCount >= (xpos2 - 10) && hCount <= (xpos2 + 10);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            xpos2 <= 700;
            ypos2 <= 250;
        end else if (clk) begin
            xpos2 <= xpos2 - (2+level);
        end
    end
	
	//the background color reflects the most recent button press
	//always@(posedge clk, posedge rst) begin
	//	if(rst)
	//		background <= 12'b1111_1111_1111;
	//end

	
	
endmodule


module block_controller3(
    input clk,
    input [3:0] level,
    input collision, // collision flag input
    input bright,
    input rst,
    input up, input down, input left, input right,
    input [9:0] hCount, vCount,
    output reg [11:0] rgb,
    output reg [11:0] background,
    output reg[9:0] xpos3, ypos3
);
    wire block_fill;

    parameter RED = 12'b1111_1101_0000;

    always @(*) begin
        if (block_fill)
            if ( collision) 
                rgb = 12'b1111_1111_1111; 
            else
                rgb = RED;
        else
            rgb = background;
    end

    assign block_fill = vCount >= (ypos3 - 10) && vCount <= (ypos3 + 10) && hCount >= (xpos3 - 10) && hCount <= (xpos3 + 10);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            xpos3 <= 700;
            ypos3 <= 400;
        end else if (clk) begin
            xpos3 <= xpos3 - (1+level);
        end
    end
	
	//the background color reflects the most recent button press
	//always@(posedge clk, posedge rst) begin
	//	if(rst)
	//		background <= 12'b1111_1111_1111;
	//end

	
	
endmodule


module block_controller4(
    input clk,
    input [3:0] level,
    input collision, // collision flag input
    input bright,
    input rst,
    input up, input down, input left, input right,
    input [9:0] hCount, vCount,
    output reg [11:0] rgb,
    output reg [11:0] background,
    output reg[9:0] xpos4, ypos4
);
    wire block_fill;

    parameter RED = 12'b1111_1101_0000;

    always @(*) begin
        if (block_fill)
            if ( collision) 
                rgb = 12'b1111_1111_1111; 
            else
                rgb = RED;
        else
            rgb = background;
    end

    assign block_fill = vCount >= (ypos4 - 5) && vCount <= (ypos4 + 5) && hCount >= (xpos4 - 5) && hCount <= (xpos4 + 5);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            xpos4 <= 700;
            ypos4 <= 600;
        end else if (clk) begin
            xpos4 <= xpos4 - (1+level);
        end
    end
	
	//the background color reflects the most recent button press
	//always@(posedge clk, posedge rst) begin
	//	if(rst)
	//		background <= 12'b1111_1111_1111;
	//end

	
	
endmodule

module block_controller5(
    input clk,
    input [3:0] level,
    input collision, // collision flag input
    input bright,
    input rst,
    input up, input down, input left, input right,
    input [9:0] hCount, vCount,
    output reg [11:0] rgb,
    output reg [11:0] background,
    output reg[9:0] xpos5, ypos5
);
    wire block_fill;

    parameter RED = 12'b1111_1101_0000;

    always @(*) begin
        if (block_fill)
            if (collision) 
                rgb = 12'b1111_1111_1111; 
            else
                rgb = RED;
        else
            rgb = background;
    end

    assign block_fill = vCount >= (ypos5 - 5) && vCount <= (ypos5 + 5) && hCount >= (xpos5 - 5) && hCount <= (xpos5 + 5);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            xpos5 <= 700;
            ypos5 <= 700;
        end else if (clk) begin
            xpos5 <= xpos5 - (1+level);
        end
    end
	
	//the background color reflects the most recent button press
	//always@(posedge clk, posedge rst) begin
	//	if(rst)
	//		background <= 12'b1111_1111_1111;
	//end

	
	
endmodule
