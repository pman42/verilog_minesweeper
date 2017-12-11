module create_mines(enable, rand, rst, clk, out_array);
    input enable;
	 input rst;
	 input clk;
    output reg [0:63] out_array;
    input [26:0] rand;
	
	 reg last_enable, change_mines_state;
	 reg [5:0] mines_state;
	 reg [26:0] rand_here;
	 
	 wire [5:0] mine_1 = 9*{3'b000, rand_here[2:0]}; // some diagonal
	 wire [5:0] mine_2 = (mine_1[5:0] + {2'b00, rand_here[6:3]})+1; // range 16
	 wire [5:0] mine_3 = (mine_2[5:0] + {3'b000, rand_here[9:7]})+1; // range 8
	 wire [5:0] mine_4 = (mine_3[5:0] + {3'b000, rand_here[12:10]})+1; // range 8
	 wire [5:0] mine_5 = (mine_4[5:0] + {3'b000, rand_here[15:13]})+1; // range 8
	 wire [5:0] mine_6 = (mine_5[5:0] + {3'b000, rand_here[18:16]})+1; // range 8
	 wire [5:0] mine_7 = (mine_6[5:0] + {4'b0000, rand_here[20:19]})+1; // range 4
	 wire [5:0] mine_8 = (mine_7[5:0] + {4'b0000, rand_here[22:21]})+1; // range 4
	 wire [5:0] mine_9 = (mine_8[5:0] + {4'b0000, rand_here[24:23]})+1; // range 4
	 wire [5:0] mine_10 = (mine_9[5:0] + {4'b0000, rand_here[26:25]})+1; // range 4
	 
	 
	 /**
	 wire [5:0] mine_1 = 9*{3'b000, rand_here[2:0]}-1; // some diagonal
	 wire [5:0] mine_2 = (mine_1[5:0] + {2'b00, rand_here[6:3]}); // range 16
	 wire [5:0] mine_3 = (mine_2[5:0] + {3'b000, rand_here[9:7]}); // range 8
	 wire [5:0] mine_4 = (mine_3[5:0] + {3'b000, rand_here[12:10]}); // range 8
	 wire [5:0] mine_5 = ({3'b000, rand_here[2:0]} + {3'b000, rand_here[15:13]}) + 32; // range 8
	 wire [5:0] mine_6 = ({3'b000, rand_here[2:0]} + {3'b000, rand_here[18:16]}) + 40; // range 8
	 wire [5:0] mine_7 = ({3'b000, rand_here[2:0]} + {4'b0000, rand_here[20:19]}) + 48; // range 4
	 wire [5:0] mine_8 = ({3'b000, rand_here[2:0]} + {4'b0000, rand_here[22:21]}) + 52; // range 4
	 wire [5:0] mine_9 = ({3'b000, rand_here[2:0]} + {4'b0000, rand_here[24:23]}) + 56; // range 4
	 wire [5:0] mine_10 = ({3'b000, rand_here[2:0]} + {4'b0000, rand_here[26:25]}) + 60; // range 4
	 **/
	 
	 
    initial begin
      out_array = 0;
		mines_state = 0;
		last_enable = 0;
		change_mines_state = 0;
    end
	 
	 
    always @(posedge clk)
    begin
	 
		if (enable==1 & last_enable==0) begin
			mines_state <= 1;
			last_enable <= 1;
		end else if (enable==0 & last_enable==1) begin
			last_enable <= 0;
		end else begin
			if (change_mines_state) begin
				mines_state <= mines_state + 1;
				change_mines_state <= 0;
			end else begin
				case (mines_state)
					1: begin
						rand_here <= rand;
						change_mines_state <= 1;
					end
					2: begin
						out_array <= 0;
						change_mines_state <= 1;
					end
					3: change_mines_state <= 1; //delay
					4: change_mines_state <= 1; //delay
					5: change_mines_state <= 1; //delay
					6: change_mines_state <= 1; //delay
					7: change_mines_state <= 1; //delay
					8: change_mines_state <= 1; //delay
					9: change_mines_state <= 1; //delay
					10: change_mines_state <= 1; //delay
					11: change_mines_state <= 1; //delay
					12: change_mines_state <= 1; //delay
					13: begin
						out_array[mine_1] <= 1;
						change_mines_state <= 1;
					end
					14: begin
						out_array[mine_2] <= 1;
						change_mines_state <= 1;
					end
					15: begin
						out_array[mine_3] <= 1;
						change_mines_state <= 1;
					end
					16: begin
						out_array[mine_4] <= 1;
						change_mines_state <= 1;
					end
					17: begin
						out_array[mine_5] <= 1;
						change_mines_state <= 1;
					end
					18: begin
						out_array[mine_6] <= 1;
						change_mines_state <= 1;
					end
					19: begin
						out_array[mine_7] <= 1;
						change_mines_state <= 1;
					end
					20: begin
						out_array[mine_8] <= 1;
						change_mines_state <= 1;
					end
					21: begin
						out_array[mine_9] <= 1;
						change_mines_state <= 1;
					end
					22: begin
						out_array[mine_10] <= 1;
						change_mines_state <= 1;
					end
					default: mines_state <= 0;
				endcase
			end
		end 
				
	 end

endmodule