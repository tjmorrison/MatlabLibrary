function result=irbacs_GetParamS( irbfileHandle, whatParam, stringValue ) 
result=calllib('irbacslib', 'getParamS', irbfileHandle, whatParam, stringValue);
