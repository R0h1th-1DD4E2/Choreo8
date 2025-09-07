// Description: LED Pattern Generator Module
// breifs controls an 8-bit LED output with multiple selectable patterns.


// Inputs:
// - clk:       System clock.
// - ena:       Module enable. When low, patterns freeze.
// - rst_n:     Asynchronous reset, active low.
// - pat_sel:   3-bit pattern selection input.
// - speed_sel: Speed control input (0 is fastest, 1 is slowest).
// - pause:     When high, the current pattern state is held.

// Outputs:
// - led_out: 8-bit output to drive LEDs.


module led_pattern_generator (
    input wire clk,
    input wire ena,
    input wire rst_n,
    input wire [2:0] pat_sel,
    input wire speed_sel,
    input wire pause,
    output reg [7:0] led_out
);
//----------------------------------------------------------------
//                         Internal registers
//----------------------------------------------------------------
reg [2:0] pattern;
reg toggle_state;
reg [7:0]marquee_reg;
reg [7:0] lfsr;
reg [2:0] expand_pose;
reg [1:0] knight_pos;
reg knight_dir;
reg walk_dir;
reg [2:0] walk_pos;
reg div_clk;
reg [1:0] clk_divider;

//----------------------------------------------------------------
//                     Clock divider logic
//----------------------------------------------------------------

// Input is a 8Hz clock and the speed sel divides it to 4Hz in general and at slow it is 1Hz
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_divider <= 2'b00;
        div_clk <= 1'b0;
    end else if (pause) begin
        div_clk <= div_clk; // Maintain current state
    end else begin
        if (speed_sel == 1'b0) begin
            div_clk <= ~div_clk; // Fastest speed, no division
        end else begin
            clk_divider <= clk_divider + 1;
            if (clk_divider == 2'b11) begin
                div_clk <= ~div_clk; // Toggle every 4 cycles for 1Hz
                clk_divider <= 2'b00;
            end
        end
    end
end

//----------------------------------------------------------------
//                     Pattern selection logic
//----------------------------------------------------------------

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        pattern <= pat_sel;
    // else if (ena) 
    //     pattern <= pat_sel;
    else 
        pattern <= pat_sel; // Maintain current pattern when not enabled
end

//----------------------------------------------------------------
//                     Main Output logic
//----------------------------------------------------------------

always @(posedge div_clk or negedge rst_n) begin

    toggle_state <= ~toggle_state;

    if (!rst_n) begin
        led_out <= 8'b0;                // All LEDs off on reset
        marquee_reg <= 8'b000000111;   // Initial marquee pattern
        lfsr <= 8'b10101010;           // Seed value for LFSR
        toggle_state <= 1'b0;        // Initial toggle state
        expand_pose <= 3'b000;      // Initial expand/contract position
        knight_pos <= 2'b00;       // Initial knight rider position
        knight_dir <= 1'b0;       // Initial knight rider direction
        walk_dir <= 1'b0;        // Initial walking pair direction
        walk_pos <= 3'b000;     // Initial walking pair position
    end else begin
        if (pause) begin
            led_out <= led_out; // Maintain current state
        end
        else begin
            case(pattern)
            //--------------knight rider logic---------------
                3'b000: begin               
                    if (knight_dir == 0) begin
                        led_out <= (8'b10000000 >> knight_pos ) | (8'b00000001 << knight_pos) ; // Move to middle
                        if (knight_pos == 3) begin
                            knight_dir <= 1;  // Change direction at middle
                        end else begin
                            knight_pos <= knight_pos + 1;
                        end
                    end else if (knight_dir == 1) begin
                        led_out <= (8'b10000000 >> knight_pos) | (8'b00000001 << knight_pos); // Move to end
                        if (knight_pos == 0) begin
                            knight_dir <= 0;  // Change direction at ends
                        end else begin
                            knight_pos <= knight_pos - 1;
                        end
                    end
                    else begin
                        led_out <= 8'b10000001; // Initial position
                        knight_pos <= 0;
                        knight_dir <= 0;
                    end
                end


            //--------------walking pair logic---------------
                3'b001: begin
                    if (walk_dir == 0) begin
                        led_out <= (8'b00000011 << walk_pos); // Move right
                        if (walk_pos == 6) begin
                            walk_dir <= 1;  // Change direction at rightmost position
                        end else begin
                            walk_pos <= walk_pos + 1;
                        end
                    end else if (walk_dir == 1) begin
                         led_out <= 8'b00000011 << walk_pos; // Move left
                        if (walk_pos == 0) begin
                            walk_dir <= 0;  // Change direction at leftmost position
                        end else begin
                            walk_pos <= walk_pos - 1;
                        end
                    end
                    else begin
                        led_out <= 8'b00000011; // Initial position
                        walk_pos <= 0;
                        walk_dir <= 0;
                    end
                end


            //--------------expanding/contracting logic---------------
                3'b010: begin
                    case(expand_pose)
                        3'b000: led_out <= 8'b00011000;
                        3'b001: led_out <= 8'b00111100;
                        3'b010: led_out <= 8'b01111110;
                        3'b011: led_out <= 8'b11111111;
                        3'b100: led_out <= 8'b01111110;
                        3'b101: led_out <= 8'b00111100;
                        3'b110: led_out <= 8'b00011000;
                        3'b111: led_out <= 8'b00000000;
                        default: led_out <= 8'b00000000;
                    endcase
                    expand_pose <= expand_pose + 1;
                end


            //--------------blink all logic---------------
                3'b011: begin
                    led_out <= toggle_state ? 8'b11111111 : 8'b00000000;
                end


            //--------------alternate pattern logic---------------
                3'b100: begin
                //alternate pattern
                    led_out <= toggle_state ? 8'b10101010 : 8'b01010101;
                end

            //--------------marquee pattern logic---------------
                3'b101: begin  
                    led_out <= marquee_reg;
                    marquee_reg <= {marquee_reg[6:0], marquee_reg[7]}; // Rotate left
                end
                
            //--------------random sparkle logic---------------
                3'b110: begin
                //random sparkle
                    lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]}; // LFSR feedback
                    led_out <= lfsr;
                end
                
            //--------------all off logic---------------
                3'b111: begin
                    led_out <= 8'h00; // All OFF
                end

            //--------------default logic---------------
                default: led_out <= 8'h00;
            endcase
        end
    end
end
endmodule