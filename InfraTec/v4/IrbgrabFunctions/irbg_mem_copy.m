function result=irbg_mem_copy( aSrcPtr, aDstPtr, nByteMemSz )
result=calllib('irbgrablib', 'misc_movmem', aSrcPtr, aDstPtr, nByteMemSz);
