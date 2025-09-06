/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_BMSCE_T2 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire speed_sel = ui_in[3]; // Using only 1 bit for speed control
  wire pause     = ui_in[4]; // Using ui_in[4] as pause
  wire pat_sel   = ui_in[2:0]; // Using ui_in[2:0] for pattern selection
  wire [7:0] led_out;          // LED output  
  
  led_pattern_generator lpg (
      .clk        (clk),
      .ena        (ena),
      .rst_n      (rst_n),
      .pat_sel    (pat_sel),
      .speed_sel  (speed_sel), // Using only 1 bit for speed control
      .pause      (pause), // Using ui_in[4] as pause control
      .led_out    (led_out)
  );

  assign uo_out = led_out; // Connect the LED output to the dedicated outputs
  assign uio_out = 8'b0;    // Not used
  assign uio_oe  = 8'b0;    // Not used

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0, ui_in[7:5], uio_in[7:0]};

endmodule
