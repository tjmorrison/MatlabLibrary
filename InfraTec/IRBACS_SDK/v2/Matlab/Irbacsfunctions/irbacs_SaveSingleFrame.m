function result=irbacs_SaveSingleFrame( irbfileHandle, strFileName, pData ) 
result=calllib('irbacslib', 'saveSingleFrame', irbfileHandle, strFileName, pData );
