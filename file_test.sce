
printf('start file load');
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
