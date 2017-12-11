
module row(clicked, nums, flags, row_won, row_lost, reset, playing, init_mines, user_click, user_flag, click_position,
			  clk, mines_above, mines_below, clicked_above, clicked_below, nums_above, nums_below);
			  
	input reset, clk, playing, user_click, user_flag;
	input [2:0] click_position;
	input [0:7] init_mines, mines_above, mines_below, clicked_above, clicked_below;
	input [0:31] nums_above, nums_below;
	
	output row_won, row_lost;
	output [0:7] clicked, flags;
	output [0:31] nums;
	
	wire [0:7] clicked_here, flagged_here, game_won_here, game_lost_here;
	assign clicked = clicked_here;
	assign flags = flagged_here;
	assign row_won = &game_won_here;
	assign row_lost = |game_lost_here;
	
	wire [0:3] nums_here_0, nums_here_1, nums_here_2, nums_here_3,
				 nums_here_4, nums_here_5, nums_here_6, nums_here_7;
	
	assign nums[0:3] = nums_here_0;
	assign nums[4:7] = nums_here_1;
	assign nums[8:11] = nums_here_2;
	assign nums[12:15] = nums_here_3;
	assign nums[16:19] = nums_here_4;
	assign nums[20:23] = nums_here_5;
	assign nums[24:27] = nums_here_6;
	assign nums[28:31] = nums_here_7;
	
	wire [0:3] nums_above_0 = nums_above[0:3];
	wire [0:3] nums_above_1 = nums_above[4:7];
	wire [0:3] nums_above_2 = nums_above[8:11];
	wire [0:3] nums_above_3 = nums_above[12:15];
	wire [0:3] nums_above_4 = nums_above[16:19];
	wire [0:3] nums_above_5 = nums_above[20:23];
	wire [0:3] nums_above_6 = nums_above[24:27];
	wire [0:3] nums_above_7 = nums_above[28:31];
	
	wire [0:3] nums_below_0 = nums_below[0:3];
	wire [0:3] nums_below_1 = nums_below[4:7];
	wire [0:3] nums_below_2 = nums_below[8:11];
	wire [0:3] nums_below_3 = nums_below[12:15];
	wire [0:3] nums_below_4 = nums_below[16:19];
	wire [0:3] nums_below_5 = nums_below[20:23];
	wire [0:3] nums_below_6 = nums_below[24:27];
	wire [0:3] nums_below_7 = nums_below[28:31];
	
	wire user_click_0 = (user_click & (click_position==0));
	wire user_click_1 = (user_click & (click_position==1));
	wire user_click_2= (user_click & (click_position==2));
	wire user_click_3 = (user_click & (click_position==3));
	wire user_click_4 = (user_click & (click_position==4));
	wire user_click_5 = (user_click & (click_position==5));
	wire user_click_6 = (user_click & (click_position==6));
	wire user_click_7 = (user_click & (click_position==7));
	
	wire user_flag_0 = (user_flag & (click_position==0));
	wire user_flag_1 = (user_flag & (click_position==1));
	wire user_flag_2 = (user_flag & (click_position==2));
	wire user_flag_3 = (user_flag & (click_position==3));
	wire user_flag_4 = (user_flag & (click_position==4));
	wire user_flag_5 = (user_flag & (click_position==5));
	wire user_flag_6 = (user_flag & (click_position==6));
	wire user_flag_7 = (user_flag & (click_position==7));
	
	
	wire [0:7] mines_around_0 = {1'b0, mines_above[0], mines_above[1], 
								        1'b0, 						 init_mines[1], 
								        1'b0, mines_below[0], mines_below[1]};
										  
	wire [0:7] mines_around_1 = {mines_above[0], mines_above[1], mines_above[2], 
								        init_mines[0], 						  init_mines[2], 
								        mines_below[0], mines_below[1], mines_below[2]};
										  
	wire [0:7] mines_around_2 = {mines_above[1], mines_above[2], mines_above[3], 
								        init_mines[1], 						  init_mines[3], 
								        mines_below[1], mines_below[2], mines_below[3]};
										  
	wire [0:7] mines_around_3 = {mines_above[2], mines_above[3], mines_above[4], 
								        init_mines[2], 						  init_mines[4], 
								        mines_below[2], mines_below[3], mines_below[4]};
										  
	wire [0:7] mines_around_4 = {mines_above[3], mines_above[4], mines_above[5], 
								        init_mines[3], 						  init_mines[5], 
								        mines_below[3], mines_below[4], mines_below[5]};
										  
	wire [0:7] mines_around_5 = {mines_above[4], mines_above[5], mines_above[6], 
								        init_mines[4], 						  init_mines[6], 
								        mines_below[4], mines_below[5], mines_below[6]};
										  
	wire [0:7] mines_around_6 = {mines_above[5], mines_above[6], mines_above[7], 
								        init_mines[5], 						  init_mines[7], 
								        mines_below[5], mines_below[6], mines_below[7]};
										  
	wire [0:7] mines_around_7 = {mines_above[6], mines_above[7], 1'b0, 
								        init_mines[6], 						 1'b0, 
								        mines_below[6], mines_below[7], 1'b0};
										  
	
	wire [0:7] clicked_around_0 = {1'b0, clicked_above[0], clicked_above[1], 
								          1'b0, 						 clicked_here[1], 
								          1'b0, clicked_below[0], clicked_below[1]};
											 
	wire [0:7] clicked_around_1 = {clicked_above[0], clicked_above[1], clicked_above[2], 
								          clicked_here[0], 						  clicked_here[2], 
								          clicked_below[0], clicked_below[1], clicked_below[2]};
											 
	wire [0:7] clicked_around_2 = {clicked_above[1], clicked_above[2], clicked_above[3], 
								          clicked_here[1], 						  clicked_here[3], 
								          clicked_below[1], clicked_below[2], clicked_below[3]};
											 
	wire [0:7] clicked_around_3 = {clicked_above[2], clicked_above[3], clicked_above[4], 
								          clicked_here[2], 						  clicked_here[4], 
								          clicked_below[2], clicked_below[3], clicked_below[4]};
											 
	wire [0:7] clicked_around_4 = {clicked_above[3], clicked_above[4], clicked_above[5], 
								          clicked_here[3], 						  clicked_here[5], 
								          clicked_below[3], clicked_below[4], clicked_below[5]};
											 
	wire [0:7] clicked_around_5 = {clicked_above[4], clicked_above[5], clicked_above[6], 
								          clicked_here[4], 						  clicked_here[6], 
								          clicked_below[4], clicked_below[5], clicked_below[6]};
											 
	wire [0:7] clicked_around_6 = {clicked_above[5], clicked_above[6], clicked_above[7], 
								          clicked_here[5], 						  clicked_here[7], 
								          clicked_below[5], clicked_below[6], clicked_below[7]};
											 
	wire [0:7] clicked_around_7 = {clicked_above[6], clicked_above[7], 1'b0, 
								          clicked_here[6], 						 1'b0, 
								          clicked_below[6], clicked_below[7], 1'b0};
	
	
	wire [0:31] nums_around_0 = {4'b0, nums_above_0, nums_above_1, 
								        4'b0, 					 nums_here_1, 
								        4'b0, nums_below_0, nums_below_1};
										  
	wire [0:31] nums_around_1 = {nums_above_0, nums_above_1, nums_above_2, 
								        nums_here_0, 					nums_here_2, 
								        nums_below_0, nums_below_1, nums_below_2};
										  
	wire [0:31] nums_around_2 = {nums_above_1, nums_above_2, nums_above_3, 
								        nums_here_1, 					nums_here_3, 
								        nums_below_1, nums_below_2, nums_below_3};
										  
	wire [0:31] nums_around_3 = {nums_above_2, nums_above_3, nums_above_4,
								        nums_here_2, 					nums_here_4, 
								        nums_below_2, nums_below_3, nums_below_4};
										  
	wire [0:31] nums_around_4 = {nums_above_3, nums_above_4, nums_above_5,
								        nums_here_3, 					nums_here_5, 
								        nums_below_3, nums_below_4, nums_below_5};
										  
	wire [0:31] nums_around_5 = {nums_above_4, nums_above_5, nums_above_6,
								        nums_here_4, 					nums_here_6, 
								        nums_below_4, nums_below_5, nums_below_6};
										  
	wire [0:31] nums_around_6 = {nums_above_5, nums_above_6, nums_above_7,
									     nums_here_5, 					nums_here_7, 
										  nums_below_5, nums_below_6, nums_below_7};
										  
	wire [0:31] nums_around_7 = {nums_above_6, nums_above_7, 4'b0, 
										  nums_here_6, 					4'b0, 
										  nums_below_6, nums_below_7, 4'b0};

										  
	
	block b0(
		.clicked(clicked_here[0]),
		.flagged(flagged_here[0]),
		.mines_beside(nums_here_0),
		.block_won(game_won_here[0]),
		.block_lost(game_lost_here[0]),
		.reset(reset),
		.playing(playing),
		.init_mine(init_mines[0]),
		.user_clicked(user_click_0),
		.user_flag(user_flag_0),
		.mines_around(mines_around_0),
		.clicked_around(clicked_around_0),
		.nums_around(nums_around_0),
		.clk(clk)
		);
		
	block b1(
		.clicked(clicked_here[1]),
		.flagged(flagged_here[1]),
		.mines_beside(nums_here_1),
		.block_won(game_won_here[1]),
		.block_lost(game_lost_here[1]),
		.reset(reset),
		.playing(playing),
		.init_mine(init_mines[1]),
		.user_clicked(user_click_1),
		.user_flag(user_flag_1),
		.mines_around(mines_around_1),
		.clicked_around(clicked_around_1),
		.nums_around(nums_around_1),
		.clk(clk)
		);
		
	block b2(
		.clicked(clicked_here[2]),
		.flagged(flagged_here[2]),
		.mines_beside(nums_here_2),
		.block_won(game_won_here[2]),
		.block_lost(game_lost_here[2]),
		.reset(reset),
		.playing(playing),
		.init_mine(init_mines[2]),
		.user_clicked(user_click_2),
		.user_flag(user_flag_2),
		.mines_around(mines_around_2),
		.clicked_around(clicked_around_2),
		.nums_around(nums_around_2),
		.clk(clk)
		);
		
	block b3(
		.clicked(clicked_here[3]),
		.flagged(flagged_here[3]),
		.mines_beside(nums_here_3),
		.block_won(game_won_here[3]),
		.block_lost(game_lost_here[3]),
		.reset(reset),
		.playing(playing),
		.init_mine(init_mines[3]),
		.user_clicked(user_click_3),
		.user_flag(user_flag_3),
		.mines_around(mines_around_3),
		.clicked_around(clicked_around_3),
		.nums_around(nums_around_3),
		.clk(clk)
		);
		
	block b4(
		.clicked(clicked_here[4]),
		.flagged(flagged_here[4]),
		.mines_beside(nums_here_4),
		.block_won(game_won_here[4]),
		.block_lost(game_lost_here[4]),
		.reset(reset),
		.playing(playing),
		.init_mine(init_mines[4]),
		.user_clicked(user_click_4),
		.user_flag(user_flag_4),
		.mines_around(mines_around_4),
		.clicked_around(clicked_around_4),
		.nums_around(nums_around_4),
		.clk(clk)
		);
		
	block b5(
		.clicked(clicked_here[5]),
		.flagged(flagged_here[5]),
		.mines_beside(nums_here_5),
		.block_won(game_won_here[5]),
		.block_lost(game_lost_here[5]),
		.reset(reset),
		.playing(playing),
		.init_mine(init_mines[5]),
		.user_clicked(user_click_5),
		.user_flag(user_flag_5),
		.mines_around(mines_around_5),
		.clicked_around(clicked_around_5),
		.nums_around(nums_around_5),
		.clk(clk)
		);
		
	block b6(
		.clicked(clicked_here[6]),
		.flagged(flagged_here[6]),
		.mines_beside(nums_here_6),
		.block_won(game_won_here[6]),
		.block_lost(game_lost_here[6]),
		.reset(reset),
		.playing(playing),
		.init_mine(init_mines[6]),
		.user_clicked(user_click_6),
		.user_flag(user_flag_6),
		.mines_around(mines_around_6),
		.clicked_around(clicked_around_6),
		.nums_around(nums_around_6),
		.clk(clk)
		);
		
	block b7(
		.clicked(clicked_here[7]),
		.flagged(flagged_here[7]),
		.mines_beside(nums_here_7),
		.block_won(game_won_here[7]),
		.block_lost(game_lost_here[7]),
		.reset(reset),
		.playing(playing),
		.init_mine(init_mines[7]),
		.user_clicked(user_click_7),
		.user_flag(user_flag_7),
		.mines_around(mines_around_7),
		.clicked_around(clicked_around_7),
		.nums_around(nums_around_7),
		.clk(clk)
		);
	
	

endmodule