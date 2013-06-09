//mclose('all');
clear;
exec('get_pages_from_ogg.sci', -1);
exec('get_ident_vorbis.sci', -1);
exec('get_comment_vorbis.sci', -1);
exec('get_setup_vorbis.sci', -1);
exec('vorbis_utils.sci', -1);
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
        tmp = mget(1000,'uc',FILE);
        tmp_length = length(tmp) - 1;
        source(i:i+tmp_length) = tmp;
        i = i + tmp_length;      
    end;
    err = mclose(FILE);
    printf('load completed %d %d\n', size(source));
end;

//start decode, save current position
current_position.page = 1;
current_position.packet = 1;
current_position.element = 1;

if(~exists('pageStruc'))
    printf('Get pages from ogg source \n');
    pageStruc = get_pages_from_ogg(source);
end;

// Proceed, when finished header is returned with new position in pages stream
printf('Get identification struc \n');
[ident_header, current_position] = get_ident_vorbis(pageStruc, current_position);

printf('Get comment struc \n');
[comment_header, current_position] = get_comment_vorbis(pageStruc, current_position);

printf('Get setup struc \n');
[setup_header, current_position] = get_setup_vorbis(pageStruc, current_position);



