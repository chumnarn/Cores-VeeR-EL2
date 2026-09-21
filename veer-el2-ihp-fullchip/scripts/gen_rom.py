from pathlib import Path
p=Path(__file__).resolve().parents[1]
w=[int(x,16) for x in (p/'firmware/boot.hex').read_text().split()]
assert len(w)<=64
s="function automatic logic [31:0] rom_word(input logic [5:0] index);\n case(index)\n"
s+=''.join(f" 6'd{i}: rom_word=32'h{v:08x};\n" for i,v in enumerate(w))
s+=" default: rom_word=32'h0000006f;\n endcase\nendfunction\n"
(p/'src/boot_rom.vh').write_text(s)
