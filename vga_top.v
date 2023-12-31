`timescale 1ns / 1ps

module vga_top(
	input ClkPort,
	input BtnC,
	input BtnU,
	input BtnR,
	input BtnL,
	input BtnD,
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	output MemOE, MemWR, RamCS, QuadSpiFlashCS
	);
	wire Reset;
	assign Reset=BtnC;
	wire bright;
	wire[9:0] hc, vc;
	wire[15:0] score;
	wire up,down,left,right;
	wire [3:0] anode;
	wire [11:0] rgb,rgb1,rgb2,rgb3,rgb4;
	wire rst;
	
	reg [3:0]	SSD;
	wire [9:0] sc_xpos;
	wire [9:0] sc_ypos;
	wire [9:0] sc2_xpos;
	wire [9:0] sc2_ypos;
	wire [9:0] sc3_xpos;
	wire [9:0] sc3_ypos;
	wire [9:0] sc4_xpos;
	wire [9:0] sc4_ypos;
	wire [9:0] sc5_xpos;
	wire [9:0] sc5_ypos;
	reg collision_flag = 0;
	reg [3:0] level_counter = 0; 
	reg[3:0] collision_counter=0;
	wire [7:0]	SSD7,SSD6, SSD5, SSD4,SSD3, SSD2, SSD1, SSD0;
	reg [7:0]  	SSD_CATHODES;
	wire [3:0] level_counter_wire = level_counter;
	wire [1:0] 	ssdscan_clk;
	
	reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	wire move_clk;
	assign move_clk=DIV_CLK[19]; //slower clock to drive the movement of objects on the vga screen
	wire [11:0] background,background1;
	display_controller dc(.clk(ClkPort),.hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	block_controller sc(.clk(move_clk), .bright(bright), .rst(BtnC), .up(BtnU), .down(BtnD),.left(BtnL),.right(BtnR),.hCount(hc), .vCount(vc), .rgb(rgb), .background(background),.xpos1(sc_xpos),.ypos1(sc_ypos));
	block_controller2 sc2(.clk(move_clk),.level(level_counter_wire),.collision(collision_flag), .bright(bright), .rst(BtnC), .up(BtnU), .down(BtnD),.left(BtnL),.right(BtnR),.hCount(hc), .vCount(vc), .rgb(rgb1), .background(background1),.xpos2(sc2_xpos),.ypos2(sc2_ypos));
	block_controller3 sc3(.clk(move_clk),.level(level_counter_wire),.collision(collision_flag), .bright(bright), .rst(BtnC), .up(BtnU), .down(BtnD),.left(BtnL),.right(BtnR),.hCount(hc), .vCount(vc), .rgb(rgb2), .background(background2),.xpos3(sc3_xpos),.ypos3(sc3_ypos));
	block_controller4 sc4(.clk(move_clk),.level(level_counter_wire),.collision(collision_flag), .bright(bright), .rst(BtnC), .up(BtnU), .down(BtnD),.left(BtnL),.right(BtnR),.hCount(hc), .vCount(vc), .rgb(rgb3), .background(background3),.xpos4(sc4_xpos),.ypos4(sc4_ypos));
	block_controller5 sc5(.clk(move_clk),.level(level_counter_wire),.collision(collision_flag), .bright(bright), .rst(BtnC), .up(BtnU), .down(BtnD),.left(BtnL),.right(BtnR),.hCount(hc), .vCount(vc), .rgb(rgb4), .background(background4),.xpos5(sc5_xpos),.ypos5(sc5_ypos));
	function block_collision;
        input [9:0] xpos1, ypos1, xpos2, ypos2;
        begin
            block_collision = ((xpos1 >= xpos2-10) && (xpos1 <= xpos2+10) &&
                               (ypos1 >= ypos2-10) && (ypos1 <= ypos2+10));
        end
    endfunction
    reg [11:0] frgb;
        // Collision detection and counter logic
        
always @(posedge ClkPort) begin
    if (Reset) begin
        collision_counter <= 0;
        level_counter <= 0;
        collision_flag <= 0;
    end else if (block_collision(sc_xpos, sc_ypos, sc2_xpos, sc2_ypos) ||
                 block_collision(sc_xpos, sc_ypos, sc3_xpos, sc3_ypos) ||
                 block_collision(sc_xpos, sc_ypos, sc4_xpos, sc4_ypos) ||
                 block_collision(sc_xpos, sc_ypos, sc5_xpos, sc5_ypos)) 
    begin
        if (!collision_flag) begin
            collision_flag <= 1;
            if (collision_counter < 3) begin
                collision_counter <= collision_counter + 1;
            end else begin
                collision_counter <= 0;
                level_counter <= level_counter + 1;
            end
        end
    end else begin
        collision_flag <= 0; // Reset flag when no collision is detected
    end
end


    reg [11:0] rgb_reg; 
    always @(posedge ClkPort) begin
        if (collision_flag) begin
            rgb_reg <= 12'b1111_1111_0000; // Color on collision
        end else if (rgb1 != background1) begin
            rgb_reg <= rgb1; // Display block_controller2's block
        end else if (rgb2 != background2) begin
            rgb_reg <= rgb2; // Display block_controller2's block
        end else if (rgb3 != background3) begin
            rgb_reg <= rgb3; // Display block_controller2's block
        end else if (rgb4 != background4) begin
            rgb_reg <= rgb4; // Display block_controller2's block            
        end else begin
            rgb_reg <= rgb; // Display block_controller's block
        end
    end

    assign vgaR = rgb_reg[11 : 8];
    assign vgaG = rgb_reg[7  : 4];
    assign vgaB = rgb_reg[3  : 0];
	
	
	// disable mamory ports
	assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;
	
	//------------
// SSD (Seven Segment Display)
	// reg [3:0]	SSD;
	// wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	
	//SSDs display 
	//to show how we can interface our "game" module with the SSD's, we output the 12-bit rgb background value to the SSD's
	assign SSD3 = 4'b0000;
	assign SSD2 = background[11:8];
	assign SSD1 = background[7:4];
	assign SSD0 = background[3:0];
	


	assign ssdscan_clk = DIV_CLK[19:18];
	assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1	= !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2	=  !((ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3	=  !((ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	// Turn off another 4 anodes
	assign {An7, An6, An5, An4} = 4'b1111;
	
	always @ (ssdscan_clk,collision_counter, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
				  2'b00: SSD = collision_counter;
				  2'b01: SSD = level_counter;
				  2'b10: SSD = SSD2;
				  2'b11: SSD = SSD3;
		endcase 
	end

	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD) // in this solution file the dot points are made to glow by making Dp = 0
		    //                                                                abcdefg,Dp
			4'b0000: SSD_CATHODES = 8'b00000010; // 0
			4'b0001: SSD_CATHODES = 8'b10011110; // 1
			4'b0010: SSD_CATHODES = 8'b00100100; // 2
			4'b0011: SSD_CATHODES = 8'b00001100; // 3
			4'b0100: SSD_CATHODES = 8'b10011000; // 4
			4'b0101: SSD_CATHODES = 8'b01001000; // 5
			4'b0110: SSD_CATHODES = 8'b01000000; // 6
			4'b0111: SSD_CATHODES = 8'b00011110; // 7
			4'b1000: SSD_CATHODES = 8'b00000000; // 8
			4'b1001: SSD_CATHODES = 8'b00001000; // 9
			4'b1010: SSD_CATHODES = 8'b00010000; // A
			4'b1011: SSD_CATHODES = 8'b11000000; // B
			4'b1100: SSD_CATHODES = 8'b01100010; // C
			4'b1101: SSD_CATHODES = 8'b10000100; // D
			4'b1110: SSD_CATHODES = 8'b01100000; // E
			4'b1111: SSD_CATHODES = 8'b01110000; // F    
			default: SSD_CATHODES = 8'bXXXXXXXX; // default is not needed as we covered all cases
		endcase
	end	
	
	// reg [7:0]  SSD_CATHODES;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES};

endmodule
