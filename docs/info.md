<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# Choreo8

An 8-LED visual effects controller with multiple animated patterns, speed control, and pause functionality implemented in Verilog for ASIC fabrication.

## What it does

This project creates an engaging LED display controller that generates 8 different animated lighting patterns. From classic Knight Rider effects to random sparkle patterns, it provides a versatile platform for visual displays, status indicators, or decorative lighting applications.

## How it works

The LED Pattern Generator operates on an 8Hz system clock and uses a built-in clock divider to create two speed modes:
- **Fast Mode (speed_sel = 0)**: Patterns update at 4Hz for dynamic effects
- **Slow Mode (speed_sel = 1)**: Patterns update at 1Hz for relaxed viewing

### Core Architecture

1. **Pattern Selection**: A 3-bit input (`pat_sel`) selects from 8 different patterns
2. **Clock Division**: Internal divider creates timing references for pattern updates  
3. **State Machines**: Each pattern uses dedicated state variables to track position and direction
4. **Output Logic**: Combinatorial logic generates the 8-bit LED output based on current pattern state

### Pattern Descriptions

| Pattern | Description | Visual Effect |
|---------|-------------|---------------|
| **Knight Rider** | Two LEDs start at opposite ends, meet in middle, return | Classic "Cylon eye" bouncing effect |
| **Walking Pairs** | Adjacent LED pair walks left-to-right and back | Smooth pair movement with wraparound |
| **Expand/Contract** | LEDs expand from center outward, then contract | Breathing effect from middle |
| **Blink All** | All 8 LEDs flash simultaneously | Simple synchronized blinking |
| **Alternate** | Checkerboard pattern alternates | 10101010 ↔ 01010101 pattern |
| **Marquee** | 3-LED group rotates around the strip | Theater marquee chasing lights |
| **Random Sparkle** | Pseudo-random twinkling using LFSR | Unpredictable sparkle effects |
| **All Off** | All LEDs disabled | System standby mode |

### Key Features

- **Pause Control**: Freeze current pattern state while maintaining position
- **Enable Control**: Module can be disabled while preserving internal state
- **Asynchronous Reset**: Clean initialization of all pattern states
- **Low Resource Usage**: Efficient design suitable for ASIC implementation

## How to test

### Basic Operation

1. **Power On**: Assert `rst_n` (active low reset) to initialize the system
2. **Enable**: Set `ena` high to activate pattern generation
3. **Pattern Selection**: Use `pat_sel[2:0]` to choose desired pattern (000-111)
4. **Speed Control**: Toggle `speed_sel` for fast (0) or slow (1) operation
5. **Pause**: Assert `pause` to freeze current pattern state

### Input Pin Configuration

| Input | Pin | Function | Values |
|-------|-----|----------|---------|
| `ui_in[2:0]` | Pattern Select | Choose active pattern | 000-111 |
| `ui_in[3]` | Speed Select | Control update rate | 0=Fast, 1=Slow |
| `ui_in[4]` | Pause | Freeze pattern | 0=Run, 1=Pause |
| `ui_in[7:5]` | Unused | Reserved for future use | Don't care |

### Output Verification

The 8-bit `uo_out[7:0]` directly drives the LED array. Each bit corresponds to one LED:
- `uo_out[0]` → LED 0 (leftmost)
- `uo_out[7]` → LED 7 (rightmost)

### Expected Behavior

- **Knight Rider**: Should see two LEDs moving inward, meeting, then separating
- **Walking Pairs**: Adjacent LED pair should smoothly traverse the strip
- **Expand/Contract**: LEDs should grow from center, then shrink back symmetrically
- **Random Sparkle**: Should display unpredictable but continuous twinkling
