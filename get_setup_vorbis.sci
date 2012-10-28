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
    //skip voribs string (7 elements)
    elCurrent = elCurrent + 7;
    //get codebook count
    setupStruc.codebook_count = source(pageCurrent).packet(pkgCurrent,elCurrent) + 1;
    //main loop, get all codebooks
    for(count = 1:1)//setupStruc.codebook_count)
        //check codebook sync pattern 0x564342
        if((source(pageCurrent).packet(pkgCurrent,elCurrent+1)~=66)|(source(pageCurrent).packet(pkgCurrent,elCurrent+2)~=67) | (source(pageCurrent).packet(pkgCurrent,elCurrent+3)~= 86))
            printf('Get setup voribs - FATAL error, wrong pattern');
        end;
        //get codebook dimensions
        setupStruc.codebook(count).dimensions = source(pageCurrent).packet(pkgCurrent,elCurrent+4) + source(pageCurrent).packet(pkgCurrent,elCurrent+5);
        //get codebook entries
        setupStruc.codebook(count).entries = source(pageCurrent).packet(pkgCurrent,elCurrent+6) + source(pageCurrent).packet(pkgCurrent,elCurrent+7) + source(pageCurrent).packet(pkgCurrent,elCurrent+8);
        //get ordered flag
        setupStruc.codebook(count).ordered = bitget(source(pageCurrent).packet(pkgCurrent,elCurrent+9),8);
        if(setupStruc.codebook(count).ordered)
            printf('ordered missing');
        else
            //not ordered, read each codeword length
            setupStruc.codebook(count).sparse = bitget(source(pageCurrent).packet(pkgCurrent,elCurrent+9),7);
            if(setupStruc.codebook(count).sparse)
                printf('sparse is set madafaka ');
            else
                //read length - 5 bits
                setupStruc.codebook(count).length = bitand(source(pageCurrent).packet(pkgCurrent,elCurrent+9),62)/2 + 1;
            end
        end
        
    end;
    new_position.page = pageCurrent;
    new_position.packet = pkgCurrent;
    new_position.element = elCurrent;
endfunction;