function [identStruc, new_position] = get_ident_vorbis(pageStruc, current_position) 
    // First page should include stream information 
    // If header type flag bit 2 is not set it is not first page
    if ~(pageStruc(1).header_type_flag & 2) then
        printf("Error, not the first frame ! \n");
        identStruc = -1;
    elseif (pageStruc(1).page_segments ~= 1) then
        printf("Error, more packets than 1 in the first frame \n");
        identStruc = -1;
    else
    // first byte - packet type - must be equal to 1
    if pageStruc(1).packet(1) ~= 1 then
        printf("Error, identification header - incorrect packet type \n");
    end
    // byte 2:7 must be 'vorbis'
    if ~isequal(pageStruc(1).packet(2:7), ascii('vorbis')) then
        printf("Error, identification header - incorrect format \n");
    end
    
    identStruc.vorbis_ver = convertMSBtoLSB(pageStruc(1).packet(8:11), 4);
    if(identStruc.vorbis_ver ~= 0)
        printf("FATAL ERROR : unsupported vorbis version \n");
    end
    identStruc.audio_channels = pageStruc(1).packet(12);
    identStruc.audio_sample_rate = convertMSBtoLSB(pageStruc(1).packet(13:16), 4);
    if(identStruc.audio_channels == 0 | identStruc.audio_sample_rate == 0)
        printf("FATAL ERROR : audio chann or sample rate is zero \n");
    end
    identStruc.bitrate_maximum = convertMSBtoLSB(pageStruc(1).packet(17:20), 4);
    identStruc.bitrate_nominal = convertMSBtoLSB(pageStruc(1).packet(21:24), 4);
    identStruc.bitrate_minimal = convertMSBtoLSB(pageStruc(1).packet(25:28), 4);
    identStruc.blocksize_1 = uint16(pageStruc(1).packet(29)/16);
    identStruc.blocksize_0 = pageStruc(1).packet(29) - identStruc.blocksize_1 * 16;
    identStruc.blocksize_1 = 2 ^ identStruc.blocksize_1;
    identStruc.blocksize_0 = 2 ^ identStruc.blocksize_0;
    if(identStruc.blocksize_1 < identStruc.blocksize_0)
        printf("FATAL ERROR, blocksize 1 < blocksize 0 \n");
    end
    identStruc.framingflag = pageStruc(1).packet(30);
    if(identStruc.framingflag ~= 1)
        printf("FATAL ERROR, framing flag is incorrect \n");
    end
  end
    new_position.page = 1;
    new_position.packet = 1;
    new_position.element = 1;
endfunction
