// custom_master_slave module : Acts as an avalon slave to receive input commands from PCIE IP

module custom_master_slave #(
	parameter MASTER_ADDRESSWIDTH = 26 ,  	// ADDRESSWIDTH specifies how many addresses the Master can address 
	parameter SLAVE_ADDRESSWIDTH = 3 ,  	// ADDRESSWIDTH specifies how many addresses the slave needs to be mapped to. log(NUMREGS)
	parameter DATAWIDTH = 32 ,    		// DATAWIDTH specifies the data width. Default 32 bits
	parameter NUMREGS = 8 ,       		// Number of Internal Registers for Custom Logic
	parameter REGWIDTH = 32       		// Data Width for the Internal Registers. Default 32 bits
)	
(	
	input logic  clk,
        input logic  reset_n,
	
	// Interface to Top Level
	input logic rdwr_cntl,//SW[17]
	input logic n_action,// Trigger the Read or Write. Additional control to avoid continuous transactions. Not a required signal. Can and should be removed for actual application.
	input logic add_data_sel,//SW[16]
	input logic [MASTER_ADDRESSWIDTH-1:0] rdwr_address,//SW[15:0]
	output logic [DATAWIDTH-1:0] display_data,

	//17 enable
	//16 1=write 0=read
	//15-0 unassigned

	// Bus Slave Interface
        input logic [SLAVE_ADDRESSWIDTH-1:0] slave_address,
        input logic [DATAWIDTH-1:0] slave_writedata,
        input logic  slave_write,
        input logic  slave_read,
        input logic  slave_chipselect,
//      input logic  slave_readdatavalid,// These signals are for variable latency reads. 
//	output logic slave_waitrequest,// See the Avalon Specifications for details  on how to use them.
        output logic [DATAWIDTH-1:0] slave_readdata,

	// Bus Master Interface
        output logic [MASTER_ADDRESSWIDTH-1:0] master_address,
        output logic [DATAWIDTH-1:0] master_writedata,
        output logic  master_write,
        output logic  master_read,

       
        input logic [DATAWIDTH-1:0] master_readdata,
        input logic  master_readdatavalid,
        input logic  master_waitrequest
	
		  
);


parameter START_BYTE = 32'hF00BF00B;
parameter STOP_BYTE = 32'hDEADF00B;
parameter SDRAM_ADDR = 32'h08000000;

logic [MASTER_ADDRESSWIDTH-1:0] address, nextAddress;
logic [DATAWIDTH-1:0] nextRead_data, read_data;
logic [DATAWIDTH-1:0] nextData, wr_data;
logic [NUMREGS-1:0][REGWIDTH-1:0] csr_registers;  		// Command and Status Registers (CSR) for custom logic 
logic [NUMREGS-1:0] reg_index, nextRegIndex;
logic [NUMREGS-1:0][REGWIDTH-1:0] read_data_registers;  //Store SDRAM read data for display
logic new_data_flag;
logic [7:0] next_master_redgradient, master_redgradient;
logic [3:0] next_count, count;

typedef enum {IDLE, WRITE, WRITE_WAIT, READ_REQ, READ_WAIT, READ_ACK, READ_DATA, WAIT} state_t;
state_t state, nextState;

// Slave side 
always_ff @ ( posedge clk ) begin 
  if(!reset_n)
  	begin
    		slave_readdata <= 32'h0;
 	      	csr_registers <= '0;
  	end
  else 
  	begin
  	  if(slave_write && slave_chipselect && (slave_address >= 0) && (slave_address < NUMREGS))
  	  	begin
  	  	   csr_registers[slave_address] <= slave_writedata;  // Write a value to a CSR register
  	  	end
  	  else if(slave_read && slave_chipselect  && (slave_address >= 0) && (slave_address < NUMREGS)) // reading a CSR Register
  	    	begin
       		// Send a value being requested by a master. 
       		// If the computation is small you may compute directly and send it out to the master directly from here.
  	    	   slave_readdata <= csr_registers[slave_address];
  	    	end
  	 end
end




// Master Side 

always_ff @ ( posedge clk ) begin 
	if (!reset_n) begin 
		address <= SDRAM_ADDR;
		reg_index <= 0;
		state <= IDLE;
		wr_data <= 0 ;
		read_data <= 32'hFEEDFEED; 
		read_data_registers <= '0;
		master_redgradient <= '0;
		count <= '0; 
	end else begin 
		state <= nextState;
		address <= nextAddress;
		reg_index <= nextRegIndex;
		wr_data <= nextData;
		master_redgradient <= next_master_redgradient;
		count <= next_count; 
		//read_data <= nextRead_data;
		if(new_data_flag)
			read_data_registers[reg_index] <= nextRead_data;
	end
