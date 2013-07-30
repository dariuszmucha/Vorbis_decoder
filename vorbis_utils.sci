function out = oggPagesGetNextByte(varargin)
    [lhs,rhs]=argn(0);
    if rhs == 1 then
        elements = varargin(1);
    else
        elements = 1;
    end
    // pageData is global
    global pageData;
    // Get number of pages
    page_count = size(pageData(1).entries);
    page_count = page_count(1);
    // Go to current position
    current_page = pageData(2).entries.current_page;
    current_packet = pageData(2).entries.current_packet;
    current_element = pageData(2).entries.current_element;
    // out buffer index
    i = 1;

    while elements > 0 
        // point to next element
        current_element = current_element + 1;
        // check if element is not in next packet
        if current_element > pageData(1).entries(current_page).segment_table(current_packet) then
            // Element is in next packet
            current_packet = current_packet + 1;
            // Clear current element counter
            current_element = 1;
            // Check if packet is still in this page
            if(current_packet > pageData(1).entries(current_page).page_segments)
                // Element is in next page
                current_page = current_page + 1;
                if current_page > page_count then
                    error(1, 'Reached end of the stream');
                end
                // clear packet counter
                current_packet = 1;
            end
        end
        // Retrieve data
        out(i) = pageData(1).entries(current_page).packet(current_packet).entries(current_element);
        i = i + 1;
        elements = elements - 1;
    end

    //Store current position
    pageData(2).entries.current_page = current_page;
    pageData(2).entries.current_packet = current_packet;
    pageData(2).entries.current_element = current_element;

    // Number of segments in current page
    // pageData(1).entries(current_page).page_segments
    // Number of packets in current segment
    // pageData(1).entries(current_page).segment_table(current_packet)
    // Data
    // pageData(1).entries(current_page).packet(current_packet).entries(current_element);
endfunction

function out = oggPagesGetPrevByte(varargin)
    [lhs,rhs]=argn(0);
    if rhs == 1 then
        elements = varargin(1);
    else
        elements = 1;
    end
    //pageData is global
    global pageData;
    
    // Go to current position
    current_page = pageData(2).entries.current_page;
    current_packet = pageData(2).entries.current_packet;
    current_element = pageData(2).entries.current_element;
    // out buffer index
    i = 1;

    while elements > 0 
        // point to previous element
        current_element = current_element - 1;
        // check if element is not in previous packet
        if current_element <= 0 then
            // Element is in previous packet
            current_packet = current_packet - 1;
            // Check if packet is still in this page
            if(current_packet <= 0 )
                // Element is in next page
                current_page = current_page - 1;
                // clear packet counter
                current_packet = pageData(1).entries(current_page).page_segments;
                // Clear current element counter
                current_element = pageData(1).entries(current_page).segment_table(current_packet);
            else
                // Clear current element counter
                current_element = pageData(1).entries(current_page).segment_table(current_packet);
            end
        end
        // Retrieve data
        out(i) = pageData(1).entries(current_page).packet(current_packet).entries(current_element);
        i = i + 1;
        elements = elements - 1;
    end

    //Store current position
    pageData(2).entries.current_page = current_page;
    pageData(2).entries.current_packet = current_packet;
    pageData(2).entries.current_element = current_element;
endfunction

function out = oggPagesNextPacket(varargin)
    [lhs,rhs]=argn(0);
    if rhs == 1 then
        packets = varargin(1);
    else
        packets = 1;
    end
    // pageData is global
    global pageData;
    // Get number of pages
    page_count = size(pageData(1).entries);
    page_count = page_count(1);
    // Go to current position
    current_page = pageData(2).entries.current_page;
    current_packet = pageData(2).entries.current_packet;
    current_element = pageData(2).entries.current_element;
    // out buffer index
    i = 1;

    while packets > 0 
        // point to next element
        current_packet = current_packet + 1;
        // Clear current element counter
        current_element = 1;
        // Check if packet is still in this page
        if(current_packet > pageData(1).entries(current_page).page_segments)
            // Element is in next page
            current_page = current_page + 1;
            if current_page > page_count then
                error(1, 'Reached end of the stream');
            end
            // clear packet counter
            current_packet = 1;
        end
        packets = packets - 1;
    end
    // Retrieve data
    out = pageData(1).entries(current_page).packet(current_packet).entries(current_element);
    
    //Store current position
    pageData(2).entries.current_page = current_page;
    pageData(2).entries.current_packet = current_packet;
    pageData(2).entries.current_element = current_element;

    // Number of segments in current page
    // pageData(1).entries(current_page).page_segments
    // Number of packets in current segment
    // pageData(1).entries(current_page).segment_table(current_packet)
    // Data
    // pageData(1).entries(current_page).packet(current_packet).entries(current_element);
endfunction

function out = oggPagesGetHeader()
    //pageData is global
    global pageData;
    // Go to current position
    current_page = pageData(2).entries.current_page;
 
    out.header_type_flag = pageData(1).entries(current_page).header_type_flag;
    out.page_segments = pageData(1).entries(current_page).page_segments;

endfunction

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
