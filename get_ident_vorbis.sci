function identStruc = get_ident_vorbis() 
    // First page should include stream information 
    // Get header of current page
    header = oggPagesGetHeader();
    if ~(header.header_type_flag & 2) then
        printf("Error, not the first frame ! \n");
        identStruc = -1;
    elseif (header.page_segments ~= 1) then
        printf("Error, more packets than 1 in the first frame \n");
        identStruc = -1;
    else
    // first byte - packet type - must be equal to 1
    if oggPagesGetNextByte() ~= 1 then
        printf("Error, identification header - incorrect packet type \n");
    end
    // byte 2:7 must be 'vorbis'
    if ~isequal(oggPagesGetNextByte(6), ascii('vorbis')') then
        printf("Error, identification header - incorrect format \n");
    end
    
    identStruc.vorbis_ver = convertMSBtoLSB(oggPagesGetNextByte(4), 4);
    if(identStruc.vorbis_ver ~= 0)
        printf("FATAL ERROR : unsupported vorbis version \n");
    end
    identStruc.audio_channels = oggPagesGetNextByte();
    identStruc.audio_sample_rate = convertMSBtoLSB(oggPagesGetNextByte(4), 4);
    if(identStruc.audio_channels == 0 | identStruc.audio_sample_rate == 0)
        printf("FATAL ERROR : audio chann or sample rate is zero \n");
    end
    identStruc.bitrate_maximum = convertMSBtoLSB(oggPagesGetNextByte(4), 4);
    identStruc.bitrate_nominal = convertMSBtoLSB(oggPagesGetNextByte(4), 4);
    identStruc.bitrate_minimal = convertMSBtoLSB(oggPagesGetNextByte(4), 4);
    blocksize_packet = oggPagesGetNextByte();
    identStruc.blocksize_1 = uint16(blocksize_packet/16);
    identStruc.blocksize_0 = blocksize_packet - identStruc.blocksize_1 * 16;
    identStruc.blocksize_1 = 2 ^ identStruc.blocksize_1;
    identStruc.blocksize_0 = 2 ^ identStruc.blocksize_0;
    if(identStruc.blocksize_1 < identStruc.blocksize_0)
        printf("FATAL ERROR, blocksize 1 < blocksize 0 \n");
    end
    identStruc.framingflag = oggPagesGetNextByte();
    if(identStruc.framingflag ~= 1)
        printf("FATAL ERROR, framing flag is incorrect \n");
    end
  end

endfunction
