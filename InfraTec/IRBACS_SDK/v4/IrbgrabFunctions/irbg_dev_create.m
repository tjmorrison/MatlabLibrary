function result=irbg_dev_create( pHandle, iDevIdx)
pEmptyIniFilename = libpointer('string'); 
result=calllib('irbgrablib', 'irbgrab_dev_create', pHandle, iDevIdx, pEmptyIniFilename);
