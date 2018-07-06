/* i2c.v
 *
 * Controls the operation of the I2C interface.
 *
 * In order to use this module, a top level module must supply it with a 50MHz reference clock, a
 * start signal (a bit pulse of 1, which should only last one period), and the data to write to
 * the slave. It must then wait for the `configured` pin to be pulled high before engaging with the
 * slave if I2C is used as a control interface (`configured` indicates that data transmission has
 * completed successfully).
 */

module i2c (
            // External data and control.
            input        clk_50, // 50 MHz reference clock
            input        start, // Signal to tell module to begin operation.
            input [0:87] data, // Data to transmit over SDA line.
            input        reset_n, // Active-low reset from controlling module.
            // I2C output
            inout        sda, // I2C interface is operated by pulling the signals low,
            output reg   scl = 1'b1, // so we initialize them to high.
            // Status
            output reg   configured = 1'b0, // Set this to 1 when configuration is complete
            output       i2c_sclk
            );

   reg [5:0]             count=0;       // Used to generate I2C clock.
   reg [0:87]            data_;         // Store data to transmit.
   integer               bit_count=0;   // Keeps track of bit in each byte.
   integer               bit_count_reg=0;
   integer               byte_count=0;  // Keeps track of byte.
   integer               byte_count_reg=0;
   reg                   sda_reg=1;     // Holds SDA value to write.
   reg                   i2c_clk=1;     // I2C clock.
   reg [2:0]             pr_state=0;    /* State of FSM.
                                         000 - idle
                                         001 - start
                                         010 - address frame
                                         011 - ack1 (whether slave receives address correctly)
                                         100 - write data
                                         101 - ack2 (write acknowledge)
                                         110 - stop
                                         111 - hold (state until start is deasserted)
                                         */
   reg [2:0]             nx_state=0;

   assign sda = sda_reg;
   assign i2c_sclk = i2c_clk;

   // Pass over data to internal logic.
   always @(posedge start) begin
      data_ <= data;
   end

   // Generate I2C clock.
   always @(posedge clk_50) begin
      if (count!=63) begin
         count <= count + 1;
         i2c_clk <= i2c_clk;
      end
      else begin
         count <= 0;
         i2c_clk <= !i2c_clk;
      end
   end

   // Update state
   always @(negedge i2c_clk or negedge reset_n) begin
      if (reset_n==0) begin
         pr_state <= 0;
         bit_count_reg <= 0;
         byte_count_reg <= 0;
      end
      else begin
         pr_state <= nx_state;
         bit_count_reg <= bit_count+1;
         byte_count_reg <= byte_count;
      end
   end // always @ (negedge i2c_clk or negedge reset_n)

   // Drive outputs on negative edge of I2C clock.
   always @(*) begin
      case (pr_state)
        // Idle state.
        0 : begin
           scl = 1;
           sda_reg = 1;
           bit_count = 0;
           byte_count = 0;
           configured = 0;
           if (start==1) begin  // Transition to start state.
              nx_state = 1;
           end
           else begin  // Stay in idle state.
              nx_state = 0;
           end
        end // case: 0
        // Start state.
        1 : begin
           scl = 1;
           sda_reg = 0;
           bit_count = 0;
           byte_count = 0;
           configured = 0;
           nx_state = 2;  // Unconditionally transition to address frame state.
        end
        // Address frame state.
        2 : begin
           scl = i2c_clk;
           sda_reg = data_[byte_count*8 + bit_count_reg - 1];
           byte_count = 0;
           configured = 0;
           if (bit_count_reg==8) begin  // If all 8 bits transmitted transition to address ACK.
              bit_count = 0;
              nx_state = 3;
           end
           else begin  // Else increment bit count and stay in current state.
              bit_count = bit_count_reg;
              nx_state = 2;
           end
        end // case: 2
        // Address ACK state.
        3 : begin
           scl = i2c_clk;
           sda_reg = 1'bz;
           bit_count = 0;
           byte_count = 1;
           configured = 0;
           if (sda==0) begin  // If slave is responsive transition to write data state.
              nx_state = 4;
           end
           else begin  // Else return to idle state.
              nx_state = 0;
           end
        end // case: 3
        // Write data state.
        4 : begin
           scl = i2c_clk;
           sda_reg = data_[byte_count*8 + bit_count_reg - 1];
           byte_count = byte_count_reg;
           configured = 0;
           if (bit_count_reg==8) begin
              bit_count = 0;
              nx_state = 5;
           end
           else begin
              bit_count = bit_count_reg;
              nx_state = 4;
           end
        end // case: 4
        // Data ACK state.
        5 : begin
           scl = i2c_clk;
           sda_reg = 1'bz;
           bit_count = 0;
           byte_count = byte_count_reg + 1;
           configured = 0;
           if (sda==1) begin
              nx_state = 0;
           end
           else if (byte_count_reg<10) begin
              nx_state = 4;
           end
           else begin
              nx_state = 6;
           end
        end // case: 5
        // Stop state.
        6 : begin
           scl = i2c_clk;
           sda_reg = 0;
           bit_count = 0;
           byte_count = 0;
           configured = 0;
           nx_state = 7;
        end
        // Hold state.
        7 : begin
           scl = 1;
           sda_reg = 1;
           bit_count = 0;
           byte_count = 0;
           configured = 1;
           if (start==0) begin
              nx_state = 0;
           end
           else begin
              nx_state = 7;
           end
        end // case: 7
      endcase // case (state)
   end // always @ (negedge i2c_clk)
endmodule // i2c
