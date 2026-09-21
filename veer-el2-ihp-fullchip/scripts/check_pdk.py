from pathlib import Path
import argparse,re
p=Path(__file__).resolve().parents[1]
a=argparse.ArgumentParser();a.add_argument('--pdk-root',required=True);args=a.parse_args()
d=Path(args.pdk_root).expanduser().resolve()/'ihp-sg13g2'
assert (d/'libs.tech/librelane/config.tcl').is_file(), 'Missing built LibreLane PDK config'
io=d/'libs.ref/sg13g2_io'
vs=list((io/'verilog').glob('*.v'));lefs=list((io/'lef').glob('*.lef'))
assert vs and lefs, 'Missing IO Verilog or LEF views'
v='\n'.join(f.read_text() for f in vs);lef='\n'.join(f.read_text() for f in lefs)
mods=['sg13g2_IOPadIn','sg13g2_IOPadOut30mA','sg13g2_IOPadVdd','sg13g2_IOPadVss','sg13g2_IOPadIOVdd','sg13g2_IOPadIOVss']
for m in mods:
 vm=re.search(r'\bmodule\s+'+m+r'\b(.*?)\bendmodule\b',v,re.S)
 lm=re.search(r'\bMACRO\s+'+m+r'\b(.*?)\bEND\s+'+m+r'\b',lef,re.S)
 assert vm and lm, f'Missing IO view: {m}'
 for pin in ['vdd','vss','iovdd','iovss']:
  assert re.search(r'\b'+pin+r'\b',vm[1]),f'{m}: Verilog missing {pin}'
  assert re.search(r'\bPIN\s+'+pin+r'\b',lm[1]),f'{m}: LEF missing {pin}'
print('PASS: required pad cells and four power pins present in IO Verilog/LEF text; preprocessor and connectivity are checked by flow')
