function result=irbacs_GetIRBIndexes( irbfileHandle, irbIndexes ) 
result=calllib('irbacslib', 'getIRBIndexes', irbfileHandle, irbIndexes) ;
