from pathlib import Path
import argparse
from librelane.flows import Flow
p=Path(__file__).resolve().parents[1]
a=argparse.ArgumentParser();a.add_argument('--pdk-root',required=True);args=a.parse_args()
f=Flow.factory.get('Chip')(str(p/'librelane/config.yaml'),pdk='ihp-sg13g2',pdk_root=str(Path(args.pdk_root).resolve()))
(p/'reports/resolved-config.json').write_text(f.config.dumps())
print('PASS: complete LibreLane config resolved with installed PDK')
