import subprocess,shutil,os,sys
from pathlib import Path
p=Path(__file__).resolve().parents[1];os.chdir(p)
v=shutil.which('yosys') or shutil.which('yowasp-yosys')
if not v:sys.exit('Need Yosys + slang, or yowasp-yosys on PATH')
with (p/'reports/synthesis-elaboration.log').open('w') as f:r=subprocess.run([v]+(['-m','slang'] if Path(v).name=='yosys' else [])+['-T','-s','scripts/elaborate.ys'],stdout=f,stderr=subprocess.STDOUT)
if r.returncode:sys.exit('FAIL: see reports/synthesis-elaboration.log')
print('PASS: SoC synthesis elaboration and check -assert; not technology mapping')
