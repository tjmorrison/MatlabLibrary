function result=irbg_mem_getdimension( MemHnd, Width, Height, PixType )
result=calllib('irbgrablib', 'irbgrab_mem_getdimension', MemHnd, Width, Height, PixType);
