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
            input         clk_50, // 50 MHz reference clock
            input         start, // Signal to tell module to begin operation.
            input [0:119] data, // Data to transmit over SDA line.
            input         reset_n, // Active-low reset from controlling module.
            // I2C output
            inout         sda, // I2C interface is operated by pulling the signals low,
            output reg    scl = 1'b1, // so we initialize them to high.
            // Status
            output reg    configured = 1'b0, // Set this to 1 when configuration is complete
            output        i2c_sclk
            );

   reg [0:119]           data_;         // Store data to transmit.
   reg [3:0]             bit_cnt_nx=0;   // Keeps track of the bit index (0-7).
   reg [3:0]             bit_cnt_pr=0;
   reg [1:0]             byte_cnt_nx=0;  // Keeps track of byte index (0-2).
   reg [1:0]             byte_cnt_pr=0;
   reg [2:0]             config_cnt_nx=0; // Keeps track of the configuration line (0-4).
   reg [2:0]             config_cnt_pr=0;
   reg                   sda_reg=1;     // Holds SDA value to write.
   reg                   clk_scl=1; // I2C clock for scl.
   reg                   clk_sda=1; // I2C clock for sda.

   /* State of FSM.
    *
    * 000 - idle
    * 001 - start
    * 010 - address frame
    * 011 - ack1 (whether slave receives address correctly)
    * 100 - write data
    * 101 - ack2 (write acknowledge)
    * 110 - stop
    * 111 - hold (state until start is deasserted)
    */
   reg [2:0]             state_sda_pr=0;
   reg [2:0]             state_sda_nx=0;
   reg [2:0]             state_scl_pr=0;
   reg [2:0]             state_scl_nx=0;
   reg                   nack;  /* Registers the ack/nack. */

   always @ (posedge scl) begin
     nack <= sda;
   end

   assign sda = sda_reg;
   assign i2c_sclk = clk_scl;

   // Pass over data to internal logic.
   always @(posedge start) begin
      data_ <= data;
   end

   // Generate I2C clock.
   reg [6:0]             count=0;
   always @(posedge clk_50) begin
      if (count<32) begin
         count <= count + 1;
         clk_scl <= 1;
         clk_sda <= 1;
      end
      else if (count<63) begin
         count <= count + 1;
         clk_scl <= 0;
         clk_sda <= 1;
      end
      else if (count<94) begin
         count <= count + 1;
         clk_scl <= 0;
         clk_sda <= 0;
      end
      else if (count<126) begin
         count <= count + 1;
         clk_scl <= 1;
         clk_sda <= 0;
      end
      else begin
         count <= 0;
         clk_scl <= 1;
         clk_sda <= 1;
      end
   end

   // SDA register state.
   always @(negedge clk_sda or negedge reset_n) begin
      if (!reset_n) begin
         state_sda_pr <= 0;
         bit_cnt_pr <= 0;
         byte_cnt_pr <= 0;
         config_cnt_pr <= 0;
      end
      else begin
         state_sda_pr <= state_sda_nx;
         bit_cnt_pr <= bit_cnt_nx+1;
         byte_cnt_pr <= byte_cnt_nx;
         config_cnt_pr <= config_cnt_nx;
      end
   end // always @ (negedge clk_sda or negedge reset_n)

   // SDA combinational logic.
   always @(*) begin
      case (state_sda_pr)
        0 : begin  /* Idle. */
           sda_reg = 1;
           bit_cnt_nx = 4'd0;
           byte_cnt_nx = 0;
           config_cnt_nx = 0;
           if (start) begin  // Transition to start state.
              configured = 0;
              state_sda_nx = 1;
           end
           else begin  // Stay in idle state.
              if (configured) begin
                 configured = 1;
              end
              else begin
                 configured = 0;
              end
              state_sda_nx = 0;
           end
        end // case: 0
        1 : begin  /* Start. */
           sda_reg = 0;
           bit_cnt_nx = 0;
           byte_cnt_nx = 0;
           config_cnt_nx = config_cnt_pr;
           configured = 0;
           state_sda_nx = 2;  // Unconditionally transition to address frame state.
        end
        2 : begin  /* Address frame. */
           sda_reg = data_[24*config_cnt_pr + byte_cnt_nx*8 + bit_cnt_pr - 1];
           byte_cnt_nx = 0;
           configured = 0;
           config_cnt_nx = config_cnt_pr;
           if (bit_cnt_pr==8) begin  // If all 8 bits transmitted transition to address ACK.
              bit_cnt_nx = 0;
              state_sda_nx = 3;
           end
           else begin  // Else increment bit count and stay in current state.
              bit_cnt_nx = bit_cnt_pr;
              state_sda_nx = 2;
           end
        end // case: 2
        3 : begin  /* Address ack. */
           sda_reg = 1'bz;
           bit_cnt_nx = 0;
           byte_cnt_nx = 1;
           configured = 0;
           config_cnt_nx = config_cnt_pr;
           if (!nack) begin  // If slave is responsive transition to write data state.
              state_sda_nx = 4;
           end
           else begin  // Else return to idle state.
              state_sda_nx = 0;
           end
        end // case: 3
        4 : begin  /* Data frame. */
           sda_reg = data_[24*config_cnt_nx + byte_cnt_nx*8 + bit_cnt_pr - 1];
           byte_cnt_nx = byte_cnt_pr;
           configured = 0;
           config_cnt_nx = config_cnt_pr;
           if (bit_cnt_pr==8) begin
              bit_cnt_nx = 0;
              state_sda_nx = 5;
           end
           else begin
              bit_cnt_nx = bit_cnt_pr;
              state_sda_nx = 4;
           end
        end // case: 4
        5 : begin  /* Data ack. */
           sda_reg = 1'bz;
           bit_cnt_nx = 0;
           byte_cnt_nx = byte_cnt_pr + 1;
           config_cnt_nx = config_cnt_pr;
           configured = 0;
           if (!nack) begin
              if (byte_cnt_pr<2) begin
                 state_sda_nx = 4;
              end
              else begin
                 state_sda_nx = 6;
              end
           end
           else begin
              state_sda_nx = 0;
           end
        end // case: 5
        6 : begin  /* Stop. */
           sda_reg = 0;
           bit_cnt_nx = 0;
           byte_cnt_nx = 0;
           config_cnt_nx = config_cnt_pr + 1;
           configured = 0;
           state_sda_nx = 7;
        end
        7 : begin  /* Hold. */
           sda_reg = 1;
           bit_cnt_nx = 0;
           byte_cnt_nx = 0;
           if (config_cnt_pr<4) begin
              configured = 0;
              state_sda_nx = 1;
           end
           else begin
              configured = 1;
              state_sda_nx = 0;
           end
        end // case: 7
      endcase // case (state)
   end // always @ (negedge clk_scl)


   /*********************** SCL FSM ***************************/

   // SCL state register.
   always @(negedge clk_scl) begin
      state_scl_pr <= state_scl_nx;
   end

   // SCL combinational logic.
   always @(*) begin
      case (state_scl_pr)
        0 : begin  /* Idle. */
           scl = 1;
               if (
                   !sda) begin
              state_scl_nx = 2;
           end
           else begin
              if (start) begin
                 state_scl_nx = 1;
              end
              else begin
                 state_scl_nx = 0;
              end
           end // else: !if(sda==0)
        end
        1 : begin  /* Start. */
           scl = 1;
           state_scl_nx = 2;
        end
        2 : begin  /* Address frame. */
           scl = clk_scl;
           if (bit_cnt_pr==8) begin
              state_scl_nx = 3;
           end
           else begin
              state_scl_nx = 2;
           end
        end
        3 : begin  /* Address ack. */
           scl = clk_scl;
           if (!nack) begin  // If slave is responsive transition to write data state.
              state_scl_nx = 4;
           end
           else begin  // Else return to idle state.
              state_scl_nx = 0;
           end
        end // case: 3
        4 : begin  /* Data frame. */
           scl = clk_scl;
           if (bit_cnt_pr==8) begin
              state_scl_nx = 5;
           end
           else begin
              state_scl_nx = 4;
           end
        end // case: 4
        5 : begin  /* Data ack. */
           scl = clk_scl;
           if (!nack) begin
              if (byte_cnt_pr<2) begin
                 state_scl_nx = 4;
              end
              else begin
                 state_scl_nx = 6;
              end
           end
           else begin
              state_scl_nx = 0;
           end
        end // case: 5
        6 : begin  /* Stop. */
           scl = clk_scl;
           state_scl_nx = 7;
        end
        7 : begin  /* Hold. */
           scl = 1;
           if (config_cnt_pr<4) begin
              state_scl_nx = 1;
           end
           else begin
              state_scl_nx = 0;
           end
        end // case: 7
      endcase // case (state_scl_pr)
   end // always @ (*)

endmodule // i2c
