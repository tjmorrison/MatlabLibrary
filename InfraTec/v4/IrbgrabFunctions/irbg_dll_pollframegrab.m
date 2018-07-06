function result=irbg_dll_pollframegrab( pHandle, pStreamIdx )
result=calllib('irbgrablib', 'irbgrab_dll_pollframegrab', pHandle, pStreamIdx );
