# VeeR EL2 — IHP SG13G2 / LibreLane 3.x

เริ่มที่ [คู่มือภาษาไทย](VeeR_EL2_Full_Chip_Guide_TH.md) และ [ผลทดสอบ](VALIDATION.md)

Baseline: EL2 AHB-Lite, ICCM/DCCM/I-cache disabled, 256-byte mask ROM,
256-byte synthesized RAM, 8-bit GPIO, 22 IHP pads, 50 MHz target.
No external bootloader, JTAG access, interrupts, UART, or integrated SRAM macro.

```bash
nix-shell
make preflight schema
make test
make pdk
make validate
make full
make klayout
```

Full-chip RTL, stage commands and sign-off procedure are provided.
RTL simulation and SoC Slang/Yosys structural checks were run successfully.
PDK-aware configuration load, technology mapping, P&R, STA, DRC and LVS were NOT run.
Do not interpret “ready to run” as a verified GDSII or tape-out-ready claim.
The pinned environment is LibreLane 3.0.0 from the supplied template flake.lock.
Read VALIDATION.md for exact testing tools, limitations and warning handling.
