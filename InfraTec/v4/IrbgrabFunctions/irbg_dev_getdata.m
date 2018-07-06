function result=irbg_dev_getdata(handle, what, memHandle)
result=calllib('irbgrablib', 'irbgrab_dev_getdata', handle, what, memHandle);
