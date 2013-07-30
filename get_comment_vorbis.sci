function commentStruc = get_comment_vorbis(source, )
    commentStruc = -1;
 
    // first byte - packet type - must be equal to 3
    if oggPagesGetNextByte() ~= 3 then
        printf("Error, identification header - incorrect packet type \n");
    end
    // byte 2:7 must be 'vorbis'
    if ~isequal(oggPagesGetNextByte(6), ascii('vorbis')') then
        printf("Error, identification header - incorrect format \n");
    end
    
    vendor_length = convertMSBtoLSB(oggPagesGetNextByte(4),4);
    
    commentStruc.vendor_name = oggPagesGetNextByte(vendor_length);
    commentStruc.vendor_name = char(commentStruc.vendor_name');
    
    all_comments_length = convertMSBtoLSB(oggPagesGetNextByte(4),4);
    
    mprintf('all comments_length = %d \n', all_comments_length);
    for i = 1:all_comments_length
        comment_length = convertMSBtoLSB(oggPagesGetNextByte(4),4);
        commentStruc.comment(i) = ascii(oggPagesGetNextByte(comment_length));
    end
    commentStruc.framing_bit = oggPagesGetNextByte();
    if(commentStruc.framing_bit ~= 1)
        printf("FATAL ERROR : comment framing bit is incorrect");
    end
          
endfunction
