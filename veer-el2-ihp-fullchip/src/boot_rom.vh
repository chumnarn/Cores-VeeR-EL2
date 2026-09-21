function automatic logic [31:0] rom_word(input logic [5:0] index);
 case(index)
 6'd0: rom_word=32'h100000b7;
 6'd1: rom_word=32'h05a00113;
 6'd2: rom_word=32'h0020a023;
 6'd3: rom_word=32'h0000a183;
 6'd4: rom_word=32'h02219a63;
 6'd5: rom_word=32'h0a500113;
 6'd6: rom_word=32'h002082a3;
 6'd7: rom_word=32'h0050c183;
 6'd8: rom_word=32'h02219263;
 6'd9: rom_word=32'h00209323;
 6'd10: rom_word=32'h0060d183;
 6'd11: rom_word=32'h00219c63;
 6'd12: rom_word=32'h200000b7;
 6'd13: rom_word=32'h0a500113;
 6'd14: rom_word=32'h0020a023;
 6'd15: rom_word=32'h0000006f;
 6'd16: rom_word=32'h00000013;
 6'd17: rom_word=32'h200000b7;
 6'd18: rom_word=32'h0ee00113;
 6'd19: rom_word=32'h0020a023;
 6'd20: rom_word=32'h0000006f;
 default: rom_word=32'h0000006f;
 endcase
endfunction
