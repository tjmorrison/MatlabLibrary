function result=irbacs_GetFrameCount( irbfileHandle ) 
result=calllib('irbacslib', 'getFrameCount', irbfileHandle);
