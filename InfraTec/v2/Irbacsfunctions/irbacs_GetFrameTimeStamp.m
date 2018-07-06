function result=irbacs_GetFrameTimeStamp( irbfileHandle, timestamp ) 
refTimestamp = libpointer('TSYSTEMTIME', timestamp);
result=calllib('irbacslib', 'getFrameTimeStamp', irbfileHandle, refTimestamp ) ;
