function result=irbacs_GetFrameNumber( irbfileHandle ) 
result=calllib('irbacslib', 'getFrameNumber', irbfileHandle);
