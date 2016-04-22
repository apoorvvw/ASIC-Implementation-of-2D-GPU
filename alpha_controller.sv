// $Id: $
// File name:   alpha_controller.sv
// Created:     4/22/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: the state machine for the alpha block


module alpha_controller
(
    input wire alpha_en,
    input wire pixel_done,
    input wire read_done,
    output wire pixel_ready,
    output wire alpha_done
);

	typedef enum logic [2:0] {IDLE,READ,WAIT,BLEND,FIDLE} state_type;
	state_type state,nextstate;
	always_ff @ (posedge clk, negedge n_rst)
	begin
       if(n_rst == 0) begin
	   		state <= IDLE;
       end
       else begin
	   		state <= nextstate;
       end
    end
   
	always_comb begin
		nextstate = state;
		pixel_ready = 0;
		alpha_done = 0;
		case(state)
		IDLE: begin
			if(alpha_en)
				nextstate = READ;
		end
		READ: begin
			nextstate = WAIT;
		end
		WAIT: begin
			nextstate = BLEND;
			if(read_done)
				nextstate = FIDLE; 
        end
        BLEND: begin
            pixel_ready = 1'b1;
            if(alpha_done) 
                nextstate = READ;
        end
        FIDLE: begin
            alpha_done = 1;
        end
    end


endmodule
