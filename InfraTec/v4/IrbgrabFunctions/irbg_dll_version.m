function result=irbg_dll_version( pCharBuf, nStrMaxLen)
result=calllib('irbgrablib', 'irbgrab_dll_version', pCharBuf, nStrMaxLen);
