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
parameter SRAM_ADDR = 24'd143360; 
parameter BUFFER_END = 32'h0812C000;


logic [MASTER_ADDRESSWIDTH-1:0] address, nextAddress;
logic [DATAWIDTH-1:0] nextRead_data, read_data;
//logic [DATAWIDTH-1:0] nextData, wr_data;
logic [NUMREGS-1:0][REGWIDTH-1:0] csr_registers;  		// Command and Status Registers (CSR) for custom logic 
logic [NUMREGS-1:0] reg_index, nextRegIndex;
logic [NUMREGS-1:0][REGWIDTH-1:0] read_data_registers;  //Store SDRAM read data for display
logic new_data_flag;
logic [7:0] next_master_redgradient, master_redgradient;
logic [3:0] next_count, count;
logic [23:0] next_sram_address, sram_address;

typedef enum {IDLE, WRITE, WRITE_WAIT, READ_REQ, READ_WAIT, READ_ACK, READ_DATA, WAIT, READ} state_t;
state_t state, nextState;
		
		//SRAM
		logic read_enable_SRAM;		// Active high read enable for the SRAM
		logic write_enable_SRAM;	// Active high write enable for the SRAM
		
		logic [(24 - 1):0]		address_SRAM; 		// The address of the first word in the access
		logic [(1536 - 1):0]	   read_data_SRAM;		// The data read from the SRAM
		logic [(1536 - 1):0]	   write_data_SRAM;	// The data to be written to the SRAM		
		logic reset_SRAM;
		
		//MASTER
		logic read_enable_master;		// Active high read enable for the SRAM
		logic write_enable_master;	// Active high write enable for the SRAM
		
		logic [(24 - 1):0]		address_master; 		// The address of the first word in the access
		logic [(1536 - 1):0]	   read_data_master;		// The data read from the SRAM
		logic [(1536 - 1):0]	   write_data_master;	// The data to be written to the SRAM
		
		//OVERALL
		logic read_enable_OVERALL;		// Active high read enable for the SRAM
		logic write_enable_OVERALL;	// Active high write enable for the SRAM
		
		logic [(24 - 1):0]		address_OVERALL; 		// The address of the first word in the access
		logic [(1536 - 1):0]	   read_data_OVERALL;		// The data read from the SRAM
		logic [(1536 - 1):0]	   write_data_OVERALL;	// The data to be written to the SRAM
/*
    logic [81:0] fifo_data;
    logic fifo_empty;
    logic config_in;
    logic config_done;
    logic config_en;
    logic bla_done;
    logic fill_done;
    logic alpha_done;
	*/ 
	 logic init_flag_mux;
	 
	 //FIFO signals
	logic [81:0] fifo_data;
	logic fifo_empty;
	
	//config signals
	logic config_in;
	logic config_done;
	
	logic config_en;
	
	logic bla_done;
	logic fill_done;
	logic alpha_done;


	reg [47:0] coordinates;
	reg [3:0] alpha_val;
	reg [1:0] texture_code;
	reg [23:0] color_code;
	reg layer_num;
	reg vertice_num;
	reg inst_type;
	reg fill_type;
	
	
	reg read_en;
	reg alpha_en;
	reg bla_en;
	reg fill_en;



overall DUT
	(
		.clk(clk),
		.n_rst(reset_n),

		.read_enable(read_enable_SRAM),
		.write_enable(write_enable_SRAM),
		.address(address_SRAM),
		.read_data(read_data_SRAM),
		.write_data(write_data_SRAM),
		.reset(reset_SRAM),

		.fifo_data(fifo_data),
		.fifo_empty(fifo_empty),
		
		.config_in(config_in),
		.config_done(config_done),
		.config_en(config_en),
		
		.bla_done(bla_done),
		.fill_done(fill_done),
		.alpha_done(alpha_done)
	);
	
	
	sram SRAM
	(	
		.clk(clk),
		.read_enable(read_enable_SRAM),
		.write_enable(write_enable_SRAM),
		.address(address_SRAM),
		.read_data(read_data_SRAM),
		.write_data(write_data_SRAM),
		.reset(reset_SRAM)

	);

	multiplexer2 MUX2
	(	
		.init(init_flag_mux), // init =  1 for master and 0 for overall
		
		.f_read_enable(read_enable_OVERALL),
		.f_write_enable(write_enable_OVERALL),
		.f_address(address_OVERALL),
		.f_write_data(write_data_OVERALL),
		
		.a_read_enable(read_enable_master),
		.a_write_enable(write_enable_master),
		.a_address(address_master),
		.a_write_data(write_data_master),
		
		.read_enable(read_enable),
		.write_enable(write_enable),
		.address(address),
		.write_data(write_data)
	
	);

	assign fifo_data = {csr_registers[0], csr_registers[1], csr_registers[2][31:14]};

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
		//wr_data <= 0 ;
		read_data <= 32'hFEEDFEED; 
		read_data_registers <= '0;
		master_redgradient <= '0;
		sram_address = SRAM_ADDR;
		count <= '0; 
	end else begin 
		state <= nextState;
		address <= nextAddress;
		reg_index <= nextRegIndex;
	//	wr_data <= nextData;
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
	next_sram_address = sram_address;
	nextRead_data = master_readdata;
	new_data_flag = 0;
	next_count = 0; 
	address_master = SRAM_ADDR;
	init_flag_mux = 0;
	read_enable_master = 0;
	case( state ) 
		IDLE : begin 
			next_count = 0;
			if ( rdwr_cntl && add_data_sel) begin 	
				if (alpha_done)
					nextState = READ;
				else
					nextState = IDLE;				
			end else if ( rdwr_cntl && !add_data_sel) begin 
				nextState = READ_REQ; 				
			end
		end 
		
		READ: begin
			init_flag_mux = 1;
			address_master = sram_address; // Read the SRAM from this address 
									// Returns 64 pixels 
			if(sram_address != 24'd208895) begin 	
				read_enable_master = 1;
				nextState = WAIT;
				next_count =0;
				next_sram_address = sram_address + 1'b1; 
			end
			else 
			begin
				nextState = IDLE; 
			end 			
		end
		
		WAIT: begin
			nextState = WRITE;
		end
		
		WRITE: begin
		
			init_flag_mux = 0;
			read_enable_master  = 0;
			
			
			if (!master_waitrequest) begin
				if (count == 64) begin				
					if ( address == BUFFER_END ) // Initiallizze BUFFER_END
						nextState = IDLE;
					else	
						nextState = READ;
				end
				else begin
					nextState = WRITE;							
					nextRegIndex = reg_index + 1'b1;
					nextAddress = address + 256;		//  NOT SURE
					next_count = count + 1;
				end
			end
		end 
		
		
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
	master_address = 26'b0;
	//master_redgradient = 8'b00000000;
	next_master_redgradient = master_redgradient;

	case(state) 
		WRITE : begin 
			master_write = 1;
			master_address =  address;
			master_writedata = {8'h00 , read_data[ (24*count) +: 24 ]}; // read_data has the 64 pixel so CHANGE THIS 
			//read_data[ (24*count)- 1 : (24 * count) ]
		end 
		READ_REQ : begin 
			master_address = address;
			master_read = 1;	
		end
	endcase
end

endmodule
