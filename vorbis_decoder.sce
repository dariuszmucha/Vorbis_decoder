//mclose('all');
//clear;
exec('get_pages_from_ogg.sci', -1);
exec('get_ident_vorbis.sci', -1);
exec('get_comment_vorbis.sci', -1);
exec('get_setup_vorbis.sci', -1);
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
    source(i) = mget(1,'uc',FILE);
    i = i + 1;      
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

printf('Get identification struc \n');
[identStruc, current_position] = get_ident_vorbis(pageStruc, current_position);

printf('Get comment struc \n');
[commentStruc, current_position] = get_comment_vorbis(pageStruc, current_position);

printf('Get setup struc \n');
[setupStruc, current_position] = get_setup_vorbis(pageStruc, current_position);



