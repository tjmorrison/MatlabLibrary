function result=irbacs_ReadIRBDataUncompressed( irbfileHandle, pData ) 
result=calllib('irbacslib', 'readIRBDataUncompressed', irbfileHandle, pData ) ;
