function [commentStruc, new_position] = get_comment_vorbis(source, current_position)
    exec('convertMSBtoLSB.sci', -1);
    commentStruc = -1;
    //comment should be in page 2 - for now
    new_position.page = 2;
    new_position.packet = 1;
    new_position.element = 1;
    
    // first byte - packet type - must be equal to 1
    if pageStruc(1).packet(1) ~= 1 then
        printf("Error, identification header - incorrect packet type \n");
    end
    // byte 2:7 must be 'vorbis'
    if ~isequal(pageStruc(1).packet(2:7), ascii('vorbis')) then
        printf("Error, identification header - incorrect format \n");
    end
    
    vendor_length = convertMSBtoLSB(source(2).packet(1,8:11),4) - 1;
    pCurrent = vendor_length + 12;
    
    commentStruc.vendor_name = source(2).packet(1,12:pCurrent);
    pCurrent = pCurrent + 1;
    commentStruc.vendor_name = char(commentStruc.vendor_name);
    
    all_comments_length = convertMSBtoLSB(source(2).packet(1,pCurrent:pCurrent + 3),4);
    pCurrent = pCurrent + 4;
    
    mprintf('all comments_length = %d \n', all_comments_length);
    for i = 1:all_comments_length
        comment_length = convertMSBtoLSB(source(2).packet(1,pCurrent:pCurrent + 3),4) - 1;
        pCurrent = pCurrent + 4;
        commentStruc.comment(i) = ascii(source(2).packet(1,pCurrent:(pCurrent + comment_length)));
        pCurrent = pCurrent + comment_length + 1;
    end
    commentStruc.framing_bit = source(2).packet(1,pCurrent);
    if(commentStruc.framing_bit ~= 1)
        printf("FATAL ERROR : comment framing bit is incorrect");
    end
    
    new_position.page = 2;
    new_position.packet = 1;
    new_position.element = pCurrent + 1;
        
endfunction
