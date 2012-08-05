//mclose('all');
//clear;
exec('get_pages_from_ogg.sci', -1);
exec('get_ident_vorbis.sci', -1);
exec('get_comment_vorbis.sci', -1);
printf('check if already loaded \n');
if(~exists('source'))
  printf('not loaded \n');
  filename = "ACDC_-_Back_In_Black-sample.ogg";
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

printf('Get pages from ogg source \n');
//pageStruc = get_pages_from_ogg(source);

printf('Get identification struc \n');
identStruc = get_ident_vorbis(pageStruc);

printf('Get comment struc \n');
commentStruc = get_comment_vorbis(pageStruc);



