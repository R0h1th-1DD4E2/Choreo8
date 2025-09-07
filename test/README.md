# Choreo8 Testbench Documentation

This directory contains the testbench and verification environment for the Choreo8 LED Pattern Generator, targeting the Tiny Tapeout platform. The testbench uses [cocotb](https://docs.cocotb.org/en/stable/) for Python-based simulation and verification.

---

## File Overview

| File         | Description                                                                 |
|--------------|-----------------------------------------------------------------------------|
| `tb.v`       | Verilog testbench wrapper for the DUT, connects all ports for cocotb access |
| `test.py`    | Main cocotb test suite for functional and feature verification              |
| `README.md`  | This documentation file                                                     |

---

## Testbench Structure

### 1. `tb.v` – Verilog Wrapper

- Instantiates the top-level module `tt_um_BMSCE_T2`.
- Exposes all required ports (`clk`, `rst_n`, `ena`, `ui_in`, `uo_out`, `uio_in`, `uio_out`, `uio_oe`) for cocotb to drive and monitor.
- Dumps all signals to `tb.vcd` for waveform viewing in GTKWave or Surfer.

### 2. `test.py` – cocotb Test Suite

- **Clock Generation:** Sets up an 8 Hz clock (125 ms period) to match the design's requirements.
- **Reset and Initialization:** Applies reset and initializes all inputs before each test.
- **Test Coverage:**
  - **Pattern Generation:** Verifies all 8 LED patterns at both fast and slow speeds.
  - **Pause Functionality:** Checks that the output freezes when pause is enabled and resumes correctly.
  - **Enable Control:** Ensures pattern changes only occur when `ui_in[5]` (enable) is high.
  - **Reset Behavior:** Confirms all outputs are cleared on reset.
  - **Pattern Switching:** Tests dynamic switching between patterns.
  - **Basic Sanity Check:** Ensures the DUT responds to input changes and produces non-trivial output.
- **Logging:** All test steps and results are logged for easy debugging.

### 3. `README.md` – Usage Instructions

- Explains how to set up and run the testbench.
- Describes how to view simulation waveforms.

---

## How to Run the Testbench

1. **Edit the Makefile:**  
   Ensure `PROJECT_SOURCES` points to your Verilog sources.

2. **Run the Simulation:**
   ```sh
   make -B
   ```

3. **Gate-Level Simulation:**  
   After hardening, copy your gate-level netlist to `gate_level_netlist.v` and run:
   ```sh
   make -B GATES=yes
   ```

4. **View Waveforms:**  
   - With GTKWave:
     ```sh
     gtkwave tb.vcd tb.gtkw
     ```
   - With Surfer:
     ```sh
     surfer tb.vcd
     ```

---

## Test Inputs and Controls

- **`ui_in[2:0]`**: Pattern select (0–7)
- **`ui_in[3]`**: Speed select (0 = fast, 1 = slow)
- **`ui_in[4]`**: Pause (1 = pause, 0 = run)
- **`ui_in[5]`**: Enable (1 = accept new pattern/control, 0 = hold)
- **`clk`**: 8 Hz system clock
- **`rst_n`**: Active-low reset

---

## Test Coverage Summary

- **All patterns** are exercised at both speeds.
- **Pause and resume** are tested for correct state retention.
- **Enable gating** is verified for pattern selection.
- **Reset** is checked for proper output clearing.
- **Pattern switching** is validated for dynamic operation.

---

## References

- [Tiny Tapeout Testing Guide](https://tinytapeout.com/hdl/testing/)
- [cocotb Documentation](https://docs.cocotb.org/en/stable/)

