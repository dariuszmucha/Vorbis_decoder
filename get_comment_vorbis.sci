function commentStruc = get_comment_vorbis(source)
    exec('convertMSBtoLSB.sci', -1);
    commentStruc = -1;
    //comment should be in page 2
    vendor_length = convertMSBtoLSB(source(2).packet(1,8:11),4) - 1;
    pCurrent = vendor_length + 12;
    commentStruc.vendor_name = source(2).packet(1,12:pCurrent);
    comments_length = convertMSBtoLSB(source(2).packet(1,pCurrent+1:pCurrent+4),4);
    for i = 1:1:comments_length
        //do nothing now
    end
    pCurrent = pCurrent + 5;
    commentStruc.framing_bit = source(2).packet(1,pCurrent);
    if(commentStruc.framing_bit ~= 1)
        printf("FATAL ERROR : comment framing bit is incorrect");
    end
    
    
endfunction