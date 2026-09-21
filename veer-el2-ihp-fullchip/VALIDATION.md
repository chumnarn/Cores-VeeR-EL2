# Validation record — 2026-09-20

## Summary

The baseline was tested at AHB slave, EL2 SoC and complete chip RTL levels.
Yosys/Slang structural synthesis elaboration of `el2_soc` passed.
**No technology-mapped netlist or GDSII has been produced or verified.**

## Tests actually executed

| Check | Result | Evidence |
|---|---|---|
| EL2 configuration generation | PASS | `reports/config-generation.log`, `snapshots/baseline/` |
| Required local files/include paths | PASS | `reports/preflight.log` |
| Exact 22 signal/supply pad instances and YAML coverage | PASS | `reports/preflight.log` |
| LibreLane 3.0.0 key registry / selected stage IDs | PASS | `reports/schema-check.log`, `reports/chip-steps.txt` |
| AHB 64-bit RAM, byte and halfword preservation | PASS | `reports/ahb-run.log` |
| Back-to-back AHB address/data phases | PASS | `reports/ahb-run.log` |
| AHB GPIO access, two-cycle ERROR and recovery | PASS | `reports/ahb-run.log` |
| EL2 real instruction execution, RAM comparisons | PASS | `reports/soc-run.log`; retired=15 at pass |
| SoC GPIO success code | PASS | GPIO `0xA5`, PC `0x00000038` at observation |
| Chip top with IHP IO functional models and explicit power ports | PASS | `reports/chip-run.log` |
| SoC Yosys/Slang elaboration + process conversion + optimization + check | PASS | `reports/synthesis-elaboration.log`: `Found and reported 0 problems.` |
| Python script syntax | PASS | `reports/package-check.log` |
| Makefile command expansion | PASS | `reports/package-check.log` |
| Deliverable manifest consistency | PASS at packaging | `MANIFEST.sha256`; verify before modifications |

The AHB standalone test includes one complete 64-bit word, a byte write at
lane 5, a halfword write at lanes 6–7, consecutive writes to different addresses,
GPIO read/write, unmapped access, a ROM write and a misaligned access.
The CPU firmware independently performs `sw/lw`, `sb/lbu`, `sh/lhu` and compares
results before writing PASS. Chip simulation includes pad functionality and
reset synchronization. These tests are directed smoke tests, not complete ISA
or AHB compliance verification.

## Tools used for local verification

- Configuration registry and CLI inspection: Python LibreLane **3.0.0**.
- Simulation: PyPI Verilator distribution, reporting **Verilator 5.49**;
  version banner `rev vUNKNOWN-built20260516-4e853d8`.
- C++ compilation: host GCC-compatible `c++`, with the wheel's missing PCH
  include setting supplied as `CFG_CXXFLAGS_PCH_I=-include`.
- Structural synthesis elaboration: **YoWASP Yosys 0.69**, git `9f75ca1f9`,
  with built-in `read_slang`, single compilation unit and one parser thread.
- Pinned implementation environment supplied to the user: **LibreLane 3.0.0**
  from the upstream template flake.lock, with Perl JSON added to shell packages.

The local Yosys/Slang and Verilator are **not** the exact executables resolved
by the supplied Nix lock. Therefore successful local elaboration does not prove
that the pinned implementation frontend handles every construct identically.
Run `make test`, `make validate` and the real LibreLane synthesis stage in the
Nix environment before treating it as the implementation baseline. Nix shell
resolution itself was not executed here.

## Warning disposition

Builds use `-Wno-fatal`; warnings were retained, not globally erased.

| Build | Warning categories counted in final log |
|---|---|
| AHB | TIMESCALEMOD 1 |
| SoC | TIMESCALEMOD 227; WIDTHTRUNC 185; WIDTHEXPAND 98 |
| Chip | SPECIFYIGN 10; TIMESCALEMOD 227; WIDTHTRUNC 185; WIDTHEXPAND 98 |

Final build logs contained no `%Error`, PINMISSING, PINNOTFOUND or LATCH
warning categories. Width warnings predominantly arise from upstream parameter
widths and conditions. This is a review record, not a sign-off waiver. Timing
specify blocks in the IO models are ignored by Verilator; the pad test is
functional zero-delay simulation. Timescale warnings arise from upstream
modules without explicit timescales; project testbenches have explicit units.

The structural check found zero undriven/conflicting-wire problems in the
optimized SoC. Statistics include **21,559 word-level cells**, **5 memories**,
**6,144 memory bits**. These are intermediate RTL statistics, **not** IHP mapped
cell counts, physical area, SRAM-macro count or PPA estimates. No `$dlatch` cell
was listed in the final statistics. `check -assert` is not formal equivalence.

## Not executed / still required

| Item | Status and reason |
|---|---|
| Full built PDK install at pinned Ciel revision | NOT COMPLETED; fetch timed out |
| PDK-aware config load | NOT RUN; no complete enabled PDK |
| Nix environment build | NOT RUN |
| IHP technology mapping | NOT RUN |
| Pad-ring/PDN generation in OpenROAD | NOT RUN |
| Placement, CTS, routing and RC extraction | NOT RUN |
| STA setup/hold and electrical limits | NOT RUN |
| DRC, LVS, antenna, seal-ring/filler/density checks | NOT RUN |
| IR drop / EM / packaging checks | NOT RUN |
| Gate-level simulation and SDF | NOT RUN; no mapped netlist |
| Formal equivalence / RISC-V architectural compliance | NOT RUN |
| ICCM/DCCM/cache/SRAM macros/JTAG/interrupts | Outside baseline configuration |

Partial reference IO Verilog/LEF files were inspected from the IHP source
repository. That is not equivalent to installing the complete pinned physical
PDK. No synthetic PDK, fabricated metrics, or skipped-checker sign-off result
has been substituted for missing physical verification.

## Reproduce

```bash
python3 scripts/verify_manifest.py
nix-shell
make preflight schema
make test
make pdk
make validate
make synthesis
make floorplan
make cts
make route
make full
make metrics
```

The staged physical commands each start a new run from the beginning.
For an existing PDK, pass `PDK_ROOT=/actual/root` consistently. The standalone
structural test is `make synth-elab` with Yosys + Slang or YoWASP installed.

The optional `scripts/run_gl.py` and PDK-aware validation scripts have been
syntax checked and reviewed against the LibreLane 3.0.0 API, but have not been
end-to-end executed with a mapped design/complete PDK. Their remaining checks
are deliberately exposed rather than reported as passed.
