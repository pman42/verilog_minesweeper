module minesweeper_control(
	clk,
	go,
	is_win,
	is_loss,
	reset_in,
	reset_out,
	enable_mine_generation,
	enable_vga,
	clock_run,
	playing,
	compare_high_score
);

	input clk, go, is_win, is_loss, reset_in;
	output reg reset_out, enable_mine_generation, enable_vga, clock_run, playing, compare_high_score; 
    
    localparam  INIT_STATE = 3'd0,
                RESET = 3'd1,
                GENERATE_MINES = 3'd2,
                IN_GAME = 3'd3,
                WIN = 3'd4,
                LOSE = 3'd5;
	
	 reg [2:0] current_state = INIT_STATE;
	 reg [2:0] next_state = INIT_STATE;
               
    always@(*)
    begin: state_table 
            case (current_state)
                INIT_STATE: next_state = go ? RESET : INIT_STATE; 
                
                RESET: next_state = GENERATE_MINES; 

                GENERATE_MINES: next_state = IN_GAME; 

                IN_GAME: next_state = is_win ? WIN : is_loss ? LOSE : IN_GAME;

                WIN: next_state = go ? RESET : WIN;

                LOSE: next_state = go ? RESET : LOSE;
            default:     next_state = INIT_STATE;
        endcase
    end // state_table


    always @(*)
    begin: enable_signals
	 
        reset_out = 1'b1;
        enable_mine_generation = 1'b0;
		  enable_vga = 1'b1;
        clock_run = 1'b0;
		  playing = 1'b0;
        compare_high_score = 1'b0;
		  


        case (current_state)
            RESET: begin
                reset_out = 1'b0;
					 enable_vga = 1'b0;
                end
            GENERATE_MINES: begin
                enable_mine_generation = 1'b1;
                end
            IN_GAME: begin
					 playing = 1'b1;
                clock_run = 1'b1;
                end
            WIN: begin
                compare_high_score = 1'b1;
                end
        endcase        
    end // enable_signals
   

    always @(posedge clk)
    begin: state_FFs
        if(!reset_in)
            current_state <= INIT_STATE;
        else
            current_state <= next_state;
    end // state_FFS
endmodule