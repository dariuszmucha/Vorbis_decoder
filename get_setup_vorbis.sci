function setupStruc = get_setup_vorbis()
    setupStruc = -1;

    // first byte - packet type - must be equal to 5
    while oggPagesNextPacket() ~= 5
    end

    // byte 2:7 must be 'vorbis'
    if ~isequal(oggPagesGetNextByte(6), ascii('vorbis')') then
        printf("Vorbis Setup: Error, identification header - incorrect format \n");
    end
    
    // Codebooks count
    setupStruc.codebook_count = oggPagesGetNextByte() + 1;

    // Retrieve codebooks
    for i = 1:setupStruc.codebook_count
        // Next should be sync pattern
        if ~isequal(oggPagesGetNextByte(3), hex2dec(['42'; '43'; '56'])) then
            printf("Vorbis Setup: Error, Sync pattern not found \n");
            break;
        end
        setupStruc.codebooks(i).codebook_dimensions = convertMSBtoLSB(oggPagesGetNextByte(2), 2);
        setupStruc.codebooks(i).codebook_entries = convertMSBtoLSB(oggPagesGetNextByte(3), 3);
        flags = oggPagesGetNextByte();
        setupStruc.codebooks(i).ordered = bitand(flags,1);
        if ~setupStruc.codebooks(i).ordered then
            setupStruc.codebooks(i).sparse = bitand(flags,2) / 2;
            if setupStruc.codebooks(i).sparse then
                if bitand(flags, 4) then
                    setupStruc.codebooks(i).codeword_length = (bitand(flags, 248) / 8) + 1;
                else
                    setupStruc.codebooks(i).codeword_length = 0;
                end
            else
                setupStruc.codebooks(i).codeword_length = (bitand(flags, 248) / 8) + 1;
            end
            // Get Codebook
            setupStruc.codebooks(i).codebook = oggPagesGetNextByte(setupStruc.codebooks(i).codeword_length);
        else
            printf("Vorbis Setup: Error, ordered flag set - not supported \n");
            break;
        end
    end

endfunction;
