function pageStruc = get_pages_from_ogg(source)
  
  s = size(source);
  
  pageCount = 0;
  pageStruc = struct('capture_pattern',0,'stream_structure_version',0,'header_type_flag',0,'absolute_granule_pos',0,'stream_serial_number',0,'page_sequence_no',0,'page_checksum',0,'page_segments',0,'segment_table',0,'packet',0);
  
  elementCount = 1;
  err_cnt = 0;
  
  i = 1;
  packetCount = 1;
  while(i <= s(1)-4)
    if(source(i) == ascii('O') & source(i+1) == ascii('g') & source(i+2) == ascii('g') & source(i+3) == ascii('S'))
      pageCount = pageCount + 1;
      elementCount = 1;
      packetCount = 1;
      packet = 1;
      printf('.');
      pageStruc(pageCount).capture_pattern = source(i:i+3);
      pageStruc(pageCount).stream_structure_version = source(i+4);
      pageStruc(pageCount).header_type_flag = source(i+5);
      pageStruc(pageCount).absolute_granule_pos = sum(source(i+6:i+13));
      pageStruc(pageCount).stream_serial_number = sum(source(i+14:i+17));
      pageStruc(pageCount).page_sequence_no = sum(source(i+18:i+21));
      pageStruc(pageCount).page_checksum = sum(source(i+22:i+25));
      pageStruc(pageCount).page_segments = source(i+26);
      pageStruc(pageCount).segment_table = source(i+27:i+pageStruc(pageCount).page_segments+26);
      i = i + pageStruc(pageCount).page_segments + 26 + 1; 
      currentSegmentCount = pageStruc(pageCount).segment_table(packetCount);
      totalSegmentCount = pageStruc(pageCount).page_segments;
    end;
    //pageData(pageCount,elementCount) = source(i);
    //elementCount = elementCount + 1;
  
    packet(packetCount,elementCount) = source(i);
    elementCount = elementCount + 1;
    i = i + 1;
  
    if(elementCount >= currentSegmentCount)      
      packet(packetCount,elementCount) = source(i);
      pageStruc(pageCount).packet = packet;
      packetCount = packetCount + 1;
      i = i + 1;
      if(packetCount < totalSegmentCount)
        currentSegmentCount = pageStruc(pageCount).segment_table(packetCount);
      else
        err_cnt = err_cnt + 1;
      end;
      elementCount = 1;
    end;
  end
   
endfunction