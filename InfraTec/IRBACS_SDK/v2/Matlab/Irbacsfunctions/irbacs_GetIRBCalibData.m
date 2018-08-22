function result=irbacs_GetIRBCalibData( irbfileHandle, IRBCalibData )
result=calllib('irbacslib', 'getIRBCalibData', irbfileHandle, IRBCalibData );
