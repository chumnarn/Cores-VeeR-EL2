from pathlib import Path
import yaml,re,json,subprocess,shutil
p=Path(__file__).resolve().parents[1];c=yaml.safe_load((p/'librelane/config.yaml').read_text())
for f in (p/'sources.f').read_text().split():assert (p/f).is_file(),f
for key in ['VERILOG_FILES','VERILOG_INCLUDE_DIRS','EXTRA_GDS','EXTRA_LEFS']:
 for s in c[key]:assert (p/'librelane'/s.removeprefix('dir::')).exists(),s
assert c['meta']['flow']=='Chip' and c['USE_SLANG'] and '--single-unit' in c['SLANG_ARGUMENTS']
assert 'MACROS' not in c, 'Baseline must not contain stale SRAM instances'
text=(p/'src/chip_top.sv').read_text();pads=re.findall(r'sg13g2_IOPad\w+\s+(\w+)\(',text)
listed=sum([c['PAD_'+x] for x in ['SOUTH','EAST','NORTH','WEST']],[])
assert len(pads)==22 and len(set(listed))==22 and set(pads)==set(listed),(pads,listed)
d=(p/'snapshots/baseline/common_defines.vh').read_text()
assert '`define RV_BUILD_AHB_LITE' in d and '`define RV_FPGA_OPTIMIZE' in d
for n in ['ICCM','DCCM','ICACHE']:
 assert not re.search(r'`define RV_'+n+r'_ENABLE\s+1\b',d),n
assert len((p/'firmware/boot.hex').read_text().split())<=64
print('PASS: local files, include paths, exact 22-pad coverage, baseline config, ROM size')
for t in ['verilator','yosys','openroad','klayout','magic','netgen']:
 print(t+': '+str(shutil.which(t) or 'not on PATH'))
