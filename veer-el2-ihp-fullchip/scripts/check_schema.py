from pathlib import Path
import yaml,json
from librelane.flows import Flow
p=Path(__file__).resolve().parents[1];c=yaml.safe_load((p/'librelane/config.yaml').read_text())
f=Flow.factory.get('Chip');variables=f.get_all_config_variables(f);valid={x.name for x in variables}
unknown=sorted(set(c)-valid-{'meta'})
assert not unknown, f'Unknown Chip config keys: {unknown}'
steps=[s.id for s in f.Steps]
for s in ['Yosys.Synthesis','OpenROAD.GeneratePDN','OpenROAD.CTS','OpenROAD.DetailedRouting']:assert s in steps,s
(p/'reports/chip-steps.txt').write_text('\n'.join(steps)+'\n')
print('PASS: all YAML keys and Makefile stage IDs exist in installed LibreLane; not a PDK-aware config load')
