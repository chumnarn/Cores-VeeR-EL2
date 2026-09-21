"""Optional zero-delay GLS after a successful full flow; requires Icarus 11+."""
import argparse,subprocess,os
from pathlib import Path
p=Path(__file__).resolve().parents[1]
a=argparse.ArgumentParser();a.add_argument('--netlist',required=True);a.add_argument('--stdcell-v',required=True);a.add_argument('--io-v',required=True);args=a.parse_args()
files=[str(Path(x).resolve()) for x in [args.netlist,args.stdcell_v,args.io_v]]
assert all(Path(x).is_file() for x in files)
os.chdir(p);(p/'build').mkdir(exist_ok=True)
# tb_gl uses event-driven polling instead of break, for Icarus compatibility.
subprocess.run(['iverilog','-g2012','-DFUNCTIONAL','-DUSE_POWER_PINS','-s','tb_gl','-o','build/gl.vvp','sim/tb_gl.sv']+files,check=True)
with (p/'reports/gl-run.log').open('w') as f:
 subprocess.run(['vvp','build/gl.vvp'],stdout=f,stderr=subprocess.STDOUT,check=True)
print((p/'reports/gl-run.log').read_text())
