/* i2c.v
 *
 * Controls the operation of the I2C interface.
 *
 * In order to use this module, a top level module must supply it with a 50MHz reference clock, a
 * start signal (a bit pulse of 1, which does not need to be left on), and the data to write to
 * the slave. It must then wait for the `configured` pin to be pulled high before engaging with the
 * slave if I2C is used as a control interface (`configured` indicates that data transmission has
 * completed successfully).
 */

module i2c (
            // External data and control.
            input        clk_50, // 50 MHz reference clock
            input        start, // Signal to tell module to begin operation.
            input [0:87] data, // Data to transmit over SDA line.
            // I2C output
            inout        sda, // I2C interface is operated by pulling the signals low,
            output reg   scl = 1'b1, // so we initialize them to high.
            // Status
            output reg   configured = 1'b0  // Set this to 1 when configuration is complete
            );

   reg [5:0]             count = 0;     // Used to generate I2C clock.
   reg                   start_ = 0;    /* Internal reg to take over start condition once internal
                                        start is triggered */
   reg                   commence = 0;  // Indicates middle of operation.
   reg                   stop = 0;      // Stop condition once data transfer is complete.
   reg [0:87]            data_;         // Store data to transmit.
   integer               data_count=0;  // Keeps track of current transmitted SDA.
   integer               ack_count=0;   // Keeps track of ACK/NACK signals.
   reg                   ack_nack=0;    // ACK/NACK signal transmitted by slave. ACK=0.
   reg                   pre_config=0;  /* If this is set and the stop condition is triggered,
                                         set `configured` to 1*/
   reg                   we=0;          // write enable - 0 for a write and 1 for read.
   reg                   sda_reg=1;     // Holds SDA value to write.

   assign sda = (we) ? 1'bz : sda_reg;

   // Pass over start and stop control to internal logic.
   always @(start) begin
      if (start==1'b1) begin
         start_ <= 1'b1;
         configured <= 1'b0;  // If we begin a new data transfer, set the configured flag to 0.
      end
   end

   // Pass over data to internal logic.
   always @(posedge start_) begin
      data_ <= data;
   end

   // Generate SCL.
   always @(posedge clk_50) begin
      if (stop==1'b1 && count!=6'd63) begin  // Check for count prevents situation where
         scl <= 1'b1;                         // count could increment over 63.
         count <= count + 1;
      end
      else if (stop==1'b1 && count==6'd63) begin
         if (scl <= 1'b1) begin
            sda_reg <= 1'b1;      // Stop condition.
            if (pre_config==1'b1) begin  // Flag the top level module that configuration is
               configured <= 1'b1;       // complete if all data has been transmitted.
            end
            stop <= 1'b0;     // Clear stop condition since it has already been triggered.
            commence <= 1'b0;
            ack_nack <= 1'b0;
         end else begin
            scl <= 1'b1;
         end
      end
      else if (start_==1'b1) begin
         if (scl==1'b1) begin
            sda_reg <= 1'b0;  // Start condition.
            start_ <= 1'b0;
            commence <= 1'b1;
         end else begin
            scl <= 1'b1;
         end
      end
      else if (commence==1'b1) begin  // Increment counter to drive SCL.
         if (ack_nack==1'b1) begin
            stop <= 1'b1;  // Initiate stop sequence since the slave is non-responsive.
         end else if (count==6'd63) begin
            count <= 0;
            scl <= !scl;
         end else begin
            count <= count + 1;
         end
      end
   end

   // Drive SDA when SCL is low.
   always @(negedge scl) begin
      if (commence==1'b1) begin   // Ensure that all initialization has completed successfully.
         if (ack_count==8) begin  // If the ACK/NACK bit is being transmitted, read that
            ack_count <= 0;       // value and reset the ACK counter.
            we <= 1;              // Prepare SDA to be written to.
         end else if (data_count==7'd88) begin  // If all data has been transmitted, trigger
            pre_config <= 1'b1;                 // a stop condition and set all the appropriate
            data_count <= 7'd0;                 // flags.
            ack_count <= 0;
            stop <= 1'b1;
            we <= 0;
         end else begin  // If the ACK/NACK bit is not being transmitted, write the next data
            we <= 0;     // value to SDA and update the counters.
            sda_reg <= data_[data_count];
            ack_count <= ack_count + 1;
            data_count <= data_count + 1;
         end
      end // if (commence==1'b1)
   end // always @ (negedge scl)

   // SDA data should be written at the positive activating edge of SCL.
   always @(posedge scl) begin
      if (commence==1'b1) begin
         if (ack_count==0) begin
            ack_nack <= sda;
         end
      end
   end
endmodule // i2c
