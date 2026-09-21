import subprocess,sys,shutil,argparse,os
from pathlib import Path
p=Path(__file__).resolve().parents[1];os.chdir(p)
a=argparse.ArgumentParser();a.add_argument('mode',choices=['soc','chip','ahb'],nargs='?',default='soc');args=a.parse_args();mode=args.mode
v=[shutil.which('verilator')] if shutil.which('verilator') else [sys.executable,'-m','verilator']
cmd=v+['--binary','--timing','-j','2','-Wno-fatal','--top-module','tb_'+mode,'--Mdir','build/'+mode,'-Isnapshots/baseline','-Ivendor/el2/design/include','-Isrc']
# PyPI Verilator wheel may omit the GCC precompiled-header include flag.
if len(v)>1:cmd+=['-MAKEFLAGS','CFG_CXXFLAGS_PCH_I=-include']
files=(p/'sources.f').read_text().split()
if mode=='ahb':files=['src/ahb_mem.sv']
if mode=='chip':cmd+=['-DUSE_POWER_PINS'];files+=['vendor/ihp-io/sg13g2_io.v']
cmd+=files+['sim/tb_'+mode+'.sv']
(p/'build').mkdir(exist_ok=True);(p/'reports').mkdir(exist_ok=True)
with (p/f'reports/{mode}-build.log').open('w') as f:
 r=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT)
if r.returncode:sys.exit(f'Build failed: reports/{mode}-build.log')
with (p/f'reports/{mode}-run.log').open('w') as f:
 r=subprocess.run([f'build/{mode}/Vtb_{mode}'],stdout=f,stderr=subprocess.STDOUT)
print((p/f'reports/{mode}-run.log').read_text())
if r.returncode:sys.exit(r.returncode)
if 'PASS:' not in (p/f'reports/{mode}-run.log').read_text():sys.exit('Missing PASS marker')
