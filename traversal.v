module traversal(input_keys, rst, clk, x, y);
	input [3:0] input_keys;
	input rst, clk;
	output reg [2:0] x, y;

	reg [3:0] input_keys_last;
	
	initial 
	begin
		x = 0;
		y = 0;
		input_keys_last = 4'b0000;
	end

	
	always @(posedge clk)
	begin		
		if (rst==0) begin
			x <= 0;
			y <= 0;
		end else begin
			if (input_keys_last[0] == 0 & input_keys[0] == 1) begin
				y <= y - 1;
			end if (input_keys_last[1] == 0 & input_keys[1] == 1) begin
				y <= y + 1;
			end if (input_keys_last[2] == 0 & input_keys[2] == 1) begin
				x <= x - 1;
			end if (input_keys_last[3] == 0 & input_keys[3] == 1) begin
				x <= x + 1;
			end
			
			input_keys_last <= input_keys;
			
		end
	end
	
endmodule