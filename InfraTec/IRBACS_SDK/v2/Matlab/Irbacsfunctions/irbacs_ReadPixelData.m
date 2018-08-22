function result=irbacs_ReadPixelData( irbfileHandle, pData,  pixValueType ) 
result=calllib('irbacslib', 'readPixelData', irbfileHandle, pData, pixValueType ) ;
