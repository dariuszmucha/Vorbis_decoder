function [setupStruc, new_position] = get_setup_vorbis(source, current_position)
    setupStruc = -1;
    pkgCurrent = current_position.packet;
    pageCurrent = current_position.page;
    elCurrent = current_position.element + 1;
    //check if still in current packet
    if( source(pageCurrent).segment_table(pkgCurrent) < elCurrent )
        pkgCurrent = pkgCurrent + 1;
        elCurrent = 1;
    end;
    //skip voribs string
    elCurrent = elCurrent + 7;
    codebook_count = source(pageCurrent).packet(pkgCurrent,elCurrent) + 1;
    printf('%d %d %d %d', pageCurrent, pkgCurrent, elCurrent, codebook_count);
    
    
    new_position.page = pageCurrent;
    new_position.packet = pkgCurrent;
    new_position.element = elCurrent;
endfunction;