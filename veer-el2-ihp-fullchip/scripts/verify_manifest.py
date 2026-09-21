from pathlib import Path
import hashlib
p=Path(__file__).resolve().parents[1]
for line in (p/'MANIFEST.sha256').read_text().splitlines():
 expected,name=line.split('  ',1)
 actual=hashlib.sha256((p/name).read_bytes()).hexdigest()
 assert actual==expected,f'File changed: {name}'
print('PASS: all delivery file checksums match (run before modifying/regenerating files)')
