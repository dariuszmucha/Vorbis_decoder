//mclose('all');
clear;
clearglobal pageData;
global pageData;
exec('get_ident_vorbis.sci', -1);
exec('get_comment_vorbis.sci', -1);
exec('get_setup_vorbis.sci', -1);
exec('vorbis_utils.sci', -1);
exec('ogg_get_pages_to_cell.sci', -1);
printf('check if already loaded \n');
if(~exists('source'))
    printf('not loaded \n');
    filename = "sample.ogg";
    [FILE, err] = mopen(filename, 'rb');
    if(err)
        printf('Error fopen\n');
    end;
    i = 1;
    while(~meof(FILE))
        tmp = mget(10000,'uc',FILE);
        tmp_length = length(tmp)-1;
        source(i:i+tmp_length) = tmp;
        i = i + tmp_length + 1;     
    end;
    err = mclose(FILE);
    printf('load completed %d %d\n', size(source));
end;

if(~exists('pageStruc'))
    printf('Get pages from ogg source \n');
    pageData = ogg_get_pages_to_cell(source);
    
end;

// Proceed, when finished header is returned with new position in pages stream
printf('Get identification struc \n');
ident_header = get_ident_vorbis();
printf('Get comment struc \n');
comment_header = get_comment_vorbis();
printf('=============================================================================\n');
printf('### Track info : \n');
comment_size = size(comment_header.comment);
for i = 1:comment_size(1)
    comment = comment_header.comment(i);
    printf('%s \n', comment);
end
printf('%s \n\n', comment_header.vendor_name);
printf('Audio channels : %d \n', ident_header.audio_channels);
printf('Sample rate : %d Hz \n', ident_header.audio_sample_rate);
printf('Bitrate Maximum : %d \n', ident_header.bitrate_maximum);
printf('Bitrate Nominal : %d \n', ident_header.bitrate_nominal);
printf('Bitrate Minimal : %d \n', ident_header.bitrate_minimal);
printf('=============================================================================\n');
printf('Get setup struc \n');
setup_header = get_setup_vorbis();



