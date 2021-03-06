function pageData = ogg_get_pages_to_cell(source)
  
    s = length(source);
    // Predefine structure
    //pageStruc = struct( 'capture_pattern',          0,...    
    //                    'stream_structure_version', 0,...                        
    //                    'header_type_flag',         0,...                                                                
    //                    'absolute_granule_pos',     0,...
    //                    'stream_serial_number',     0,...
    //                    'page_sequence_no',         0,...
    //                    'page_checksum',            0,...
    //                   'page_segments',            0,...
    //                    'segment_table',            0,...
    //                    'packet',                   0);
    // Page data cell :
    // Page data = {PageStruc, PositionStruc}
    // PositionStruc = struct(  'current_page', 0 ...
    //                          'current_packet', 0 ...
    //                          'current_element', 0);
    // Page start string - OggS - capture pattern
    page_start = ascii('OggS');
    // Conuters
    i = 1;
    pageCount = 0;
    packetCount = 1;
    elementCount = 1;
    err_cnt = 0;
    // Iterate through whole source stream
    while(i <= s-4)
        // for now get only 5 pages - TODO improve performance
        if(pageCount > 5)
            break;
        end
        //Compare bits with page start pattern - OggS
        if( isequal(source(i:i+3), page_start) )
            //Beggining of the page, capture all of the setup information
            pageCount = pageCount + 1;
            // Get page information - bytes as in specification
            // Capture pattern - OggS
            pageStruc(pageCount).capture_pattern = source(i:i+3);
            // Stream structure revision
            pageStruc(pageCount).stream_structure_version = source(i+4);
            // Header type flag
            pageStruc(pageCount).header_type_flag = source(i+5);
            // Absolute granule position
            pageStruc(pageCount).absolute_granule_pos = sum(source(i+6:i+13));
            // Stream serial number
            pageStruc(pageCount).stream_serial_number = sum(source(i+14:i+17));
            // page counter
            pageStruc(pageCount).page_sequence_no = sum(source(i+18:i+21));
            // page checksum
            pageStruc(pageCount).page_checksum = sum(source(i+22:i+25));    // TODO add CRC check
            // page segments - number of segments to appear in segment table (segments = packets)
            pageStruc(pageCount).page_segments = source(i+26);
            // Length of each segment (packet)
            pageStruc(pageCount).segment_table = source(i+27:i+pageStruc(pageCount).page_segments+26);
            // Information retrieved, increment iterator
            i = i + pageStruc(pageCount).page_segments + 27; 
            
            // first prepare packet - set length
            pageStruc(pageCount).packet = cell(pageStruc(pageCount).page_segments, 1);

        end;
        
        // cell prepared, iterate through segments (packets)
        for packet_cnt = 1:pageStruc(pageCount).page_segments
            packet_length = pageStruc(pageCount).segment_table(packet_cnt);
            pageStruc(pageCount).packet(packet_cnt).entries = source(i:i+packet_length-1);
            i = i + packet_length;
        end
    end 
    // Pages extracted, initialize position structure - current element to zero, rest to one
    positionStruc.current_page = 1;
    positionStruc.current_packet = 1;
    positionStruc.current_element = 0;
    
    // Create page data structure
    pageData = cell(1,2);
    pageData(1).entries = pageStruc;
    pageData(2).entries = positionStruc;
endfunction
