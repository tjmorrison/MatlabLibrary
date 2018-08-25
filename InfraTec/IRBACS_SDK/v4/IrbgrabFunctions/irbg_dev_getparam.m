function result=irbg_dev_getparam( Handle, what, dataPtr, dataType )
result=calllib('irbgrablib', 'irbgrab_dev_getparam', Handle, what, dataPtr, dataType );
