module ms_datapath(
    input clk,
    input resetn,
    input [0:63] in_mines,
    input [0:63] in_clicked,
    input [0:63] in_flagged,
    input [0:31] nums_1,
    input [0:31] nums_2, 
    input [0:31] nums_3,
    input [0:31] nums_4, 
    input [0:31] nums_5, 
    input [0:31] nums_6, 
    input [0:31] nums_7,
    input [0:31] nums_8,
    input [1:0] smiley_select,
    input [2:0] position_x,
    input [2:0] position_y,
    output reg [2:0] out_color,
    output reg [7:0] x_out,
    output reg [6:0] y_out
    );

    reg [7:0] outline_counter;
    reg [8:0] smiley_counter;
    reg [6:0] block_counter, pixel_counter, digit_display_counter, digital_display_selector;

    reg [0:3] digit_select;
    reg [0:48] digit_display;

    reg [0:255] smiley_display;

    reg [0:31] current_mines_selected;
	 
	 reg outline_counter_increment, smiley_counter_increment, pixel_counter_increment, digit_display_counter_increment, block_counter_increment;
	 
    initial
    begin
        pixel_counter = 0;
        outline_counter = 0;
        digit_display_counter = 0;
        smiley_counter = 0;
        block_counter = 0;
        digit_select = 0;
        digit_display = 0;
        smiley_display = 0;
        current_mines_selected =  0;
		  
		  block_counter_increment = 0;
		  outline_counter_increment = 0;
	  	  digit_display_counter_increment = 0;
		  smiley_counter_increment = 0;
    end
    always @(posedge clk)
    begin
		
		case (smiley_select)
        2'b00: begin //in-game :|
            smiley_display = 256'b0000000000000000000000000000000000111100001111000011110000111100001111000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111000011111111111100000000000000000000000000000000000000000000000000;

            //0000000000000000
            //0000000000000000
            //0011110000111100
            //0011110000111100
            //0011110000111100
            //0000000000000000
            //0000000000000000
            //0000000000000000
            //0000000000000000
            //0000000000000000
            //0000000000000000
            //0011111111111100
            //0011111111111100
            //0000000000000000
            //0000000000000000
            //0000000000000000
        end
        2'b10: begin //game won :)
            smiley_display = 256'b0000000000000000000000000000000000111100001111000011110000111100001111000011110000000000000000000000000000000000000000000000000000000000000000000011000000001100000110000001100000001100001100000000011111100000000000000000000000000000000000000000000000000000;
           
            //0000000000000000
            //0000000000000000
            //0011110000111100
            //0011110000111100
            //0011110000111100
            //0000000000000000
            //0000000000000000
            //0000000000000000
            //0000000000000000
            //0011000000001100
            //0001100000011000
            //0000110000110000
            //0000011111100000
            //0000000000000000
            //0000000000000000
            //0000000000000000
        end
        2'b01: begin //game lost :(
            smiley_display = 256'b0000000000000000000000000000000000111100001111000011110000111100001111000011110000000000000000000000000000000000000000000000000000000000000000000000011111100000000011000011000000011000000110000011000000001100000000000000000000000000000000000000000000000000;
           
            //0000000000000000
            //0000000000000000
            //0011110000111100
            //0011110000111100
            //0011110000111100
            //0000000000000000
            //0000000000000000
            //0000000000000000
            //0000000000000000
            //0000011111100000
            //0000110000110000
            //0001100000011000
            //0011000000001100
            //0000000000000000
            //0000000000000000
            //0000000000000000 
        end
      endcase
		
		case (digit_select)
            4'b0000: begin //0
                digit_display = 49'b0000000011111001000100100010010001001111100000000;
                //0000000011111001000100100010010001001111100000000
                end
            4'b0001: begin //1
                digit_display = 49'b0000000000100000010000001000000100000010000000000;
                //0000000000100000010000001000000100000010000000000
                end
            4'b0010: begin //2
                digit_display = 49'b0000000011111000000100111110010000001111100000000;
                //0000000011111000000100111110010000001111100000000
                end
            4'b0011: begin //3
                digit_display = 49'b0000000011111000000100111110000001001111100000000;
                //0000000011111000000100111110000001001111100000000
                end
            4'b0100: begin //4
                digit_display = 49'b0000000010001001000100111110000001000000100000000;
                //0000000010001001000100111110000001000000100000000
                end
            4'b0101: begin //5
                digit_display = 49'b0000000011111001000000111110000001001111100000000;
                //0000000011111001000000111110000001001111100000000
                end
            4'b0110: begin //6
                digit_display = 49'b0000000011111001000000111110010001001111100000000;
                //0000000011111001000000111110010001001111100000000
                end
            4'b0111: begin //7
                digit_display = 49'b0000000011111000000100000010000001000000100000000;
                //0000000011111000000100000010000001000000100000000
                end
            4'b1000: begin //8
                digit_display = 49'b0000000011111001000100111110010001001111100000000;
                //0000000
					 //0111110
					 //0100010
					 //0111110
					 //0100010
					 //0111110
					 //0000000
                end                               
        endcase
	 
        if(!resetn) begin
            pixel_counter <= 0;
            y_out <= 7'b0000000;
            x_out <= 8'b00000000;
            block_counter <= 0;
            outline_counter <= 0;
            digit_display_counter <= 0;
				digital_display_selector <= 0;
            smiley_counter <= 0;
				
				block_counter_increment <= 0;
				outline_counter_increment <= 0;
				digit_display_counter_increment <= 0;
				smiley_counter_increment <= 0;
				pixel_counter_increment <= 0;
        end
		  
		  else if (block_counter_increment) begin
				if (block_counter == 64) begin
					block_counter <= 0;
					block_counter_increment <= 0;
				end else begin
					block_counter <= block_counter + 1;
					block_counter_increment <= 0;
				end
				
		  end else if (outline_counter_increment) begin
				outline_counter <= outline_counter + 1;
				outline_counter_increment <= 0;
				
	     end else if (digit_display_counter_increment) begin
				if (digit_display_counter[2:0]==6 & digit_display_counter[2:0]!=6) begin
					digit_display_counter <= digit_display_counter + 2;
					digital_display_selector <= digital_display_selector + 1;
					digit_display_counter_increment <= 0;
				end else if (digit_display_counter[2:0]==6 & digit_display_counter[2:0]==6) begin
					digit_display_counter <= digit_display_counter + 10;
					digital_display_selector <= digital_display_selector + 1;
					digit_display_counter_increment <= 0;
				end else begin
					digit_display_counter <= digit_display_counter + 1;
					digital_display_selector <= digital_display_selector + 1;
					digit_display_counter_increment <= 0;
				end
				
		  end else if (smiley_counter_increment) begin
				smiley_counter <= smiley_counter + 1;
				smiley_counter_increment <= 0;
				
		  end else if (pixel_counter_increment) begin
				pixel_counter <= pixel_counter + 1;
				pixel_counter_increment <= 0;
				
        end else begin
            if(pixel_counter == 64) begin
                if(outline_counter == 28) begin
                    if(!in_clicked[block_counter] | digit_display_counter >= 64 | in_mines[block_counter]) begin
                        if(smiley_counter == 256) begin
                            block_counter_increment <= 1;
                            pixel_counter <= 0;
                            outline_counter <= 0;
                            digit_display_counter <= 0;
									 digital_display_selector <= 0;
                            smiley_counter <= 0;
                        end
                        else begin
                            if(smiley_display[smiley_counter[7:0]]) begin
                                out_color <= 3'b000;
                            end else begin
										  out_color <= 3'b110;
									 end
                            x_out <= 70 + smiley_counter[3:0];
                            y_out <= 5 + smiley_counter[7:4];
                            smiley_counter_increment <= 1;
                        end
                    end
                    else begin // digit display
                        if(block_counter < 8) begin
                            current_mines_selected <= nums_1;
                        end
                        else if(block_counter >= 8 & block_counter < 16) begin
                            current_mines_selected <= nums_2;
                        end
                        else if(block_counter >= 16 & block_counter < 24) begin
                            current_mines_selected <= nums_3;
                        end
                        else if(block_counter >= 24 & block_counter < 32) begin
                            current_mines_selected <= nums_4;
                        end
                        else if(block_counter >= 32 & block_counter < 40) begin
                            current_mines_selected <= nums_5;
                        end
                        else if(block_counter >= 40 & block_counter < 48) begin
                            current_mines_selected <= nums_6;
                        end
                        else if(block_counter >= 48 & block_counter < 56) begin
                            current_mines_selected <= nums_7;
                        end
                        else begin
                            current_mines_selected <= nums_8;
                        end
                        //if(digit_display[7*digit_display_counter[5:3]%7 + digit_display_counter[2:0]%7]) begin
								if(digit_display[digital_display_selector]) begin
                            out_color <= 3'b111;
                        end else begin
									 out_color <= 3'b010;
								end
                        digit_select[0] <= current_mines_selected[4*(block_counter%8)];
                        digit_select[1] <= current_mines_selected[4*(block_counter%8)+1];
                        digit_select[2] <= current_mines_selected[4*(block_counter%8)+2];
                        digit_select[3] <= current_mines_selected[4*(block_counter%8)+3];
                        x_out <= 50 + 8*(block_counter[2:0]) + block_counter[2:0] + digit_display_counter[2:0];
                        y_out <= 30 + 8*(block_counter[5:3]) + block_counter[5:3] + digit_display_counter[5:3];
                        digit_display_counter_increment <= 1;
                    end
                end
                else begin
                    out_color <= 3'b000;
                    if(8*position_y + position_x == block_counter) begin
                        out_color <= 3'b101;
                    end
                    if(outline_counter < 7) begin
                        x_out <= 50 + 8*(block_counter[2:0]) + block_counter[2:0] + outline_counter;//
                        y_out <= 30 + 8*(block_counter[5:3]) + block_counter[5:3] - 1;
                    end
                    else if(outline_counter >= 7 & outline_counter < 14) begin
                        x_out <= 50 + 8*(block_counter[2:0]) + block_counter[2:0] + 7;
                        y_out <= 30 + 8*(block_counter[5:3]) + block_counter[5:3] + outline_counter-7;
                    end
                    else if(outline_counter >= 14 & outline_counter < 21) begin
                        x_out <= 50 + 8*(block_counter[2:0]) + block_counter[2:0] + outline_counter-14;
                        y_out <= 30 + 8*(block_counter[5:3]) + block_counter[5:3] + 7;
                    end
                    else begin
                        x_out <= 50 + 8*(block_counter[2:0]) + block_counter[2:0] - 1;
                        y_out <= 30 + 8*(block_counter[5:3]) + block_counter[5:3] + outline_counter - 21;
                    end
                    outline_counter_increment <= 1;
                end
            end                 
            else begin
                // default (BLUE)
                if(!in_clicked[block_counter] & !in_flagged[block_counter]) begin
                    out_color <= 3'b001;
                end
                // flag (YELLOW)
                else if(!in_clicked[block_counter] & in_flagged[block_counter]) begin
                    out_color <= 3'b110;
                end
					 
                // clean click (GREEN)
                //else if(in_clicked[block_counter] & !in_mines[block_counter]) begin
                //    out_color <= 3'b010;
                //end
					 
                // mine click (RED)
                else if (in_clicked[block_counter] & in_mines[block_counter]) begin
                    out_color <= 3'b100;
                end
                x_out <= 50 + 8*(block_counter[2:0]) + block_counter[2:0] + pixel_counter[2:0]%7;
                y_out <= 30 + 8*(block_counter[5:3]) + block_counter[5:3] + pixel_counter[5:3]%7;
                pixel_counter_increment <= 1;
            end
        end
    end   
   
endmodule            