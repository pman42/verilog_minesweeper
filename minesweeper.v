
module minesweeper (LEDR, KEY, SW, CLOCK_50, PS2_DAT, PS2_CLK, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, 
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							
		VGA_VS,							
		VGA_BLANK_N,						
		VGA_SYNC_N,						
		VGA_R,   						
		VGA_G,	 						
		VGA_B);
	
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;	
		
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	
	input [3:0] KEY;
	input [9:0] SW;
	input CLOCK_50;
	input PS2_DAT; // PS2 data line
   input PS2_CLK; // PS2 clock line
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	// Cursor position variables
	wire [2:0] select_row, select_column;
	wire [6:0] select_column_num = select_column * 4;
	wire [5:0] position = {select_row, select_column};
	
	// Mine positions
	wire [0:63] mine_grid;
	
	// Wires used to connect rows
	wire [0:7] mines_1 = mine_grid[0:7];
	wire [0:7] mines_2 = mine_grid[8:15];
	wire [0:7] mines_3 = mine_grid[16:23];
	wire [0:7] mines_4 = mine_grid[24:31];
	wire [0:7] mines_5 = mine_grid[32:39];
	wire [0:7] mines_6 = mine_grid[40:47];
	wire [0:7] mines_7 = mine_grid[48:55];
	wire [0:7] mines_8 = mine_grid[56:63];
	reg user_click_1, user_click_2, user_click_3, user_click_4, 
		  user_click_5, user_click_6, user_click_7, user_click_8;
	reg user_flag_1, user_flag_2, user_flag_3, user_flag_4, 
		  user_flag_5, user_flag_6, user_flag_7, user_flag_8;
	reg [2:0] click_position_1, click_position_2, click_position_3, click_position_4, 
				  click_position_5, click_position_6, click_position_7, click_position_8;
	wire [0:7] clicked_1, clicked_2, clicked_3, clicked_4, clicked_5, clicked_6, clicked_7, clicked_8;
	wire [0:7] flags_1, flags_2, flags_3, flags_4, flags_5, flags_6, flags_7, flags_8;
	wire [0:31] nums_1, nums_2, nums_3, nums_4, nums_5, nums_6, nums_7, nums_8;
	wire row_won_1, row_won_2, row_won_3, row_won_4, row_won_5, row_won_6, row_won_7, row_won_8;
	wire row_lost_1, row_lost_2, row_lost_3, row_lost_4, row_lost_5, row_lost_6, row_lost_7, row_lost_8;
	
	
	// Connect to keyboard
	wire valid, makeBreak;
	assign LEDR[8] = valid;
	assign LEDR[9] = makeBreak;
	wire [7:0] outCode;
	keyboard_press_driver keyboard(
		.valid(valid),
		.makeBreak(makeBreak),
		.outCode(outCode),
		.CLOCK_50(CLOCK_50),
		.PS2_DAT(PS2_DAT),
		.PS2_CLK(PS2_CLK),
		.reset(0)
		);
	
	// Game variables
	wire reset, playing, en_mine_gen, run_clock, compare_hs;
	// Inputs to controller
	
	
	wire click = (valid & makeBreak & outCode == 8'b00101001); //Space bar: 29
	wire flag = (valid & makeBreak & outCode == 8'b00101011); //f: 2b
	wire start = (valid & makeBreak & outCode == 8'b01011010); //Enter: 5A
	wire control_reset = ~(valid & makeBreak & outCode == 8'b00101101); //r: 2d
	
	/**
	wire click = ~KEY[0]; 
	wire flag = ~KEY[1]; 
	wire start = ~KEY[2]; 
	wire control_reset = KEY[3]; 
	**/
	
	wire game_won = (row_won_1 & row_won_2 & row_won_3 & row_won_4 &
						  row_won_5 & row_won_6 & row_won_7 & row_won_8);
	wire game_lost = (row_lost_1 | row_lost_2 | row_lost_3 | row_lost_4 |
						  row_lost_5 | row_lost_6 | row_lost_7 | row_lost_8);
	assign LEDR[3] = game_lost;
	assign LEDR[4] = reset;
	assign LEDR[5] = playing;
	assign LEDR[6] = en_mine_gen;
	assign LEDR[7] = run_clock;	
	
	
	
	//VGA
	vga_adapter VGA(
			.resetn(1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			//Signals for the DAC to drive the monitor.
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
	
	
	//Create grids
	wire [0:63] clicked_grid = {clicked_1, clicked_2, clicked_3, clicked_4, clicked_5, clicked_6, clicked_7, clicked_8};
	wire [0:63] flagged_grid = {flags_1, flags_2, flags_3, flags_4, flags_5, flags_6, flags_7, flags_8};
	wire [2:0] select_smiley = {game_won, game_lost};
	//DATAPATH
	ms_datapath d1(
    	.clk(CLOCK_50),
    	.in_mines(mine_grid),
    	.in_clicked(clicked_grid),
    	.in_flagged(flagged_grid),
		.nums_1(nums_1),
		.nums_2(nums_2),
		.nums_3(nums_3),
		.nums_4(nums_4),
		.nums_5(nums_5),
		.nums_6(nums_6), 
		.nums_7(nums_7),
		.nums_8(nums_8),
		.smiley_select(select_smiley),
    	.position_x(select_column),
    	.position_y(select_row),
    	.out_color(colour),
    	.resetn(control_reset),
    	.x_out(x),
    	.y_out(y)
    );
	
	
	
	// Control of game: sends necessary signals
	minesweeper_control control(
		.clk(CLOCK_50),
		.go(start),
		.is_win(game_won),
		.is_loss(game_lost),
		.reset_in(control_reset),
		.reset_out(reset),
		.enable_mine_generation(en_mine_gen),
		.enable_vga(writeEn),
		.playing(playing),
		.clock_run(run_clock),
		.compare_high_score(compare_hs)
		);
	
	// Move the cursor: change select_column and select_row
	wire [3:0] keys = {(valid & makeBreak & outCode == 8'b01110100), //Right
							 (valid & makeBreak & outCode == 8'b01101011), //Left
							 (valid & makeBreak & outCode == 8'b01110010), //Down
							 (valid & makeBreak & outCode == 8'b01110101)}; //Up
	traversal t1(
		.input_keys(keys),
		//.signal(SW[0]),
		.rst(reset),
		.clk(CLOCK_50),
		.x(select_column),
		.y(select_row)
	);
	
	
	// Send click signals to rows
	reg clicked, flagged, is_mine;
	reg [0:3] curr_num;
	assign LEDR[0] = clicked;
	assign LEDR[1] = flagged;
	assign LEDR[2] = is_mine;
	
	always @(*)
    begin 

		user_click_1 =  1'b0;
		user_click_2 =  1'b0;
		user_click_3 =  1'b0;
		user_click_4 =  1'b0;
		user_click_5 =  1'b0;
		user_click_6 =  1'b0;
		user_click_7 =  1'b0;
		user_click_8 =  1'b0;
		
		user_flag_1 =  1'b0;
		user_flag_2 =  1'b0;
		user_flag_3 =  1'b0;
		user_flag_4 =  1'b0;
		user_flag_5 =  1'b0;
		user_flag_6 =  1'b0;
		user_flag_7 =  1'b0;
		user_flag_8 =  1'b0;

		case (select_row)
			3'b000: begin
				user_click_1 = click;
				user_flag_1 = flag;
				click_position_1 = select_column; 
				clicked = clicked_1[select_column];
				flagged = flags_1[select_column];
				is_mine = mines_1[select_column];
				curr_num[0] = nums_1[select_column_num];
				curr_num[1] = nums_1[select_column_num+1];
				curr_num[2] = nums_1[select_column_num+2];
				curr_num[3] = nums_1[select_column_num+3];
				
				end
			3'b001: begin
				user_click_2 = click;
				user_flag_2 = flag;
				click_position_2 = select_column; 
				clicked = clicked_2[select_column];
				flagged = flags_2[select_column];
				is_mine = mines_2[select_column];
				curr_num[0] = nums_2[select_column_num];
				curr_num[1] = nums_2[select_column_num+1];
				curr_num[2] = nums_2[select_column_num+2];
				curr_num[3] = nums_2[select_column_num+3];
				end
			3'b010: begin
				user_click_3 = click;
				user_flag_3 = flag;
				click_position_3 = select_column; 
				clicked = clicked_3[select_column];
				flagged = flags_3[select_column];
				is_mine = mines_3[select_column];
				curr_num[0] = nums_3[select_column_num];
				curr_num[1] = nums_3[select_column_num+1];
				curr_num[2] = nums_3[select_column_num+2];
				curr_num[3] = nums_3[select_column_num+3];
				end
			3'b011: begin
				user_click_4 = click;
				user_flag_4 = flag;
				click_position_4 = select_column; 
				clicked = clicked_4[select_column];
				flagged = flags_4[select_column];
				is_mine = mines_4[select_column];
				curr_num[0] = nums_4[select_column_num];
				curr_num[1] = nums_4[select_column_num+1];
				curr_num[2] = nums_4[select_column_num+2];
				curr_num[3] = nums_4[select_column_num+3];
				end
			3'b100: begin
				user_click_5 = click;
				user_flag_5 = flag;
				click_position_5 = select_column; 
				clicked = clicked_5[select_column];
				flagged = flags_5[select_column];
				is_mine = mines_5[select_column];
				curr_num[0] = nums_5[select_column_num];
				curr_num[1] = nums_5[select_column_num+1];
				curr_num[2] = nums_5[select_column_num+2];
				curr_num[3] = nums_5[select_column_num+3];
				end
			3'b101: begin
				user_click_6 = click;
				user_flag_6 = flag;
				click_position_6 = select_column;
				clicked = clicked_6[select_column];
				flagged = flags_6[select_column];
				is_mine = mines_6[select_column];
				curr_num[0] = nums_6[select_column_num];
				curr_num[1] = nums_6[select_column_num+1];
				curr_num[2] = nums_6[select_column_num+2];
				curr_num[3] = nums_6[select_column_num+3];
				end
			3'b110: begin
				user_click_7 = click;
				user_flag_7 = flag;
				click_position_7 = select_column; 
				clicked = clicked_7[select_column];
				flagged = flags_7[select_column];
				is_mine = mines_7[select_column];
				curr_num[0] = nums_7[select_column_num];
				curr_num[1] = nums_7[select_column_num+1];
				curr_num[2] = nums_7[select_column_num+2];
				curr_num[3] = nums_7[select_column_num+3];
				end
			3'b111: begin
				user_click_8 = click;
				user_flag_8 = flag;
				click_position_8 = select_column; 
				clicked = clicked_8[select_column];
				flagged = flags_8[select_column];
				is_mine = mines_8[select_column];
				curr_num[0] = nums_8[select_column_num];
				curr_num[1] = nums_8[select_column_num+1];
				curr_num[2] = nums_8[select_column_num+2];
				curr_num[3] = nums_8[select_column_num+3];
				end
            
        endcase        
    end 
	 
	// Random counter used to initialize mines
	reg [26:0] random_counter = 27'b100110111011001010101010001;	
	always @(posedge CLOCK_50)
	begin
		random_counter = random_counter + 1;
	end
	
	// Create mines on pos edge of enable
	create_mines mine_set(
		.enable(en_mine_gen),
		.rst(reset),
		.clk(CLOCK_50),
		.rand(random_counter),
		.out_array(mine_grid)
	);
	
	// Increase time when run_clock==1 (and reset!=0)
	// Update high score when compare_hs signal comes
	reg [26:0] counter;
	reg [6:0] current_sec, high_score_sec;
	reg [3:0] current_min, high_score_min;
	
	initial begin
		current_sec = 0;
		current_min = 0;
		high_score_sec = 59;
		high_score_min = 9;
	end
	
	always @(posedge CLOCK_50) begin
	
		if (control_reset==0) begin
			high_score_sec <= 59;
			high_score_min <= 9;
		end
		if (compare_hs == 1) begin
			if (current_min < high_score_min | (current_min == high_score_min & current_sec < high_score_sec)) begin
				high_score_sec <= current_sec;
				high_score_min <= current_min;
			end
		end
		
		if (reset==0 | control_reset==0) begin
			counter <= 0;
			current_sec <= 0;
			current_min <= 0;
		end else begin
			if (run_clock==1 & current_min!=9) begin
				if (current_sec == 60) begin
					counter <= 0;
					current_sec <= 0;
					current_min <= current_min + 1;
				end else begin
					if (counter==50000000) begin
						counter <= 0;
						current_sec <= current_sec + 1;
					end else begin
						counter <= counter + 1;
					end
				end
			end
		end
	end
				

	// Initialize rows with appropriate connections
	row r1(
		.clicked(clicked_1),
		.nums(nums_1),
		.flags(flags_1),
		.row_won(row_won_1),
		.row_lost(row_lost_1),
		.reset(reset & control_reset),
		.playing(playing),
		.init_mines(mines_1),
		.user_click(user_click_1),
		.user_flag(user_flag_1),	
		.click_position(click_position_1),
		.mines_above(8'b00000000),
		.mines_below(mines_2),
		.clicked_above(8'b00000000),
		.clicked_below(clicked_2),
		.nums_above(32'b00000000000000000000000000000000),
		.nums_below(nums_2),
		.clk(CLOCK_50)
		);
		
	row r2(
		.clicked(clicked_2),
		.nums(nums_2),
		.flags(flags_2),
		.row_won(row_won_2),
		.row_lost(row_lost_2),
		.reset(reset & control_reset),
		.playing(playing),
		.init_mines(mines_2),
		.user_click(user_click_2),
		.user_flag(user_flag_2),
		.click_position(click_position_2),	
		.mines_above(mines_1),
		.mines_below(mines_3),
		.clicked_above(clicked_1),
		.clicked_below(clicked_3),
		.nums_above(nums_1),
		.nums_below(nums_3),
		.clk(CLOCK_50)
		);
		
	row r3(
		.clicked(clicked_3),
		.nums(nums_3),
		.flags(flags_3),
		.row_won(row_won_3),
		.row_lost(row_lost_3),
		.reset(reset & control_reset),
		.playing(playing),
		.init_mines(mines_3),
		.user_click(user_click_3), 
		.user_flag(user_flag_3),
		.click_position(click_position_3),
		.mines_above(mines_2),
		.mines_below(mines_4),
		.clicked_above(clicked_2),
		.clicked_below(clicked_4),
		.nums_above(nums_2),
		.nums_below(nums_4),
		.clk(CLOCK_50)
		);
		
	row r4(
		.clicked(clicked_4),
		.nums(nums_4),
		.flags(flags_4),
		.row_won(row_won_4),
		.row_lost(row_lost_4),
		.reset(reset & control_reset),
		.playing(playing),
		.init_mines(mines_4),
		.user_click(user_click_4), 
		.user_flag(user_flag_4),
		.click_position(click_position_4),
		.mines_above(mines_3),
		.mines_below(mines_5),
		.clicked_above(clicked_3),
		.clicked_below(clicked_5),
		.nums_above(nums_3),
		.nums_below(nums_5),
		.clk(CLOCK_50)
		);
		
	row r5(
		.clicked(clicked_5),
		.nums(nums_5),
		.flags(flags_5),
		.row_won(row_won_5),
		.row_lost(row_lost_5),
		.reset(reset & control_reset),
		.playing(playing),
		.init_mines(mines_5),
		.user_click(user_click_5), 
		.user_flag(user_flag_5),
		.click_position(click_position_5),
		.mines_above(mines_4),
		.mines_below(mines_6),
		.clicked_above(clicked_4),
		.clicked_below(clicked_6),
		.nums_above(nums_4),
		.nums_below(nums_6),
		.clk(CLOCK_50)
		);
		
	row r6(
		.clicked(clicked_6),
		.nums(nums_6),
		.flags(flags_6),
		.row_won(row_won_6),
		.row_lost(row_lost_6),
		.reset(reset & control_reset),
		.playing(playing),
		.init_mines(mines_6),
		.user_click(user_click_6), 
		.user_flag(user_flag_6),
		.click_position(click_position_6),
		.mines_above(mines_5),
		.mines_below(mines_7),
		.clicked_above(clicked_5),
		.clicked_below(clicked_7),
		.nums_above(nums_5),
		.nums_below(nums_7),
		.clk(CLOCK_50)
		);
		
	row r7(
		.clicked(clicked_7),
		.nums(nums_7),
		.flags(flags_7),
		.row_won(row_won_7),
		.row_lost(row_lost_7),
		.reset(reset & control_reset),
		.playing(playing),
		.init_mines(mines_7),
		.user_click(user_click_7), 
		.user_flag(user_flag_7),
		.click_position(click_position_7),
		.mines_above(mines_6),
		.mines_below(mines_8),
		.clicked_above(clicked_6),
		.clicked_below(clicked_8),
		.nums_above(nums_6),
		.nums_below(nums_8),
		.clk(CLOCK_50)
		);
		
	row r8(
		.clicked(clicked_8),
		.nums(nums_8),
		.flags(flags_8),
		.row_won(row_won_8),
		.row_lost(row_lost_8),
		.reset(reset & control_reset),
		.playing(playing),
		.init_mines(mines_8),
		.user_click(user_click_8),
		.user_flag(user_flag_8),	
		.click_position(click_position_8),
		.mines_above(mines_7),
		.mines_below(8'b00000000),
		.clicked_above(clicked_7),
		.clicked_below(8'b00000000),
		.nums_above(nums_7),
		.nums_below(32'b00000000000000000000000000000000),
		.clk(CLOCK_50)
		);
		
	// Display HEX: current time and highscore
	
	wire [3:0] current_time_1 = current_sec % 10;
	wire [3:0] current_time_2 = (current_sec - (current_sec % 10)) / 10;
	
	wire [3:0] high_score_1 = high_score_sec % 10;
	wire [3:0] high_score_2 = (high_score_sec - (high_score_sec % 10)) / 10;
	
	dec_decoder dex0(
		.dec_digit(current_time_1),
		.segments(HEX0)
		);
	
	dec_decoder dex1(
		.dec_digit(current_time_2),
		.segments(HEX1)
		);
		
	dec_decoder dec_2(
		.dec_digit(current_min),
		.segments(HEX2)
		);
		
	dec_decoder dec3(
		.dec_digit(high_score_1),
		.segments(HEX3)
		);
	dec_decoder dec4(
		.dec_digit(high_score_2),
		.segments(HEX4)
		);
	dec_decoder dec5(
		.dec_digit(high_score_min),
		.segments(HEX5)
		);

endmodule

module dec_decoder(dec_digit, segments);
    input [3:0] dec_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (dec_digit)
            4'b0000: segments = 7'b1000000;
            4'b0001: segments = 7'b1111001;
            4'b0010: segments = 7'b0100100;
            4'b0011: segments = 7'b0110000;
            4'b0100: segments = 7'b0011001;
            4'b0101: segments = 7'b0010010;
            4'b0110: segments = 7'b0000010;
            4'b0111: segments = 7'b1111000;
            4'b1000: segments = 7'b0000000;
            4'b1001: segments = 7'b0011000;   
            default: segments = 7'b1000000;
        endcase
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
