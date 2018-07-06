function result=irbacs_SetParam( irbfileHandle, whatParam, floatValue ) 
result=calllib('irbacslib', 'setParam', irbfileHandle, whatParam, floatValue );
