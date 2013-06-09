function out = convertMSBtoLSB(in_array, s)
    i = 0;
    out = 0;
    while i < s 
        shift = (s - i - 1) * 256;
        if(shift == 0)
            shift = 1;
        end;
        out = out + in_array(s - i) * shift;
        i = i + 1;
    end
endfunction

function out = convertMSBtoLSB_2(in_array, s)
    i = 0;
    out = 0;
    while i < s 
        shift = (s - i - 1) * 256;
        if(shift == 0)
            shift = 1;
        end;
        out = out + in_array(s - i) * shift;
        i = i + 1;
    end
endfunction
