
module block(clicked, flagged, mines_beside, block_won, block_lost,
				 clk, reset, playing, init_mine, user_clicked, user_flag, mines_around, clicked_around, nums_around);
				 
	input clk, reset, playing, init_mine, user_clicked, user_flag;
	input [0:7] mines_around, clicked_around;
	input [0:31] nums_around;
	
	output reg clicked, flagged;
	output block_won, block_lost;
	output [3:0] mines_beside;
	
	// See if an artificial click is needed.
	wire artificial_click;
	artificial_click a1(
		.click(artificial_click),
		.mines_around(mines_around),
		.clicked_around(clicked_around),
		.nums_around(nums_around)
		);
	
	// Assign appropriate value to clicked and flagged
	reg last_user_flag = 0;
	reg last_playing = 0;
	always @(posedge clk) begin
		
		last_playing <= playing;
	
		if (reset==0) begin
			clicked <= 0;
			flagged <= 0;
		end else begin
			if (playing==1) begin
				if (user_clicked | artificial_click) begin
					clicked = 1;
				end
				if (user_flag!=last_user_flag) begin
					if (user_flag==1) begin
						last_user_flag <= 1;
						if (flagged==0) begin
							flagged <= 1;
						end else begin
							flagged <=0;
						end
					end else begin
						last_user_flag <= 0;
					end
				end
			end else if (playing==0 & last_playing==1) begin
				if (init_mine) begin
					clicked <= 1;
				end
			end
		end
	end
	
	// See if block_won or block_lost
	assign block_won = (clicked & ~init_mine) | (~clicked & init_mine);
	assign block_lost = (clicked & init_mine);
	
	// Calculate the number of mines beside this block. 
	assign mines_beside = mines_around[0] + mines_around[1] + mines_around[2] + mines_around[3]
							  + mines_around[4] + mines_around[5] + mines_around[6] + mines_around[7];
							  
	
	
endmodule

module artificial_click(click, mines_around, clicked_around, nums_around);
	input [0:7] mines_around, clicked_around;
	input [0:31] nums_around;
	
	output click;
	
	assign click = ((~mines_around[0]) & clicked_around[0] & (nums_around[0:3]==0)) |
						((~mines_around[1]) & clicked_around[1] & (nums_around[4:7]==0)) |
						((~mines_around[2]) & clicked_around[2] & (nums_around[8:11]==0)) |
						((~mines_around[3]) & clicked_around[3] & (nums_around[12:15]==0)) |
						((~mines_around[4]) & clicked_around[4] & (nums_around[16:19]==0)) |
						((~mines_around[5]) & clicked_around[5] & (nums_around[20:23]==0)) |
						((~mines_around[6]) & clicked_around[6] & (nums_around[24:27]==0)) |
						((~mines_around[7]) & clicked_around[7] & (nums_around[28:31]==0));
	
endmodule