end

// Next State Logic 
// If user wants to input data and addresses using a state machine instead of signals/conditions,
// the following code has commented lines for how this could be done.
always_comb begin 
	nextState = state;
	nextAddress = address;
	nextRegIndex = reg_index;
	//nextData = wr_data;
	nextRead_data = master_readdata;
	new_data_flag = 0;
	case( state ) 
		IDLE : begin 
			if ( rdwr_cntl && add_data_sel) begin 
				nextState = WRITE;
				//nextData = wr_data;
			end else if ( rdwr_cntl && !add_data_sel) begin 
				nextState = READ_REQ; 				
			end
		end 
		WRITE: begin
			if (!master_waitrequest) begin
				nextState = WAIT;
				nextRegIndex = reg_index + 1;
				nextAddress = (address == 32'h0812C000 ) ? SDRAM_ADDR : address + 4;				
			end
		end 
		WAIT:
			nextState = rdwr_address [4] ? WAIT : IDLE;
		READ_REQ : begin 
			if (!master_waitrequest) begin
				nextState = READ_DATA;
				nextAddress = address - 4 ;	
				nextRegIndex = reg_index - 1;
			end
		end
		READ_DATA : begin
			if ( master_readdatavalid) begin
				nextRead_data = master_readdata;
				nextState = IDLE;
				new_data_flag =1;
			end
		end
	endcase
end

// Output Logic 
always_comb begin 
	master_write = 1'b0;
	master_read = 1'b0;
	master_writedata = 32'h0;
	master_address = 32'hbad1bad1;
	//master_redgradient = 8'b00000000;
	next_master_redgradient = master_redgradient;
	next_count = count;

	case(state) 
		WRITE : begin 
			master_write = 1;
			master_address =  address;
			master_writedata = //address;
			
				{8'h00, master_redgradient,
				
				rdwr_address[1],rdwr_address[1],rdwr_address[1],rdwr_address[1],
				rdwr_address[1],rdwr_address[1],rdwr_address[1],rdwr_address[1],
				
				rdwr_address[0],rdwr_address[0],rdwr_address[0],rdwr_address[0],
				rdwr_address[0],rdwr_address[0],rdwr_address[0],rdwr_address[0]};
				if(count > 4'd10)
				begin
					next_master_redgradient = (master_redgradient + 1'b1) % 256; 
					next_count = 4'b0000;
				end
				else 
				begin 
					next_master_redgradient = master_redgradient;
					next_count = count + 1'b1;

				end
		end 
		READ_REQ : begin 
			master_address = address;
			master_read = 1;	
		end
	endcase
end

endmodule

/*
logic vertice_num;
logic coordinates;
logic inst_type;
logic alpha_done;
logic fifo_empty;
logic config_in;
logic config_done;
logic fill_type;
logic texture_code;
logic color_code;
logic layer_num;

	assign vertice_num = 1'b1;
	assign coordinates = {8'd60, 8'd32, 8'd2, 8'd62, 8'd2, 8'd2};
	assign inst_type = 1'b0;
	assign alpha_done= 1'b0;
	/*assign fifo_empty;
	assign config_in;
	assign config_done;
	assign fill_type;
	assign texture_code;
	assign color_code;
	assign layer_num;
*/
/*
logic [7:0] x0 = 8'd0;
logic [7:0] y0 = 8'd0;
logic [7:0] x1 = 8'd10;
logic [7:0] y1 = 8'd10;
logic start;
logic reset_buff;
	
	bresenham BR 
	(
		.clk(clk),
		.n_rst(reset_n),
		.x0(x0),
		.y0(y0),
		.x1(x1),
		.y1(y1),
		.start(start),
		.x(x),
		.y(y),
		.reset_buff(reset_buff),
		.line_buffer(line_buffer),
		.picture(picture),
		.done(done)
	);

assign start = !done;
assign reset_buff = 0;
*/
/*
	fill_bla_wrapper FBW
	(
		.clk(clk),
		.n_rst(reset_n),
	
		.vertice_num(vertice_num),
		.coordinates(coordinates),
		.inst_type(inst_type),
		.alpha_done(alpha_done),
		.fifo_empty(fifo_empty),
		.config_in(config_in),
		.config_done(config_done),
		.fill_type(fill_type),
		.texture_code(texture_code),
		.color_code(color_code),
		.layer_num(layer_num),
		
		.read_enable(read_enable),
		.write_enable(write_enable),
		.address(address),
		.read_data(read_data),
		.write_data(write_data),
		.fill_done(fill_done),
		.bla_done(bla_done),
		.line_buffer(line_buffer)

	);
*/

