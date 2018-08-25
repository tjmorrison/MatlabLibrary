function result=irbg_dev_connect( Handle )
pEmptyDevString = libpointer('string'); 
result=calllib('irbgrablib', 'irbgrab_dev_connect', Handle, pEmptyDevString );
