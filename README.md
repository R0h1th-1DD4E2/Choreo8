![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

## Choreo8 – LED Pattern Generator

## Overview
Choreo8 is an **8-bit LED pattern generator** designed for **Tiny Tapeout**.  
It drives LEDs with multiple selectable patterns, controllable through input switches.  
The design demonstrates sequential logic, pattern generation, speed control, and pause/resume functionality.

---

## Features
- **8 Selectable LED Patterns**:
  - `000` – Knight Rider  
  - `001` – Walking Pair  
  - `010` – Expanding/Contracting  
  - `011` – Blink All  
  - `100` – Alternate Pattern  
  - `101` – Marquee Pattern  
  - `110` – Random Sparkle (LFSR based)  
  - `111` – All OFF  

- **Controls**:
  - `ui_in[2:0]` → Pattern select  
  - `ui_in[3]` → Speed select (0 = fast, 1 = slow)  
  - `ui_in[4]` → Pause (hold current state)  
  - `ui_in[5]` → Enable (pattern active only when high)  

- **Outputs**:
  - `uo_out[7:0]` → LED pattern output  

- **Clock Divider**:
  - Input clock assumed ~8 Hz  
  - Generates slow/fast modes (1 Hz / 4 Hz)  

---

## Pinout
| Pin          | Direction | Description                         |
|--------------|-----------|-------------------------------------|
| `ui_in[2:0]` | Input     | Pattern select (000–111)            |
| `ui_in[3]`   | Input     | Speed select (0 = fast, 1 = slow)  |
| `ui_in[4]`   | Input     | Pause control                       |
| `ui_in[5]`   | Input     | Enable                              |
| `uo_out[7:0]`| Output    | LED pattern output                  |
| `uio_*`      | –         | Not used                            |
| `clk`        | Input     | System clock (~8 Hz expected)       |
| `rst_n`      | Input     | Active-low reset                    |

---

## Usage
1. Set `ui_in[5] = 1` (enable).  
2. Select a pattern with `ui_in[2:0]`.  
3. Adjust speed using `ui_in[3]`.  
4. Pause the animation with `ui_in[4] = 1`.  
5. Reset system with `rst_n = 0`.

---

## Example Configurations
- **Knight Rider, Fast** → `ui_in = 0000_1xxx`  
- **Walking Pair, Slow** → `ui_in = 0011_1xxx`  
- **Blink All, Pause** → `ui_in = 0111_1xxx`  

---
