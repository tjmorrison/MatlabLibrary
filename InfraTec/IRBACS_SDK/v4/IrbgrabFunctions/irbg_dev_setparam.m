function result=irbg_dev_setparam( Handle, what, dataPtr, dataType )
result=calllib('irbgrablib', 'irbgrab_dev_setparam', Handle, what, dataPtr, dataType );
