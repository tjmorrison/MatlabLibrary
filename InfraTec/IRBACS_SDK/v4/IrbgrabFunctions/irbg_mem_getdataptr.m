function result=irbg_mem_getdataptr(handle, dataPtr, dataSz)
result=calllib('irbgrablib', 'irbgrab_mem_getdataptr', handle, dataPtr, dataSz);
