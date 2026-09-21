from pathlib import Path
import json,csv
p=Path(__file__).resolve().parents[1]
files=sorted((p/'librelane/runs').glob('*/**/metrics.json'),key=lambda x:x.stat().st_mtime)
if not files:raise SystemExit('No physical-run metrics found; do not infer sign-off from simulation')
rows=[]
for f in files:
 try:d=json.loads(f.read_text())
 except json.JSONDecodeError:continue
 for k,v in d.items():
  if any(s in k.lower() for s in ['wns','tns','setup','hold','drc','lvs','antenna','unconnected','area','wirelength']):rows.append([str(f.relative_to(p)),k,v])
with (p/'reports/physical-metrics.csv').open('w') as f:
 w=csv.writer(f);w.writerow(['source','metric','value']);w.writerows(rows)
print('Wrote reports/physical-metrics.csv; missing metrics mean unverified, not zero violations')
